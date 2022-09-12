import 'package:cloud_firestore/cloud_firestore.dart';

class UserSubscriptionModel{
  late String id;
  late String context;
  late double amount;
  late dynamic paymentResponse;
  late String status;
  late String currency;
  late DateTime createdAt;
  late String createdBy;
  late DateTime expireAt;

  UserSubscriptionModel({
    required this.id,
    required this.context,
    required this.amount,
    required this.paymentResponse,
    required this.status,
    required this.currency,
    required this.createdAt,
    required this.createdBy,
    required this.expireAt
  });

  UserSubscriptionModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> membership):
        id = membership.id,
        context = membership.data()!["context"],
        amount = membership.data()!['amount'],
        paymentResponse = membership.data()!['paymentResponse'],
        status = membership.data()!['status'],
        currency = membership.data()!['currency'],
        createdBy = membership.data()!['createdBy'],
        createdAt = membership.data()!['createdAt'].toDate(),
        expireAt = membership.data()!['expireAt'].toDate();

  Map<String, dynamic> toMap(){
    return {
      'context': context,
      'amount': amount,
      'paymentResponse': paymentResponse,
      'status': status,
      'currency': currency,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'expireAt': Timestamp.fromDate(expireAt)
    };
  }
}