import 'package:afro_grids/models/local/local_delivery_model.dart';
import 'package:equatable/equatable.dart';

import '../../models/delivery_model.dart';

abstract class DeliveryState extends Equatable{
  @override
  List<Object?> get props => [];
}

class DeliveryInitialState extends DeliveryState{}

class DeliveryLoadingState extends DeliveryState{}

class DeliveryUpdatedState extends DeliveryState{}

class DeliveryLoadedState extends DeliveryState{
  final List<LocalDeliveryModel>? deliveries;
  final DeliveryModel? delivery;
  DeliveryLoadedState({this.deliveries, this.delivery});
}

class DeliveryErrorState extends DeliveryState{
  final String message;
  DeliveryErrorState(this.message);
}