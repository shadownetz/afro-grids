import 'package:afro_grids/models/user_model.dart';
import 'package:flutter/material.dart';

class AssetResources{
  ImageProvider userAvatar(UserModel? user){
    if(user != null){
      if(user.avatar.isNotEmpty){
        return NetworkImage(user.avatar);
      }
    }
    return const AssetImage('assets/avatars/man.png');
  }
}