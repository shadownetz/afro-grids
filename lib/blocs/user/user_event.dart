import 'package:afro_grids/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class UserEvent extends Equatable {}

class FetchUserEvent extends UserEvent {
  @override
  List<Object?> get props => [];
}

class UpdateUserEvent extends UserEvent{
  final UserModel user;
  UpdateUserEvent(this.user);
  @override
  List<Object?> get props => [];
}