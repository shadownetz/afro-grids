import 'dart:async';

import 'package:afro_grids/models/local/local_storage_model.dart';
import 'package:afro_grids/screens/auth/otp_screen.dart';
import 'package:afro_grids/screens/auth/provider_signup_screen.dart';
import 'package:afro_grids/screens/auth/signin_screen.dart';
import 'package:afro_grids/screens/auth/user_signup_screen.dart';
import 'package:afro_grids/screens/onboard_screen.dart';
import 'package:afro_grids/screens/user/chat/chats_screen.dart';
import 'package:afro_grids/screens/user/user_dashboard_screen.dart';
import 'package:afro_grids/screens/welcome_screen.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'firebase_options.dart';

LocalStorageModel localStorage = LocalStorageModel();

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await dotenv.load();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
      webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    );

    FlutterError.onError =
        FirebaseCrashlytics.instance.recordFlutterFatalError;
    if(kDebugMode){
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }else{
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
    runApp(MyApp());
  }, (error, stack) =>
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<String> delayLoading = Future<String>.delayed(
    const Duration(seconds: 2),
        () => 'Data Loaded',
  );

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return FutureBuilder(
        future: delayLoading,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return BlocProvider(
              create: (context)=>AuthBloc()..add(CheckAuthEvent()),
              child: MaterialApp(
                title: 'AfroGrids',
                theme: Theme.of(context).copyWith(
                    useMaterial3: true,
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Colours.primary,
                      secondary: Colours.secondary,
                      background: Colours.tertiary,
                    ),
                    appBarTheme: const AppBarTheme(
                        backgroundColor: Colours.primary,
                        foregroundColor: Colors.white
                    ),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                        style: ElevatedButton.styleFrom(
                            primary: Colours.secondary,
                            onPrimary: Colours.primary,
                            textStyle: const TextStyle(color: Colours.secondary)
                        )
                    ),
                    textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                            primary: Colours.primary
                        )
                    ),
                    textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: Colours.primary
                    ),
                    iconTheme: Theme.of(context).iconTheme.copyWith(
                        color: Colours.primary
                    )
                ),
                debugShowCheckedModeBanner: false,
                routes: {
                  '/': (context)=>const OnboardScreen(),
                  '/user-signup': (context)=>const UserSignUpScreen(),
                  '/provider-signup': (context)=>const ProviderSignupScreen(),
                  '/signin': (context)=>const SignInScreen(),
                  '/phone-verification': (context)=>const OTPScreen(),
                  '/user-dashboard': (context)=>const UserDashboardScreen(),
                  '/chat': (context)=> const ChatScreen()
                },
              ),
            );
          }
          else{
            return const WelcomeScreen();
          }
        }
    );
  }
}
