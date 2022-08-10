import 'package:afro_grids/blocs/auth/auth_event.dart';
import 'package:afro_grids/blocs/auth/auth_state.dart';
import 'package:afro_grids/repositories/auth_repo.dart';
import 'package:afro_grids/utilities/services/geofire_service.dart';
import 'package:afro_grids/utilities/services/gmap_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc(): super(AuthInitialState()){
    on<CheckAuthEvent>(_mapCheckAuthEventToEvent);
    on<SignUpEvent>(_mapSignUpEventToEvent);
  }

  void _mapCheckAuthEventToEvent(CheckAuthEvent event, Emitter<AuthState> emit){
    if(AuthRepo().isSignedIn()){
      emit(AuthenticatedState());
    }else{
      emit(UnAuthenticatedState());
    }
  }

  void _mapSignUpEventToEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try{
      var response = await GMapService().getAddressFromPlaceId(event.placeId);
      if(response != null){
        event.user.location = GeoFireService().geo.point(
            latitude: response.geometry.location.lat,
            longitude: response.geometry.location.lng
        );
        // save info to db
      }else{
        throw Exception("Unable to retrieve location information");
      }
    }catch(e){
      emit(AuthErrorState(e.toString()));
    }
  }
}