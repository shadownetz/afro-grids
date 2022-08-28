import 'package:afro_grids/models/user_model.dart';
import 'package:equatable/equatable.dart';

import '../../models/local/local_order_model.dart';

abstract class OrderEvent extends Equatable{}

class FetchUserOrders extends OrderEvent{
  final UserModel user;
  FetchUserOrders({required this.user});
  @override
  List<Object?> get props => [];
}

class FetchNextUserOrders extends OrderEvent{
  final UserModel user;
  final LocalOrderModel cursor;
  FetchNextUserOrders({required this.user, required this.cursor});
  @override
  List<Object?> get props => [];
}