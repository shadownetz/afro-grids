import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable{}

class CartInitialState extends CartState{
  @override
  List<Object?> get props => [];
}

class CartLoadingState extends CartState{
  @override
  List<Object?> get props => [];
}

class CartLoadedState extends CartState{
  @override
  List<Object?> get props => [];
}

class CartErrorState extends CartState{
  final String message;
  CartErrorState(this.message);
  @override
  List<Object?> get props => [];

}

class CartCheckedOutState extends CartState{
  @override
  List<Object?> get props => [];

}
