import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawModel{
  late String id;
  late String createdBy;
  late num amount;
  late String status;
  late DateTime createdAt;

  WithdrawModel({
    required this.id,
    required this.createdBy,
    required this.amount,
    required this.status,
    required this.createdAt
  });

  WithdrawModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> withdraw):
        id = withdraw.id,
        createdBy = withdraw.data()!['createdBy'],
        amount = withdraw.data()!['amount'],
        status = withdraw.data()!['status'],
        createdAt = withdraw.data()!['createdAt'].toDate();

  Map<String, dynamic> toMap(){
    return {
      'createdBy': createdBy,
      'amount': amount,
      'status': status,
      'createdAt': createdAt
    };
  }

}