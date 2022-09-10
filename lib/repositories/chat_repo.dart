import 'dart:io';

import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/chat_info_model.dart';
import 'package:afro_grids/models/local/local_chat_list_model.dart';
import 'package:afro_grids/repositories/user_repo.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../configs/firestorage_references.dart';
import '../main.dart';
import '../models/chat_model.dart';
import '../models/user_chat_info_model.dart';

class ChatRepo{

  ChatModel? chat;
  final CollectionReference _chatRef;
  final CollectionReference _usersRef;

  ChatRepo({this.chat}): _chatRef = FirestoreRef().chatRef, _usersRef=FirestoreRef().usersRef;

  Future<DocumentSnapshot> getMessageDoc(String chatId, String messageId)async{
    return await _chatRef.doc(chatId).collection("messages").doc(messageId).get();
  }

  Future<QuerySnapshot> fetchChats({
    required String fromId,
    required String toId,
    DocumentSnapshot? cursor,
    int? limit,
  })
  async {

    Query query = _chatRef.doc(generateChatId(fromId, toId)).collection("messages");
    query = query.orderBy('createdAt', descending: true);
    if(cursor != null){
      query = query.startAfterDocument(cursor);
    }
    if(limit != null){
      query = query.limit(limit);
    }
    return await query.get();
  }

  Future<List<LocalChatListModel>> getChatList(String userId)async{
    QuerySnapshot userChatsInfoSnapshot = await _usersRef
        .doc(userId).collection("chat")
        .orderBy("createdAt", descending: true)
        .get();
    Iterable<UserChatInfoModel> userChatsInfo =  userChatsInfoSnapshot.docs.map((doc) => UserChatInfoModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>));
    Iterable<String> receiverIds = userChatsInfo.map((chatInfo) => chatInfo.userId);
    Iterable<String> chatIds = userChatsInfo.map((chatInfo) => chatInfo.chatId);
    var chatMetaFutures = chatIds.map((chatId) => _chatRef.doc(chatId).collection("meta").doc("stats").get());
    var receiversFutures = receiverIds.map((id) => UserRepo().getUser(id));
    var chatMetas = await Future.wait(chatMetaFutures);
    var receivers = await Future.wait(receiversFutures);
    receivers = receivers.where((receiver) => receiver != null).toList();
    List<LocalChatListModel> results = [];
    for(var i=0; i<chatMetas.length; i++){
      results.add(LocalChatListModel(
          user: receivers[i]!,
          chatMeta: ChatInfoModel.fromFirestore(chatMetas[i]),
          chatInfo: userChatsInfo.elementAt(i)
      ));
    }
    return results;
  }

  Stream<QuerySnapshot> getChatsStream(String fromId, String toId, [int limit=25]){
    return _chatRef.doc(generateChatId(fromId, toId))
        .collection("messages").orderBy('createdAt', descending: true)
        .limit(limit).snapshots();
  }

  static String generateChatId(String id1, String id2){
    if(id1.compareTo(id2) == 1){
      return "$id1$id2";
    }
    return "$id2$id1";
  }

  Future<void> sendMessage()async{
    String chatId = generateChatId(chat!.createdBy, chat!.createdFor);
    await _chatRef.doc(chatId).collection("messages").add(chat!.toMap());
    if(!localStorage.activeChatIds.contains(chatId)){
      String? nchatId = await getChatId(senderId: chat!.createdBy, receiverId: chat!.createdFor);
      if( nchatId == null){
        await saveChatId(senderId: chat!.createdBy, receiverId: chat!.createdFor);
      }
    }
    localStorage.activeChatIds.add(chatId);
  }

  Future<void> sendMessageFiles(List<XFile> files) async{
    var uploadTasksFutures = files.map((file){
      return FirebaseStorageReferences()
          .chatRef
          .child("${chat!.id}/${DateTime.now().millisecondsSinceEpoch}.${file.name.split(".").removeLast()}")
          .putFile(File(file.path));
    });
    var uploadTasks = await Future.wait(uploadTasksFutures);
    var uploadURLFutures = uploadTasks.map((task) => task.ref.getDownloadURL());
    var uploadURLs = await Future.wait(uploadURLFutures);
    var resultFutures = uploadURLs.map((url){
      chat!.content = url;
      return sendMessage();
    });
    await Future.wait(resultFutures);
  }

  Future<String?> getChatId({required String senderId, required String receiverId})async{
    var doc = await FirestoreRef().usersRef.doc(senderId).collection("chat").doc(receiverId).get();
    if(doc.exists){
      return UserChatInfoModel.fromFirestore(doc).chatId;
    }
    return null;
  }

  Future<void> saveChatId({required String senderId, required String receiverId})async{
    String chatId = generateChatId(senderId, receiverId);
    UserChatInfoModel userChatInfoModel = UserChatInfoModel(
        userId: "",
        chatId: chatId,
        lastReadMessageId: "",
        createdAt: DateTime.now()
    );
    await FirestoreRef().usersRef.doc(senderId).collection("chat").doc(receiverId).set(userChatInfoModel.toMap());
    await FirestoreRef().usersRef.doc(receiverId).collection("chat").doc(senderId).set(userChatInfoModel.toMap());
  }

  Future<void> saveLastReadMessage(String senderId, String receiverId) async {
    var docRef = FirestoreRef().usersRef.doc(senderId).collection("chat").doc(receiverId);
    var snapshot = await docRef.get();
    if(snapshot.exists){
      UserChatInfoModel userChatInfoModel = UserChatInfoModel.fromFirestore(snapshot);
      userChatInfoModel.lastReadMessageId = chat!.id;
      await docRef.set(userChatInfoModel.toMap());
    }
  }

  Future<QuerySnapshot> getUnreadMessages(
      {
        required String senderId,
        required String receiverId,
        DocumentSnapshot? lastUnreadMsg
      }) async{
    Query query = _chatRef.doc(generateChatId(senderId, receiverId))
        .collection("messages")
        .orderBy("createdAt");
    if(lastUnreadMsg != null){
      query = query.startAfterDocument(lastUnreadMsg);
    }
    return await query.get();
  }

}