import 'package:afro_grids/models/user/user_model.dart';
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
  final ServiceModel? service;
  final List<ServiceModel> services;
  ServiceLoadedState({this.services=const [], this.service});
  @override
  List<Object?> get props => [];

}

class ServiceErrorState extends ServiceState{
  final String message;

  ServiceErrorState(this.message);

  @override
  List<Object?> get props => [];

}

class FetchedServiceProvidersState extends ServiceState{
  final List<UserModel> users;

  FetchedServiceProvidersState(this.users);

  @override
  List<Object?> get props => [];

}