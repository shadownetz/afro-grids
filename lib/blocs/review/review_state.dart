import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/local/local_review_model.dart';

@immutable
abstract class ReviewState extends Equatable{}

class ReviewInitialState extends ReviewState{
  @override
  List<Object?> get props => [];
}

class ReviewLoadingState extends ReviewState{
  @override
  List<Object?> get props => [];
}

class ReviewLoadedState extends ReviewState{

  final List<LocalReviewModel> reviews;

  ReviewLoadedState({this.reviews=const[]});

  @override
  List<Object?> get props => [];
}

class ReviewErrorState extends ReviewState{
  final String message;
  ReviewErrorState(this.message);
  @override
  List<Object?> get props => [];
}