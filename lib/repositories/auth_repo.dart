import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo{

  bool isSignedIn(){
    return FirebaseAuth.instance.currentUser != null;
  }
}