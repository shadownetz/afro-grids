import 'package:afro_grids/models/service_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ServiceEvent extends Equatable{}

class FetchServiceEvent extends ServiceEvent{
  final String? serviceCategoryId;
  FetchServiceEvent(this.serviceCategoryId);
  @override
  List<Object?> get props => [];

}

class AddServiceEvent extends ServiceEvent{
  final ServiceModel service;
  AddServiceEvent(this.service);
  @override
  List<Object?> get props => [];

}

class FetchServiceProvidersEvent extends ServiceEvent{
  final ServiceModel service;
  FetchServiceProvidersEvent(this.service);
  
  @override
  List<Object?> get props => [];
}
