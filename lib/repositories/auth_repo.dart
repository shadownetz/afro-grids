import 'dart:convert';

import 'package:afro_grids/configs/api_config.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthRepo{

  bool isSignedIn(){
    return FirebaseAuth.instance.currentUser != null;
  }

  User? getAuthUser(){
    return FirebaseAuth.instance.currentUser;
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
      body: jsonEncode({
        'phone': user.phone
      }),
    );
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }
    return null;
  }
}