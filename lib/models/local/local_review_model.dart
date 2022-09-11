import 'package:afro_grids/models/review_model.dart';
import 'package:afro_grids/models/user/user_model.dart';

class LocalReviewModel{
  ReviewModel review;
  UserModel? createdBy;

  LocalReviewModel({
    required this.review,
    this.createdBy
  });

  String? get creatorName{
    if(createdBy != null){
      return createdBy!.name;
    }
    return null;
  }
  String? get creatorAvatar{
    if(createdBy != null){
      return createdBy!.avatar;
    }
    return null;
  }
}