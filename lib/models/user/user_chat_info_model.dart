import 'package:cloud_firestore/cloud_firestore.dart';

class UserChatInfoModel{
  late String userId;
  late String chatId;
  late String lastReadMessageId;
  late DateTime createdAt;

  UserChatInfoModel({
    required this.userId,
    required this.chatId,
    required this.lastReadMessageId,
    required this.createdAt
  });


  UserChatInfoModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> userChatInfo):
        userId = userChatInfo.id,
        chatId = userChatInfo.data()!['chatId'],
        lastReadMessageId = userChatInfo.data()!['lastReadMessageId']??"",
        createdAt = userChatInfo.data()!['createdAt'].toDate();

  Map<String, dynamic> toMap(){
    return {
      'chatId': chatId,
      'lastReadMessageId': lastReadMessageId,
      'createdAt': Timestamp.fromDate(createdAt)
    };
  }

}