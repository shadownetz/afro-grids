import 'package:afro_grids/screens/provider/provider_info_multiple_service_screen.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:flutter/material.dart';

import '../models/user/user_model.dart';
import '../screens/provider/provider_info_single_service_screen.dart';

class NavigationGuards{
  UserModel user;

  NavigationGuards({required this.user});

  navigateToDashboard(){
    if(user.isProvider){
      NavigationService.pushNamedAndRemoveAll("/provider-dashboard");
    }else{
      NavigationService.pushNamedAndRemoveAll("/user-dashboard");
    }
  }
  Future<dynamic> navigateToPortfolioPage()async{
    if(user.serviceType == ServiceType.single){
      return await NavigationService.toPage(ProviderInfoSingleServiceScreen(user: user,));
    }
    else if(user.serviceType == ServiceType.multiple){
      return await NavigationService.toPage(ProviderInfoMultipleServiceScreen(user: user));
    }
  }

}