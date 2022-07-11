import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceCategoryModel{
  late String id;
  late String name;
  late DateTime createdAt;

  ServiceCategoryModel({
    required this.id,
    required this.name,
    required this.createdAt
  });

  ServiceCategoryModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> category):
        id = category.id,
        name = category.data()!['name'],
        createdAt = category.data()!['createdAt'].toDate();

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt)
    };
  }
}
