import 'package:cloud_firestore/cloud_firestore.dart';
import 'model_types.dart';

class CartModel{
  late String id;
  late String createdBy;
  late List<OrderItem> items;
  late DateTime createdAt;

  CartModel({
    required this.id,
    required this.createdBy,
    required this.items,
    required this.createdAt
  });

  CartModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> order):
        id = order.id,
        createdBy = order.data()!['createdBy'],
        items = order.data()!['items'],
        createdAt = order.data()!['createdAt'].toDate();

  Map<String, dynamic> toMap(){
    return {
      'createdBy': createdBy,
      'items': items,
      'createdAt': Timestamp.fromDate(createdAt)
    };
  }
}