import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class DeviceEvent extends Equatable{}

class FetchDeviceLocationEvent extends DeviceEvent{
  @override
  List<Object?> get props => [];
}

class ChooseImagesEvent extends DeviceEvent{
  @override
  List<Object?> get props => [];
}

class ChooseImageEvent extends DeviceEvent{
  @override
  List<Object?> get props => [];
}

class RemoveItemFromImagesEvent extends DeviceEvent{
  final List<XFile> images;
  final XFile image;

  RemoveItemFromImagesEvent({
    required this.images,
    required this.image
  });

  @override
  List<Object?> get props => [];
}