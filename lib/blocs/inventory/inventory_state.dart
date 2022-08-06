import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  @override
  List<Object?> get props => [];
}

class InventoryErrorState extends InventoryState{
  final String message;
  InventoryErrorState(this.message);
  @override
  List<Object?> get props => [];
}

class NewInventoryItemImagesSelected extends InventoryState{
  final List<XFile>? images;
  NewInventoryItemImagesSelected({
    this.images
  });
  @override
  List<Object?> get props => [images];
}

class NewInventoryItemImagesUpdated extends InventoryState{
  final List<XFile> images;
  NewInventoryItemImagesUpdated({
    required this.images
  });
  @override
  List<Object?> get props => [images];
}