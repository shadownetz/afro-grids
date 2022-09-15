import 'package:afro_grids/models/delivery_model.dart';
import 'package:afro_grids/models/local/local_delivery_model.dart';
import 'package:afro_grids/models/user/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class DeliveryEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class FetchProviderDeliveriesEvent extends DeliveryEvent{
  final UserModel provider;
  final int? limit;
  FetchProviderDeliveriesEvent({required this.provider, this.limit});
}

class FetchNextProviderDeliveriesEvent extends DeliveryEvent{
  final UserModel provider;
  final LocalDeliveryModel cursor;
  FetchNextProviderDeliveriesEvent({required this.provider, required this.cursor});
  @override
  List<Object?> get props => [];
}

class UpdateDeliveryEvent extends DeliveryEvent{
  final DeliveryModel delivery;
  UpdateDeliveryEvent(this.delivery);
}