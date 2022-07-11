import 'package:cloud_firestore/cloud_firestore.dart';

class MessageInfoModel{
  late String id;
  late int unread;

  MessageInfoModel({
    required this.id,
    required this.unread
  });

  MessageInfoModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> messageInfo):
      id = messageInfo.id,
      unread = messageInfo.data()!['unread'];

  Map<String, dynamic> toMap(){
    return {
      'unread': unread
    };
  }
}