import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Credentials{

  static String get gPlaceKey{
    if(Platform.isAndroid){
      return dotenv.env['PLACE_ANDROID_API_KEY']!;
    }
    if(Platform.isIOS){
      return dotenv.env['PLACE_IOS_API_KEY']!;
    }
    return "";
  }
  static String get gGeocodingKey{
    if(Platform.isAndroid){
      return dotenv.env['GEOCODING_ANDROID_KEY']!;
    }
    if(Platform.isIOS){
      return dotenv.env['GEOCODING_IOS_KEY']!;
    }
    return "";
  }
  static String get aPIKey{
    return dotenv.env['API_KEY']!;
  }
  static String raveKey({bool isTest = false}){
    if(isTest){
      return dotenv.env['TEST_RAVE_PUBLIC_KEY']!;
    }
    return dotenv.env['PROD_RAVE_PUBLIC_KEY']!;
  }

}