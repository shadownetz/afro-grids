import 'package:equatable/equatable.dart';

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
  @override
  List<Object?> get props => [];
}