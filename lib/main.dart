import 'dart:async';

import 'package:afro_grids/screens/onboard_screen.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'firebase_options.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
      webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    );
    FlutterError.onError =
        FirebaseCrashlytics.instance.recordFlutterFatalError;
    runApp(const MyApp());
  }, (error, stack) =>
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      title: 'AfroGrids',
      theme: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Colours.primary,
            secondary: Colours.secondary,
            background: Colours.tertiary,
          )
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context)=>const OnboardScreen()
      },
    );
  }
}
