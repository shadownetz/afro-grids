import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRepo{
  ServiceModel? service;

  ServiceRepo({this.service});

  Future<List<ServiceModel>> fetchServices(String serviceCategoryId)async{
    var querySnapshot = await FirestoreRef().serviceRef.where("serviceCategoryId", isEqualTo: serviceCategoryId).get();
    return querySnapshot.docs.map((doc) =>
        ServiceModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }
  Future<List<ServiceModel>> fetchAllServices()async{
    var querySnapshot = await FirestoreRef().serviceRef.get();
    return querySnapshot.docs.map((doc) =>
        ServiceModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }
  Future<String> addService()async{
    return (await FirestoreRef().serviceRef.add(service!.toMap())).id;
  }
}