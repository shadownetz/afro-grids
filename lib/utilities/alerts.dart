import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';

class Alerts{
  final BuildContext context;
  final FToast _fToast = FToast();

  Alerts(this.context){
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

  showInfoDialog({required String title, required String message}){
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontSize: 16),),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(left: 20),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Icon(Icons.info_outline, color: Colours.primary, size: 50,),
                const SizedBox(height: 30,),
                Center(
                  child: Text(message, textAlign: TextAlign.center,  style: const TextStyle(fontSize: 18),),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: buttonPrimarySmStyle(),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  showSuccessDialog({required String title, required String message}){
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontSize: 16),),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.only(left: 20),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Icon(Icons.check_circle, color: Colours.secondary, size: 50,),
                const SizedBox(height: 30,),
                Center(
                  child: Text(message, textAlign: TextAlign.center,  style: const TextStyle(fontSize: 18),),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: buttonPrimarySmStyle(),
              child: const Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  showErrorDialog({required String title, required String message}){
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontSize: 16),),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.only(left: 20),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Icon(Ionicons.ban_outline, color: Colors.redAccent, size: 50,),
                const SizedBox(height: 30,),
                Center(
                  child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18),),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: buttonPrimarySmStyle(),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  showConfirmDialog({required String title, required String message, required void Function() onConfirm}){
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontSize: 16),),
          actionsAlignment: MainAxisAlignment.spaceAround,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Icon(Ionicons.infinite_outline, color: Colors.yellow, size: 50,),
                const SizedBox(height: 30,),
                Center(
                  child: Text(message, textAlign: TextAlign.center,  style: const TextStyle(fontSize: 18),),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Proceed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colours.primary),),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
            TextButton(
              child: const Text('Cancel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
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

  Widget orderCompleted(){
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colours.tertiary,
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: Colours.secondary),
                  color: Colours.secondaryAccent,
                  shape: BoxShape.circle
              ),
              child: Container(
                alignment: Alignment.center,
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                    border: Border.all(color: Colours.secondary),
                    color: Colours.secondary,
                    shape: BoxShape.circle
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                  ),
                  child: const Image(
                    image: AssetImage("assets/icons/animated/shopping-bag.gif"),
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    // color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            const Text(
                "Payment Successful!",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 20,),
            const Text(
              "Your order is being processed",
              style: TextStyle(
                  fontSize: 20,
              ),
            ),
            const SizedBox(height: 50,),
            ElevatedButton(
                onPressed: (){},
                style: buttonMdStyle(
                  elevation: 3
                ),
                child: const Text("View history")
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route)=>false);
                },
                style: buttonPrimaryMdStyle(
                  elevation: 3
                ),
                child: const Text("Continue to service hunt")
            )
          ],
        ),
      ),
    );
  }

}