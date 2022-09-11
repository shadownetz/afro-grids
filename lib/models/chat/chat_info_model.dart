import 'package:cloud_firestore/cloud_firestore.dart';

class ChatInfoModel{
  late String id;
  late String lastMsg;
  late DateTime lastMsgTimestamp;

  ChatInfoModel({
    required this.id,
    required this.lastMsg,
    required this.lastMsgTimestamp
  });

  ChatInfoModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> messageInfo):
        id = messageInfo.id,
        lastMsg = messageInfo.data()!['lastMsg'],
        lastMsgTimestamp = messageInfo.data()!['lastMsgTimestamp'].toDate();

  Map<String, dynamic> toMap(){
    return {
      'lastMsg': lastMsg,
      'lastMsgTimestamp': lastMsgTimestamp
    };
  }
}