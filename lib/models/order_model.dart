import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_types.dart';

class OrderModel{
  late String id;
  late String orderNo;
  late String createdBy;
  late List<OrderItem> items;
  late String deliveryAddress;
  late num totalPrice;
  late dynamic paymentResponse;
  late String status; // OrderStatus model type
  late DateTime createdAt;

  OrderModel({
    required this.id,
    required this.orderNo,
    required this.createdBy,
    required this.items,
    required this.deliveryAddress,
    required this.totalPrice,
    required this.paymentResponse,
    required this.status,
    required this.createdAt
  });

  OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> order):
        id = order.id,
        orderNo = order.data()!['orderNo'],
        createdBy = order.data()!['createdBy'],
        items = List.from(order.data()!['items']).map((item){
          return OrderItem(item.inventoryId, item.count);
        }).toList(),
        deliveryAddress = order.data()!['deliveryAddress'],
        totalPrice = order.data()!['totalPrice'],
        paymentResponse = order.data()!['paymentResponse'],
        status = order.data()!['status'],
        createdAt = order.data()!['createdAt'].toDate();

  Map<String, dynamic> toMap(){
    return {
      'createdBy': createdBy,
      'orderNo': orderNo,
      'items': items.map((item) => {
        'inventoryId': item.inventoryId,
        'count': item.count
      }).toList(),
      'deliveryAddress': deliveryAddress,
      'totalPrice': totalPrice,
      'paymentResponse': paymentResponse,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt)
    };
  }
}