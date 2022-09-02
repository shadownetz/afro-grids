import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/chat_info_model.dart';
import 'package:afro_grids/models/local/local_chat_list_model.dart';
import 'package:afro_grids/repositories/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';
import '../models/chat_model.dart';

class ChatRepo{

  ChatModel? chat;
  final CollectionReference _chatRef;
  final CollectionReference _usersMetaRef;

  ChatRepo({this.chat}): _chatRef = FirestoreRef().chatRef, _usersMetaRef=FirestoreRef().usersMetaRef;

  Future<QuerySnapshot> fetchChats({
    required String fromId,
    required String toId,
    DocumentSnapshot? cursor,
    int? limit=25
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
    QuerySnapshot snapshot = await _usersMetaRef
        .doc(userId).collection("chat")
        .orderBy("createdAt", descending: true)
        .get();
    List<String> receiverIds = snapshot.docs.map((doc) => doc.id).toList();
    var chatIds = snapshot.docs.map((doc) => doc.get("chatId")).toList();
    var chatMetaFutures = chatIds.map((chatId) => _chatRef.doc(chatId).collection("meta").doc("stats").get());
    var receiversFutures = receiverIds.map((id) => UserRepo().getUser(id));
    var chatMetas = await Future.wait(chatMetaFutures);
    var receivers = await Future.wait(receiversFutures);
    receivers = receivers.where((receiver) => receiver != null).toList();
    List<LocalChatListModel> results = [];
    for(var i=0; i<chatMetas.length; i++){
      results.add(LocalChatListModel(
          user: receivers[i]!,
          meta: ChatInfoModel.fromFirestore(chatMetas[i])
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

  Future<String?> getChatId({required String senderId, required String receiverId})async{
    var doc = await FirestoreRef().usersMetaRef.doc(senderId).collection("chat").doc(receiverId).get();
    if(doc.exists){
      return doc.data()!['chatId'];
    }
    return null;
  }

  Future<void> saveChatId({required String senderId, required String receiverId})async{
    String chatId = generateChatId(senderId, receiverId);
    await FirestoreRef().usersMetaRef.doc(senderId).collection("chat").doc(receiverId).set({
      'chatId': chatId,
      'createdAt': FieldValue.serverTimestamp()
    });
    await FirestoreRef().usersMetaRef.doc(receiverId).collection("chat").doc(senderId).set({
      'chatId': chatId,
      'createdAt': FieldValue.serverTimestamp()
    });
  }

}