import 'package:afro_grids/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

@immutable
abstract class UserEvent extends Equatable {}

class GetUserEvent extends UserEvent {
  final String userId;
  GetUserEvent(this.userId);

  @override
  List<Object?> get props => [];
}

class UpdateUserEvent extends UserEvent{
  final UserModel user;
  final String? password;
  final String? placeId;
  final XFile? avatar;
  UpdateUserEvent(this.user, {
    this.placeId,
    this.password,
    this.avatar
  });
  @override
  List<Object?> get props => [];
}