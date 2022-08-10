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
  @override
  List<Object?> get props => [];
}

class UnAuthenticatedState extends AuthState{
  @override
  List<Object?> get props => [];
}