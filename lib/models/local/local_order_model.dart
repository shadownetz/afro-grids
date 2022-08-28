import 'package:afro_grids/models/inventory_model.dart';
import 'package:afro_grids/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocalOrderModel{
  late List<InventoryModel?> inventories;
  late OrderModel orderModel;
  DocumentSnapshot? snapshot;
  int? totalOrderCount;

  LocalOrderModel({
    required this.inventories,
    required this.orderModel,
    this.snapshot,
    this.totalOrderCount
  });

  int inventorySize(InventoryModel inventory){
    if(orderModel.items.isNotEmpty){
      var result = orderModel.items.where((item) => item.inventoryId==inventory.id);
      if(result.isNotEmpty){
        return result.first.count;
      }
    }
    return 0;
  }

}