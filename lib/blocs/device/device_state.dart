import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

@immutable
abstract class DeviceState extends Equatable{}

class DeviceInitialState extends DeviceState{
  @override
  List<Object?> get props => [];
}

class DeviceLoadingState extends DeviceState{
  @override
  List<Object?> get props => [];
}

class DeviceLoadedState extends DeviceState{
  final Position? devicePosition;
  DeviceLoadedState({this.devicePosition});

  @override
  List<Object?> get props => [];
}

class DeviceErrorState extends DeviceState{
  final String message;

  DeviceErrorState(this.message);

  @override
  List<Object?> get props => [];
}