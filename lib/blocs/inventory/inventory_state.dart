import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/inventory_model.dart';

@immutable
abstract class InventoryState extends Equatable{}

class InventoryInitialState extends InventoryState{
  @override
  List<Object?> get props => [];
}

class InventoryLoadingState extends InventoryState{
  @override
  List<Object?> get props => [];
}

class InventoryLoadedState extends InventoryState{
  final List<InventoryModel> inventories;
  InventoryLoadedState({this.inventories = const []});
  @override
  List<Object?> get props => [];
}

class InventoryErrorState extends InventoryState{
  final String message;
  InventoryErrorState(this.message);
  @override
  List<Object?> get props => [];
}