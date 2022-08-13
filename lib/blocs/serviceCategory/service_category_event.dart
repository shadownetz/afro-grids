import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ServiceCategoryEvent extends Equatable{}

class FetchServiceCategoryEvent extends ServiceCategoryEvent{
  @override
  List<Object?> get props => [];

}