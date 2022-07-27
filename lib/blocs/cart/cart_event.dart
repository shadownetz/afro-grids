import 'package:afro_grids/models/local_cart_model.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable{}


class AddToCartEvent extends CartEvent{
  @override
  List<Object?> get props => [];
}

class RemoveFromCartEvent extends CartEvent{
  @override
  List<Object?> get props => [];
}

class AddCheckoutEvent extends CartEvent{
  final LocalCartModel localCart;

  AddCheckoutEvent({required this.localCart});

  @override
  List<Object?> get props => [];
}