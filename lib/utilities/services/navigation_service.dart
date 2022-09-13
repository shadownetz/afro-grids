import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../alerts.dart';

class NavigationService{
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> toPage(Widget screen){
    return navigatorKey.currentState!.push(createRoute(screen));
  }

  static Future<dynamic> replacePageNamed(String pageName){
    return navigatorKey.currentState!.pushReplacementNamed(pageName);
  }

  static Future<dynamic> pushNamedAndRemoveAll(String pageName, [String? message])async{
    if(message != null){
      await Alerts(navigatorKey.currentContext!).showInfoDialog(title: "Information", message: message);
    }
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(pageName, (route)=>false);
  }

  static Future<void> pushPageReplacement(Widget screen){
    return navigatorKey.currentState!.pushReplacement(createRoute(screen));
  }

  static void exitPage([dynamic value]){
    return navigatorKey.currentState!.pop(value);
  }

}