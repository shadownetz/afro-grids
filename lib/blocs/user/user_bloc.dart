import 'package:afro_grids/blocs/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_event.dart';


class UserBloc extends Bloc<UserEvent, UserState>{
  UserBloc() : super(UserInitialState()){
    on<FetchUserEvent>(_mapFetchUserEventToState);
  }

  void _mapFetchUserEventToState(UserEvent event,  Emitter<UserState> emit){}

}
