import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

@immutable
abstract class InventoryEvent extends Equatable{}

class CreateInventoryEvent extends InventoryEvent{
  @override
  List<Object?> get props => [];
}
