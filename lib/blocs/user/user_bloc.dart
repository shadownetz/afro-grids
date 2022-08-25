import 'package:afro_grids/blocs/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/user_repo.dart';
import '../../utilities/services/gmap_service.dart';
import 'user_event.dart';


class UserBloc extends Bloc<UserEvent, UserState>{
  UserBloc() : super(UserInitialState()){
    on<UpdateUserEvent>(_mapUpdateUserEventToState);
    on<GetUserEvent>(_mapGetUserEventToState);
  }

  void _mapUpdateUserEventToState(UpdateUserEvent event,  Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try{
      var userRepo = UserRepo(user: event.user);
      if(event.password != null){
        await userRepo.updatePassword(event.password!);
      }
      if(event.avatar != null){
        await userRepo.uploadAvatar(event.avatar!);
      }
      if(event.placeId != null){
        var response = await GMapService().getAddressFromPlaceId(event.placeId!);
        if(response != null){
          userRepo.setLocation(response.geometry.location.lat, response.geometry.location.lng);
        }
      }
      await userRepo.updateUser();
      emit(UserLoadedState());
    }catch(e){
      emit(UserErrorState(e.toString()));
    }
  }

  void _mapGetUserEventToState(GetUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try{
      var user = await UserRepo().getUser(event.userId);
      emit(UserLoadedState(user: user));
    }catch(e){
      emit(UserErrorState(e.toString()));
    }
  }

}
