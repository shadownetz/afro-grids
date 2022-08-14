import 'package:afro_grids/blocs/auth/auth_event.dart';
import 'package:afro_grids/blocs/auth/auth_state.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/repositories/auth_repo.dart';
import 'package:afro_grids/repositories/user_repo.dart';
import 'package:afro_grids/utilities/services/geofire_service.dart';
import 'package:afro_grids/utilities/services/gmap_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc(): super(AuthInitialState()){
    on<CheckAuthEvent>(_mapCheckAuthEventToEvent);
    on<SignUpWithEmailPasswordEvent>(_mapSignUpWithEmailPasswordToEvent);
    on<LoginWithEmailPasswordEvent>(_mapLoginWithEmailPasswordEventToEvent);
    on<SendPhoneVerificationEvent>(_mapSendPhoneVerificationEventToEvent);
    on<PostPhoneVerificationLoginEvent>(_mapPostPhoneVerificationLoginEventToEvent);
    on<LogoutEvent>(_mapLogoutEventToEvent);
  }

  void _mapCheckAuthEventToEvent(CheckAuthEvent event, Emitter<AuthState> emit)async{
    var authRepo = AuthRepo();
    try{
      if(authRepo.isSignedIn()){
        final authUser = authRepo.getAuthUser();
        if(authUser != null){
          final user = await UserRepo().getUser(authUser.uid);
          localStorage.user = user;
          if(user.phoneVerified){
            emit(AuthenticatedState(user: user));
          }else{
            emit(PhoneVerificationState());
          }
        }else{
          emit(UnAuthenticatedState());
        }
      }else{
        emit(UnAuthenticatedState());
      }
    }catch(e){
      emit(UnAuthenticatedState());
    }
  }

  void _mapSignUpWithEmailPasswordToEvent(SignUpWithEmailPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try{
      var response = await GMapService().getAddressFromPlaceId(event.placeId);
      if(response != null){
        event.user.location = GeoFireService().geo.point(
            latitude: response.geometry.location.lat,
            longitude: response.geometry.location.lng
        );
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.user.email, password: event.password
        );
        if(credential.user != null){
          event.user.id = credential.user!.uid;
          await UserRepo(user: event.user).addUser(avatar: event.avatar);
        }else{
          throw Exception("We were unable to complete the signup process. Please try again");
        }
        localStorage.user = event.user;
        emit(PhoneVerificationState());
      }else{
        throw Exception("Unable to retrieve location information");
      }
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthErrorState('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthErrorState('An account already exists for that email.'));
      }else if (e.code == 'invalid-email') {
        emit(AuthErrorState('The email provided is not valid.'));
      }else if (e.code == 'operation-not-allowed') {
        // enable email-passwsord sign-in from console
        emit(AuthErrorState('You are unable to sign up at this time. Please contact support with this error message'));
      }else{
        emit(AuthErrorState(e.toString()));
      }
    }catch(e){
      emit(AuthErrorState(e.toString()));
    }
  }

  void _mapLoginWithEmailPasswordEventToEvent(LoginWithEmailPasswordEvent event, Emitter<AuthState> emit)async{
    emit(AuthLoadingState());
    try{
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: event.email, password: event.password);
      if(credential.user != null){
        final user = await UserRepo().getUser(credential.user!.uid);
        localStorage.user = user;
        if(user.phoneVerified){
          emit(AuthenticatedState(user: user));
        }else{
          emit(PhoneVerificationState());
        }
      }else{
        throw Exception("You are unable to login. Please try again or contact support");
      }
    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthErrorState('The specified email address or password may be incorrect'));
      } else if (e.code == 'wrong-password') {
        emit(AuthErrorState('The specified email address or password may be incorrect'));
      }else{
        emit(AuthErrorState(e.toString()));
      }
    }catch(e){
      emit(AuthErrorState(e.toString()));
    }
  }

  void _mapSendPhoneVerificationEventToEvent(SendPhoneVerificationEvent event, Emitter<AuthState> emit)async{
    emit(AuthLoadingState());
    try{
      if(localStorage.user != null){
        var code = await AuthRepo().verifyPhone(localStorage.user!);
        emit(SentPhoneVerificationState(code));
      }else{
        emit(AuthErrorState("We are unable to send a verification code at this time"));
      }
    }catch(e){
      emit(AuthErrorState(e.toString()));
    }
  }
  void _mapPostPhoneVerificationLoginEventToEvent(PostPhoneVerificationLoginEvent event, Emitter<AuthState> emit)async{
    emit(AuthLoadingState());
    try{
      if(event.inputCode == event.generatedCode){
        localStorage.user!.phoneVerified = true;
        localStorage.user!.updatedAt = DateTime.now();
        await UserRepo(user: localStorage.user).updateUser();
        add(CheckAuthEvent());
      }else{
        emit(AuthErrorState("Invalid verification code"));
      }
    }catch(e){
      emit(AuthErrorState(e.toString()));
    }
  }
  void _mapLogoutEventToEvent(LogoutEvent event, Emitter<AuthState> emit)async{
    try{
      await FirebaseAuth.instance.signOut();
      emit(UnAuthenticatedState());
    }catch(e){
      emit(AuthErrorState(e.toString()));
    }

  }
}