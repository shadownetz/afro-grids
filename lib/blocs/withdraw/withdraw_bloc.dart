import 'package:afro_grids/blocs/withdraw/withdraw_event.dart';
import 'package:afro_grids/blocs/withdraw/withdraw_state.dart';
import 'package:afro_grids/repositories/withdraw_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawBloc extends Bloc<WithdrawEvent, WithdrawState>{

  WithdrawBloc(): super(WithdrawInitialState()){
    on<PlaceWithdrawalEvent>(_onPlaceWithdrawalEvent);
    on<FetchUserWithdrawalsEvent>(_onFetchUserWithdrawalsEvent);
  }

  void _onFetchUserWithdrawalsEvent(FetchUserWithdrawalsEvent event, Emitter<WithdrawState> emit) async {
    emit(WithdrawLoadingState());
    try{
      var withdrawals = await WithdrawRepo().fetchWithdrawalsByUser(event.user.id);
      emit(WithdrawLoadedState(withdrawals: withdrawals));
    }catch(e){
      emit(WithdrawErrorState(e.toString()));
    }
  }

  void _onPlaceWithdrawalEvent(PlaceWithdrawalEvent event, Emitter<WithdrawState> emit)async{
    emit(WithdrawLoadingState());
    try{
      await WithdrawRepo(withdrawModel: event.withdrawModel).addWithdrawal();
      emit(WithdrawLoadedState());
    }catch(e){
      emit(WithdrawErrorState(e.toString()));
    }
  }
}