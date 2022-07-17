import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Alerts{
  FToast _fToast = FToast();

  Alerts(BuildContext context){
    _fToast.init(context);
  }


  showToast(String message, {Duration? duration}) {
    _fToast.showToast(
      child: _toast(message),
      gravity: ToastGravity.BOTTOM,
      toastDuration: duration ?? const Duration(seconds: 2),
    );
  }
  showPositionedToast(String message, {Duration? duration, double? top, double? left, double? right, double? bottom, double? width, double? height}){
    _fToast.showToast(
        child: _toast(message),
        toastDuration: duration,
        positionedToastBuilder: (context, child) {
          return Positioned(
            top: top, // 16.0
            left: left, // 16.0
            bottom: bottom,
            right: right,
            width: width,
            height: height,
            child: child,
          );
        });
  }


  Widget _toast (String message){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colours.secondary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info),
          const SizedBox(
            width: 12.0,
          ),
          Text(message),
        ],
      ),
    );
  }

}