import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WelcomeScreen extends StatelessWidget {
  final bool isLoading;
  const WelcomeScreen({Key? key, this.isLoading=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.fill
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage("assets/splash.png"),
            width: 250,
            height: 250,
          ),
          isLoading?SpinKitFadingCircle(
            size: 30,
            itemBuilder: (BuildContext context, int index) {
              return const DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colours.primary,
                ),
              );
            },
          ): Container()
        ],
      ),
    );
  }
}
