import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel{
  String id;
  String reason;
  String createdFor;
  String createdBy;
  DateTime createdAt;

  ReportModel({
    required this.id,
    required this.reason,
    required this.createdFor,
    required this.createdBy,
    required this.createdAt
  });

  ReportModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> report):
        id = report.id,
        reason = report.data()!['reason'],
        createdFor = report.data()!['createdFor'],
        createdBy = report.data()!['createdBy'],
        createdAt = report.data()!['createdAt'].toDate();

  Map<String, dynamic> toMap(){
    return {
      'reason': reason,
      'createdFor': createdFor,
      'createdBy': createdBy,
      'createdAt': createdAt
    };

  }
}