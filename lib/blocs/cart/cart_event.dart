import 'package:afro_grids/models/local/local_cart_model.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable{}


class AddToCartEvent extends CartEvent{
  final LocalCartItem cartItem;
  AddToCartEvent(this.cartItem);
  @override
  List<Object?> get props => [];
}

class ReduceItemCountEvent extends CartEvent{
  final LocalCartItem cartItem;
  ReduceItemCountEvent(this.cartItem);
  @override
  List<Object?> get props => [];
}

class RemoveFromCartEvent extends CartEvent{
  final LocalCartItem cartItem;
  RemoveFromCartEvent(this.cartItem);
  @override
  List<Object?> get props => [];
}

class GetCartEvent extends CartEvent{
  final UserModel user;
  GetCartEvent({required this.user});
  @override
  List<Object?> get props => [];
}

class AddCheckoutEvent extends CartEvent{
  final LocalCartModel localCart;

  AddCheckoutEvent({required this.localCart});

  @override
  List<Object?> get props => [];
}