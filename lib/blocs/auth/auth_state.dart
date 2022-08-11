import 'package:afro_grids/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState extends Equatable{}

class AuthInitialState extends AuthState{
  @override
  List<Object?> get props => [];
}

class AuthLoadingState extends AuthState{
  @override
  List<Object?> get props => [];
}

class AuthLoadedState extends AuthState{
  @override
  List<Object?> get props => [];
}

class AuthErrorState extends AuthState{
  final String message;
  AuthErrorState(this.message);
  @override
  List<Object?> get props => [];
}

class AuthenticatedState extends AuthState{
  final UserModel? user;
  AuthenticatedState({this.user});
  @override
  List<Object?> get props => [];
}

class UnAuthenticatedState extends AuthState{
  @override
  List<Object?> get props => [];
}

class PhoneVerificationState extends AuthState{
  PhoneVerificationState();
  @override
  List<Object?> get props => [];
}

class SentPhoneVerificationState extends AuthState{
  final String? verificationCode;
  SentPhoneVerificationState(this.verificationCode);
  @override
  List<Object?> get props => [];
}