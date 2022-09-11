import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../models/user/user_model.dart';

@immutable
abstract class UserState extends Equatable{}

class UserInitialState extends UserState{
  @override
  List<Object?> get props => [];
}

class UserLoadingState extends UserState{
  @override
  List<Object?> get props => [];
}

class UserLoadedState extends UserState{
  final UserModel? user;
  final List<UserModel?>? users;

  UserLoadedState({this.user, this.users});
  @override
  List<Object?> get props => [];
}

class UserErrorState extends UserState{
  final String message;

  UserErrorState(this.message);

  @override
  List<Object?> get props => [message];
}