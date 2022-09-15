import 'package:afro_grids/models/delivery_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../inventory_model.dart';

class LocalDeliveryModel{
  late DeliveryModel deliveryModel;
  late InventoryModel? inventory;
  DocumentSnapshot? snapshot;
  int? totalDeliveryCount;

  LocalDeliveryModel({
    required this.deliveryModel,
    this.inventory,
    this.snapshot,
    this.totalDeliveryCount
  });


}