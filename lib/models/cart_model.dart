import 'package:cloud_firestore/cloud_firestore.dart';
import 'model_types.dart';

class CartModel{
  late String id;
  late String createdBy;
  late List<OrderItem> items;
  late DateTime createdAt;
  late DateTime updatedAt;

  CartModel({
    required this.id,
    required this.createdBy,
    required this.items,
    required this.createdAt,
    required this.updatedAt
  });

  CartModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> order):
        id = order.id,
        createdBy = order.data()!['createdBy'],
        items = List.from(order.data()!['items']).map((item){
          return OrderItem(item['inventoryId'], item['count']);
        }).toList(),
        createdAt = order.data()!['createdAt'].toDate(),
        updatedAt = order.data()!['updatedAt'].toDate();

  Map<String, dynamic> toMap(){
    return {
      'createdBy': createdBy,
      'items': items.map((item) => {
        'inventoryId': item.inventoryId,
        'count': item.count
      }).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}