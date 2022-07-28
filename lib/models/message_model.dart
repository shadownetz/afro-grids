import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  late String id;
  late String createdBy;
  late String type;
  late String content;
  late DateTime createdAt;

  MessageModel({
    required this.id,
    required this.createdBy,
    required this.type,
    required this.content,
    required this.createdAt
  });

  MessageModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> message):
        id = message.id,
        createdBy = message.data()!['createdBy'],
        type = message.data()!['type'],
        content = message.data()!['content'],
        createdAt = message.data()!['createdAt'].toDate();

  Map<String, dynamic> toMap(){
    return {
      'createdBy': createdBy,
      'type': type,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt)
    };
  }
}