import 'package:afro_grids/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent extends Equatable{}

class CheckAuthEvent extends AuthEvent{
  @override
  List<Object?> get props => [];
}

class SignUpEvent extends AuthEvent{
  final UserModel user;
  final String placeId;
  SignUpEvent({
    required this.user,
    required this.placeId
  });
  @override
  List<Object?> get props => [];
}