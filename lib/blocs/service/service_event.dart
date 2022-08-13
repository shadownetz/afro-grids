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
