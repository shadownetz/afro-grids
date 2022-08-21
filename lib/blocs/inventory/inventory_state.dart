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
  final InventoryModel? inventory;
  InventoryLoadedState({this.inventories = const [], this.inventory});
  @override
  List<Object?> get props => [];
}

class InventoryErrorState extends InventoryState{
  final String message;
  InventoryErrorState(this.message);
  @override
  List<Object?> get props => [];
}

class InventoryUpdatedState extends InventoryState{
  @override
  List<Object?> get props => [];
}