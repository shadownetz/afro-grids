import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel{
  late String id;
  late String name;
  late String serviceCategoryId;
  late DateTime createdAt;

  ServiceModel({
    required this.id,
    required this.name,
    required this.serviceCategoryId,
    required this.createdAt
  });

  ServiceModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> service):
        id = service.id,
        name = service.data()!['name'],
        serviceCategoryId = service.data()!['serviceCategoryId'],
        createdAt = service.data()!['createdAt'].toDate();

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'serviceCategoryId': serviceCategoryId,
      'createdAt': createdAt
    };
  }
}