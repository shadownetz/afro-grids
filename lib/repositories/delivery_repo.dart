import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/delivery_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/local/local_delivery_model.dart';
import 'inventory_repo.dart';

class DeliveryRepo{
  late final CollectionReference _deliveryRef;
  DeliveryModel? deliveryModel;

  DeliveryRepo({this.deliveryModel}): _deliveryRef = FirestoreRef().deliveriesRef;

  Future<List<LocalDeliveryModel>> fetchProviderDeliveries(
      {required String providerId, DocumentSnapshot? cursor, int? limit, bool includeSize=true})async{
    Query query = _deliveryRef.where('providerId', isEqualTo: providerId);
    int? orderSize;
    if(includeSize){
      orderSize = (await query.get()).size;
    }
    if(cursor != null){
      query = query.startAfterDocument(cursor);
    }
    if(limit != null){
      query = query.limit(limit);
    }
    var querySnapshot = await query.get();
    List<DeliveryModel> deliveries = querySnapshot.docs.map((doc) => DeliveryModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    List<LocalDeliveryModel> localDeliveries = [];
    for(var i=0; i < deliveries.length; i++){
      var inventory = await InventoryRepo().getInventory(deliveries[i].inventoryId);
      localDeliveries.add(LocalDeliveryModel(
          deliveryModel: deliveries[i],
          snapshot: querySnapshot.docs[i],
          inventory: inventory,
          totalDeliveryCount: orderSize
      ));
    }
    return localDeliveries;
  }

  Future<void> updateDelivery() async {
    await _deliveryRef.doc(deliveryModel!.id).update(deliveryModel!.toMap());
  }
}
