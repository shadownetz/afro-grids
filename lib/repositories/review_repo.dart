import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/local/local_review_model.dart';
import 'package:afro_grids/models/review_model.dart';
import 'package:afro_grids/repositories/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewRepo{
  ReviewModel? review;
  final CollectionReference _reviewRef;

  ReviewRepo({this.review}): _reviewRef=FirestoreRef().reviewRef;

  Future<DocumentReference> addReview(){
    return _reviewRef.add(review!.toMap());
  }

  Future<List<LocalReviewModel>> fetchProviderReviews(String providerId)async{
    var querySnapshot = await _reviewRef.where("createdFor", isEqualTo: providerId).get();
    return querySnapshot
        .docs
        .map((doc) => LocalReviewModel(
        review: ReviewModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)))
        .toList();
  }

  Future<List<LocalReviewModel>> fetchProviderReviewsWithMeta(String providerId)async{
    var querySnapshot = await _reviewRef.where("createdFor", isEqualTo: providerId).get();
    List<ReviewModel> reviews = querySnapshot
        .docs
        .map((doc) => ReviewModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
    var futures = reviews.map((review) => UserRepo().getUserIfExist(review.createdBy));
    var reviewCreators = await Future.wait(futures);
    List<LocalReviewModel> localReviews = [];
    for (var i=0; i < reviews.length; i++) {
      if(reviewCreators[i] == null){ // filter comments of users who have been deleted
        continue;
      }
      localReviews.add(LocalReviewModel(review: reviews[i], createdBy: reviewCreators[i]));
    }
    return localReviews;
  }


}