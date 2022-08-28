import 'package:equatable/equatable.dart';

import '../../models/local/local_order_model.dart';

abstract class OrderState extends Equatable{}

class OrderInitialState extends OrderState{
  @override
  List<Object?> get props => [];
}

class OrderLoadingState extends OrderState{
  @override
  List<Object?> get props => [];
}

class OrderLoadedState extends OrderState{
  final List<LocalOrderModel>? userOrders;
  OrderLoadedState({this.userOrders});
  @override
  List<Object?> get props => [];
}

class OrderErrorState extends OrderState{
  final String message;
  OrderErrorState(this.message);
  @override
  List<Object?> get props => [];
}