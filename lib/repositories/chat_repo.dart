import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/chat_info_model.dart';
import 'package:afro_grids/models/local/local_chat_list_model.dart';
import 'package:afro_grids/repositories/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    int? limit
  })
  async {

    Query query = _chatRef.doc(generateChatId(fromId, toId)).collection("messages");
    if(cursor != null){
      query = query.startAfterDocument(cursor);
    }
    query = query.orderBy('createdAt');
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
    List<LocalChatListModel> results = [];
    for(var i=0; i<chatMetas.length; i++){
      results.add(LocalChatListModel(
          user: receivers[i],
          meta: ChatInfoModel.fromFirestore(chatMetas[i])
      ));
    }
    return results;
  }

  Stream<QuerySnapshot> getChatsStream(String fromId, String toId, [int limit=25]){
    return _chatRef.doc(generateChatId(fromId, toId))
        .collection("messages").orderBy('createdAt')
        .limit(limit).snapshots();
  }

  static String generateChatId(String id1, String id2){
    if(id1.compareTo(id2) == 1){
      return "$id1$id2";
    }
    return "$id2$id1";
  }

  Future<void> sendMessage({required ChatModel message, required String toId})async{
    await _chatRef.doc(generateChatId(message.createdBy, toId)).collection("messages").add(message.toMap());
  }

}