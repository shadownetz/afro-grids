import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

@immutable
abstract class InventoryEvent extends Equatable{}

class CreateInventoryEvent extends InventoryEvent{
  @override
  List<Object?> get props => [];
}

class ChooseNewInventoryItemImages extends InventoryEvent{
  @override
  List<Object?> get props => [];
}

class RemoveInventoryImageFromSelection extends InventoryEvent{
  final List<XFile> images;
  final XFile image;

  RemoveInventoryImageFromSelection({
    required this.images,
    required this.image
  });

  @override
  List<Object?> get props => [];
}
