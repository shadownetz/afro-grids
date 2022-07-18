import 'package:equatable/equatable.dart';

abstract class DeviceEvent extends Equatable{}

class FetchDeviceLocation extends DeviceEvent{
  @override
  List<Object?> get props => [];
}