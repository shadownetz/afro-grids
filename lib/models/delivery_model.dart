import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryModel{
  late String id;
  late String providerId;
  late String inventoryId;
  late String orderId;
  late DateTime createdAt;
  late int deliveryCount;
  late String contactId;
  late String contactName;
  late String contactPhone;
  late String contactAddress;
  late String status;
  late num amount;

  DeliveryModel({
    required this.id,
    required this.providerId,
    required this.inventoryId,
    required this.orderId,
    required this.createdAt,
    required this.deliveryCount,
    required this.contactId,
    required this.contactName,
    required this.contactAddress,
    required this.contactPhone,
    required this.status,
    this.amount = 0
  });

  DeliveryModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> delivery):
        id = delivery.id,
        providerId = delivery.data()!['providerId'],
        inventoryId = delivery.data()!['inventoryId'],
        orderId = delivery.data()!['orderId']??"",
        createdAt = delivery.data()!['createdAt'].toDate(),
        deliveryCount = delivery.data()!['deliveryCount'],
        contactId = delivery.data()!['contactId'],
        contactName = delivery.data()!['contactName'],
        contactAddress = delivery.data()!['contactAddress'],
        contactPhone = delivery.data()!['contactPhone'],
        status = delivery.data()!['status'],
        amount = delivery.data()!['amount']??0;

  Map<String, dynamic> toMap(){
    return {
      'providerId': providerId,
      'inventoryId': inventoryId,
      'orderId': orderId,
      'createdAt': Timestamp.fromDate(createdAt),
      'deliveryCount': deliveryCount,
      'contactId': contactId,
      'contactName': contactName,
      'contactAddress': contactAddress,
      'contactPhone': contactPhone,
      'status': status,
      'amount': amount
    };
  }
}