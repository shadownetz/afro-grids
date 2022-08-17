import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/service_category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceCategoryRepo{
  ServiceCategoryModel? serviceCategory;

  ServiceCategoryRepo({this.serviceCategory});

  Future<List<ServiceCategoryModel>> fetchServiceCategories()async{
    var querySnapshot = await FirestoreRef().serviceCategoryRef.get();
    return querySnapshot.docs.map((doc) =>
        ServiceCategoryModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }
  ServiceCategoryRepo getServiceCategoryFromOptions(List<ServiceCategoryModel> categories, String categoryId){
    var result = categories.where((category) => category.id==categoryId);
    if(result.isNotEmpty) serviceCategory = result.first;
    return this;
  }
  String? get getName{
    return serviceCategory != null? serviceCategory!.name : null;
  }
}