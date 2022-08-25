import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/view/flutterwave_style.dart';

FlutterwaveStyle ravePayStyle(String appBarText){
  return FlutterwaveStyle(
      appBarText: appBarText,
      appBarTitleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20
      ),
      buttonColor: Colours.primary,
      buttonTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      appBarColor: Colours.primary,
      dialogCancelTextStyle: const TextStyle(
        color: Colours.primary,
        fontSize: 18,
      ),
      dialogContinueTextStyle: const TextStyle(
        color: Colours.primary,
        fontSize: 18,
      )
  );
}
