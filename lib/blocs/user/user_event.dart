import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class UserEvent extends Equatable {}

class FetchUserEvent extends UserEvent {
  @override
  List<Object?> get props => [];
}