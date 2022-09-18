import 'package:afro_grids/models/user/user_model.dart';
import 'package:afro_grids/models/withdraw_model.dart';
import 'package:equatable/equatable.dart';

abstract class WithdrawEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class FetchUserWithdrawalsEvent extends WithdrawEvent{
  final UserModel user;
  FetchUserWithdrawalsEvent({required this.user});
}

class PlaceWithdrawalEvent extends WithdrawEvent{
  final WithdrawModel withdrawModel;
  PlaceWithdrawalEvent({required this.withdrawModel});
}