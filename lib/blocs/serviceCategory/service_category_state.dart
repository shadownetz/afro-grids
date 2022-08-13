import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/service_category_model.dart';

@immutable
abstract class ServiceCategoryState extends Equatable{}

class ServiceCategoryInitialState extends ServiceCategoryState{
  @override
  List<Object?> get props => [];

}

class ServiceCategoryLoadingState extends ServiceCategoryState{
  @override
  List<Object?> get props => [];

}

class ServiceCategoryLoadedState extends ServiceCategoryState{
  final List<ServiceCategoryModel> serviceCategories;
  ServiceCategoryLoadedState({this.serviceCategories=const []});
  @override
  List<Object?> get props => [];

}

class ServiceCategoryErrorState extends ServiceCategoryState{
  final String message;

  ServiceCategoryErrorState(this.message);

  @override
  List<Object?> get props => [];

}