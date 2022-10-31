import 'package:afro_grids/models/user/provider_membership_model.dart';
import 'package:afro_grids/models/user/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

@immutable
abstract class AuthEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

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
}

class LoginWithEmailPasswordEvent extends AuthEvent{
  final String email;
  final String password;
  LoginWithEmailPasswordEvent({required this.email, required this.password});
}

class SendPhoneVerificationEvent extends AuthEvent{
  final UserModel user;
  SendPhoneVerificationEvent({required this.user});
}

class PostPhoneVerificationLoginEvent extends AuthEvent{
  final String generatedCode;
  final String inputCode;
  PostPhoneVerificationLoginEvent(this.generatedCode, this.inputCode);
}

class SignInWithGoogleEvent extends AuthEvent{
  final UserModel user;
  SignInWithGoogleEvent({required this.user});
}

class UpdatePhoneEvent extends AuthEvent{
  final UserModel user;
  final String phone;
  UpdatePhoneEvent({required this.user, required this.phone});
}

class LogoutEvent extends AuthEvent{}

class SubscribeMemberEvent extends AuthEvent{
  final UserModel user;
  final UserSubscriptionModel subscription;
  SubscribeMemberEvent({required this.user, required this.subscription});
}

class DeleteAccountEvent extends AuthEvent{
  final UserModel user;
  DeleteAccountEvent({required this.user});
}
