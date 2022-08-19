import 'package:afro_grids/blocs/auth/auth_event.dart';
import 'package:afro_grids/blocs/auth/auth_state.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/repositories/auth_repo.dart';
import 'package:afro_grids/repositories/user_repo.dart';
import 'package:afro_grids/utilities/class_constants.dart';
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
    on<SignInWithGoogleEvent>(_mapSignInWithGoogleEventToEvent);
    on<UpdatePhoneEvent>(_mapUpdatePhoneEventToEvent);
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
            if(!user.isProvider || (user.isProvider && user.isApproved)){
              emit(AuthenticatedState(user: user));
            }else{
              await authRepo.signOut();
              emit(UnAuthenticatedState(message: "Your account is currently pending for approval. Contact support if you think this is a mistake"));
            }
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
        event.user.setLocation(response.geometry.location.lat, response.geometry.location.lng);
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.user.email, password: event.password
        );
        if(credential.user != null){
          event.user.id = credential.user!.uid;
          var userRepo = UserRepo(user: event.user);
          if(event.avatar != null){
            await userRepo.uploadAvatar(event.avatar!);
          }
          await userRepo.addUser();
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
        add(CheckAuthEvent());
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
      if(event.user.phone.isNotEmpty){
        var code = await AuthRepo().verifyPhone(event.user);
        emit(SentPhoneVerificationState(code));
      }else{
        emit(AuthInitialState());
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
      await AuthRepo().signOut();
      emit(UnAuthenticatedState());
    }catch(e){
      emit(AuthErrorState(e.toString()));
    }

  }

  void _mapSignInWithGoogleEventToEvent(SignInWithGoogleEvent event, Emitter<AuthState> emit)async{
    emit(AuthLoadingState());
    final authRepo = AuthRepo();
    String? authMessage;
    try{
      var credential = await authRepo.signInWithGoogle();
      if(credential != null){
        if(credential.user != null){
          final user = await UserRepo().getUserByEmail(credential.user!.email!);
          if(user != null){
            // login the user
            if(user.authType != AuthType.google){
              localStorage.addNotification("Hi ${user.firstName}. You signed in using google and this has been set to your new login method.");
              user.authType = AuthType.google;
              await UserRepo(user: user).updateUser();
            }
            localStorage.user = user;
          }
          else{
            // signup the user
            event.user.id = credential.user!.uid;
            event.user.authType = AuthType.google;
            event.user.firstName = credential.user!.displayName??"";
            event.user.email = credential.user!.email??"";
            event.user.setAvatar(credential.user!.photoURL);
            event.user.setPhone(credential.user!.phoneNumber);
            var userRepo = UserRepo(user: event.user);
            userRepo.trySetLocation();
            localStorage.user = await userRepo.addUser();
          }
          if(localStorage.user!.phoneVerified){
            add(CheckAuthEvent());
          }else{
            emit(PhoneVerificationState());
          }
        }else{
          emit(AuthErrorState("There was an issue signing into your account"));
        }
      }else{
        emit(AuthErrorState("We could not complete the sign in process"));
      }
    }catch(e){
      emit(AuthErrorState(e.toString()));
    }
  }

  void _mapUpdatePhoneEventToEvent(UpdatePhoneEvent event, Emitter<AuthState> emit) async{
    emit(AuthLoadingState());
    try{
      await UserRepo(user: event.user).updatePhone(event.phone);
      emit(PhoneUpdatedState(phone: event.phone));
      await Future.delayed(Duration(seconds: 1));
    }catch(e){
      emit(AuthErrorState(e.toString()));
    }
  }
}