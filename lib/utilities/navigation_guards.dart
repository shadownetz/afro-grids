import 'package:flutter/material.dart';

import '../models/user_model.dart';

class NavigationGuards{
  BuildContext context;
  UserModel user;

  NavigationGuards(this.context, {required this.user});

  navigateToDashboard(){
    if(user.isProvider){
      Navigator.of(context).pushReplacementNamed("/provider-dashboard");
    }else{
      Navigator.of(context).pushReplacementNamed("/user-dashboard");
    }
  }

}