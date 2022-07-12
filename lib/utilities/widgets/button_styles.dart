import 'package:flutter/material.dart';

ButtonStyle buttonSmStyle(){
  return ElevatedButton.styleFrom(
    minimumSize: const Size(200, 50),
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500
    )
  );
}

ButtonStyle buttonLgStyle(){
  return ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 50),
      textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500
      )
  );
}