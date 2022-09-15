import 'dart:typed_data';

import 'package:afro_grids/models/user/user_model.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/services.dart';


class AssetResources{
  ImageProvider userAvatar(UserModel? user){
    if(user != null){
      if(user.avatar.isNotEmpty){
        return NetworkImage(user.avatar);
      }
    }
    return const AssetImage('assets/avatars/man.png');
  }

  ImageProvider cartLogo(){
    return const AssetImage("assets/icons/cart.png");
  }

  Future<Uint8List> getGMapMarkerIcon()async{
    return await getBytesFromAsset("assets/icons/afroGridsLocPin.png", 60);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }
}