import 'package:afro_grids/blocs/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/user_repo.dart';
import 'user_event.dart';


class UserBloc extends Bloc<UserEvent, UserState>{
  UserBloc() : super(UserInitialState()){
    on<UpdateUserEvent>(_mapUpdateUserEventToState);
  }

  void _mapUpdateUserEventToState(UpdateUserEvent event,  Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try{
      await UserRepo(user: event.user).updateUser();
      emit(UserLoadedState());
    }catch(e){
      emit(UserErrorState(e.toString()));
    }
  }

}
