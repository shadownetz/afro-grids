import 'package:afro_grids/models/inventory_model.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

@immutable
abstract class InventoryEvent extends Equatable{}

class CreateInventoryEvent extends InventoryEvent{
  final InventoryModel inventory;
  final List<XFile>? images;

  CreateInventoryEvent({required this.inventory, this.images});
  @override
  List<Object?> get props => [];
}

class FetchProviderInventories extends InventoryEvent{
  final UserModel provider;
  FetchProviderInventories(this.provider);
  @override
  List<Object?> get props => [];
}