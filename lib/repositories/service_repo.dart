import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRepo{
  ServiceModel? service;
  CollectionReference _serviceRef;

  ServiceRepo({this.service}): _serviceRef=FirestoreRef().serviceRef;

  Future<List<ServiceModel>> fetchServices(String serviceCategoryId)async{
    var querySnapshot = await _serviceRef.where("serviceCategoryId", isEqualTo: serviceCategoryId).get();
    return querySnapshot.docs.map((doc) =>
        ServiceModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  Future<ServiceModel> getServiceByID(String serviceID)async{
    var docSnapshot = await _serviceRef.doc(serviceID).get();
    return ServiceModel.fromFirestore(docSnapshot as DocumentSnapshot<Map<String, dynamic>>);
  }

  Future<List<ServiceModel>> fetchAllServices()async{
    var querySnapshot = await _serviceRef.get();
    return querySnapshot.docs.map((doc) =>
        ServiceModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }
  Future<String> addService()async{
    return (await _serviceRef.add(service!.toMap())).id;
  }
}