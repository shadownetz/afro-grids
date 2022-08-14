import 'package:afro_grids/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

@immutable
abstract class AuthEvent extends Equatable{}

class CheckAuthEvent extends AuthEvent{
  @override
  List<Object?> get props => [];
}

class SignUpWithEmailPasswordEvent extends AuthEvent{
  final UserModel user;
  final String password;
  final String placeId;
  final XFile? avatar;
  SignUpWithEmailPasswordEvent({
    required this.user,
    required this.placeId,
    required this.password,
    this.avatar
  });
  @override
  List<Object?> get props => [];
}

class LoginWithEmailPasswordEvent extends AuthEvent{
  final String email;
  final String password;
  LoginWithEmailPasswordEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [];
}

class SendPhoneVerificationEvent extends AuthEvent{
  final UserModel user;
  SendPhoneVerificationEvent({required this.user});
  @override
  List<Object?> get props => [];
}

class PostPhoneVerificationLoginEvent extends AuthEvent{
  final String generatedCode;
  final String inputCode;
  PostPhoneVerificationLoginEvent(this.generatedCode, this.inputCode);
  @override
  List<Object?> get props => [];
}

class SignInWithGoogleEvent extends AuthEvent{
  final UserModel user;
  SignInWithGoogleEvent({required this.user});
  @override
  List<Object?> get props => [];
}

class UpdatePhoneEvent extends AuthEvent{
  final UserModel user;
  final String phone;
  UpdatePhoneEvent({required this.user, required this.phone});
  @override
  List<Object?> get props => [];
}


class LogoutEvent extends AuthEvent{
  @override
  List<Object?> get props => [];
}
