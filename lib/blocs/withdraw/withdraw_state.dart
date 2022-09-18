import 'package:equatable/equatable.dart';

import '../../models/withdraw_model.dart';

abstract class WithdrawState extends Equatable{
  @override
  List<Object?> get props => [];
}

class WithdrawInitialState extends WithdrawState{}

class WithdrawLoadingState extends WithdrawState{}

class WithdrawLoadedState extends WithdrawState{
  final List<WithdrawModel>? withdrawals;
  WithdrawLoadedState({this.withdrawals});
}

class WithdrawErrorState extends WithdrawState{
  final String message;
  WithdrawErrorState(this.message);
}