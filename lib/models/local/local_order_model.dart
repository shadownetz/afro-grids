import 'package:afro_grids/models/inventory_model.dart';
import 'package:afro_grids/models/order_model.dart';

class LocalOrderModel{
  late InventoryModel inventory;
  late OrderModel orderModel;

  LocalOrderModel({
    required this.inventory,
    required this.orderModel,
  });

  int get count{
    if(orderModel.items.isNotEmpty){
      var result = orderModel.items.where((item) => item.inventoryId==inventory.id);
      if(result.isNotEmpty){
        return result.first.count;
      }
    }
    return 0;
  }
}