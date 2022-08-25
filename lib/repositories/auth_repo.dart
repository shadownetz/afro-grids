import 'dart:convert';

import 'package:afro_grids/configs/api_config.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthRepo{

  bool isSignedIn(){
    return FirebaseAuth.instance.currentUser != null;
  }

  User? getAuthUser(){
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> updatePassword(String newPassword)async{
    try{
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    }on FirebaseAuthException catch (e){
      if (e.code == 'weak-password') {
        return Future.error("The password provided is too weak");
      } else if (e.code == 'requires-recent-login') {
        return Future.error("For security reasons you need to have recently logged in to update your password. Kindly re-login and try again.");
      }
    }
  }

  Future<String> getAccessToken()async{
    if(isSignedIn()){
      return await getAuthUser()!.getIdToken(true);
    }
    return "";
  }

  Future<String?> verifyPhone(UserModel user)async{
    http.Response response = await http.post(
      Uri.parse("${APIConfig().APIURL}/auth/verify-phone"),
      headers: APIConfig().header(accessToken: await getAccessToken()),
      body: {
        'phone': user.phone
      },
    );
    if(response.statusCode == 200){
      return jsonDecode(response.body).toString();
    }
    return null;
  }

  Future<UserCredential?> signInWithGoogle() async{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    if(googleAuth != null){
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    return null;
  }

  Future<void> signOut() async{
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}