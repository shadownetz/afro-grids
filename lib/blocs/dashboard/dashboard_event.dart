import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class DashboardEvent extends Equatable{}

class FetchDashboardInfo extends DashboardEvent{
  @override
  List<Object?> get props => [];

}