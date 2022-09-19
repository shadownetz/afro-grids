import 'package:afro_grids/models/delivery_model.dart';
import 'package:afro_grids/models/inventory_model.dart';
import 'package:afro_grids/models/local/local_delivery_model.dart';
import 'package:afro_grids/models/user/user_model.dart';
import 'package:equatable/equatable.dart';

import '../../models/order_model.dart';

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

class GetOrderDeliveryEvent extends DeliveryEvent{
  final InventoryModel inventory;
  final OrderModel order;
  final UserModel user;
  GetOrderDeliveryEvent({
    required this.inventory,
    required this.order,
    required this.user
  });
}

class CancelDeliveryEvent extends DeliveryEvent{
  final DeliveryModel delivery;
  CancelDeliveryEvent({required this.delivery});
}