import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

@immutable
abstract class DashboardState extends Equatable{}

class InitialDashboardState extends DashboardState{
  @override
  List<Object?> get props => [];
}

class DashboardLoadingState extends DashboardState{
  @override
  List<Object?> get props => [];
}

class DashboardLoadedState extends DashboardState{
  final Position? devicePosition;

  DashboardLoadedState({this.devicePosition});
  @override
  List<Object?> get props => [];
}

class DashboardErrorState extends DashboardState{
  final String message;
  DashboardErrorState(this.message);

  @override
  List<Object?> get props => [];
}