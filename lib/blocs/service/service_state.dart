import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/service_model.dart';

@immutable
abstract class ServiceState extends Equatable{}

class ServiceInitialState extends ServiceState{
  @override
  List<Object?> get props => [];

}

class ServiceLoadingState extends ServiceState{
  @override
  List<Object?> get props => [];

}

class ServiceLoadedState extends ServiceState{
  final List<ServiceModel> services;
  ServiceLoadedState({this.services=const []});
  @override
  List<Object?> get props => [];

}

class ServiceErrorState extends ServiceState{
  final String message;

  ServiceErrorState(this.message);

  @override
  List<Object?> get props => [];

}