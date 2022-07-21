import 'package:afro_grids/utilities/class_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_types.dart';

class OrderModel{
  late String id;
  late String createdBy;
  late List<OrderItem> items;
  late String deliveryAddress;
  late num totalPrice;
  late dynamic paymentResponse;
  late OrderStatus status;
  late DateTime createdAt;

  OrderModel({
    required this.id,
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
        createdBy = order.data()!['createdBy'],
        items = order.data()!['items'],
        deliveryAddress = order.data()!['deliveryAddress'],
        totalPrice = order.data()!['totalPrice'],
        paymentResponse = order.data()!['paymentResponse'],
        status = order.data()!['status'],
        createdAt = order.data()!['createdAt'].toDate();

  Map<String, dynamic> toMap(){
    return {
      'createdBy': createdBy,
      'items': items,
      'deliveryAddress': deliveryAddress,
      'totalPrice': totalPrice,
      'paymentResponse': paymentResponse,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt)
    };
  }
}