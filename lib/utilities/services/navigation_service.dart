import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';

class NavigationService{
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> toPage(Widget screen){
    return navigatorKey.currentState!.push(createRoute(screen));
  }

}