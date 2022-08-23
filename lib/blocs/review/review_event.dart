import 'package:afro_grids/models/review_model.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ReviewEvent extends Equatable{}

class FetchReviewsEvent extends ReviewEvent{
  final UserModel provider;
  final bool withMetaInfo;

  FetchReviewsEvent(this.provider, {this.withMetaInfo=false});

  @override
  List<Object?> get props => [];
}

class AddReviewEvent extends ReviewEvent{
  final ReviewModel review;

  AddReviewEvent(this.review);

  @override
  List<Object?> get props => [];
}