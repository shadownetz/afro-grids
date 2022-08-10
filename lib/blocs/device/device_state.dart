import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

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

class NewImagesSelected extends DeviceState{
  final List<XFile>? images;
  NewImagesSelected({
    this.images
  });
  @override
  List<Object?> get props => [images];
}

class NewImagesUpdated extends DeviceState{
  final List<XFile> images;
  NewImagesUpdated({
    required this.images
  });
  @override
  List<Object?> get props => [images];
}

class NewImageSelected extends DeviceState{
  final XFile? image;
  NewImageSelected({
    this.image
  });
  @override
  List<Object?> get props => [image];
}