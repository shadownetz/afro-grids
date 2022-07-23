import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel{
  late String id;
  late String createdBy;
  late String createdFor;
  late DateTime createdAt;
  late String message;
  late num rating;

  ReviewModel({
    required this.id,
    required this.createdBy,
    required this.createdFor,
    required this.createdAt,
    required this.message,
    required this.rating
  });

  ReviewModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> review):
        id = review.id,
        createdBy = review.data()!['createdBy'],
        createdFor = review.data()!['createdFor'],
        createdAt = review.data()!['createdAt'].toDate(),
        message = review.data()!['message'],
        rating = review.data()!['rating'];

  Map<String, dynamic> toMap(){
    return {
      'createdBy': createdBy,
      'createdFor': createdFor,
      'createdAt': Timestamp.fromDate(createdAt),
      'message': message,
      'rating': rating
    };
  }
}