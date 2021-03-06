import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/forms/auth_forms.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../utilities/widgets/button_widget.dart';

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({Key? key}) : super(key: key);

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colours.tertiary,
        appBar: AppBar(
          title: appBarLogo(),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20,),
                const AuthTab(activeTab: 'signup'),
                const SizedBox(height: 40,),
                const Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
                UserSignUpForm(
                  onComplete: (user){
                    //
                  },
                ),
                TextButton(
                    onPressed: ()=>{
                      Navigator.of(context).pushReplacementNamed('/provider-signup')
                    },
                    child: const Center(
                      child: Text(
                        "Sign up as a service provider instead",
                        textAlign: TextAlign.center,
                      ),
                    )
                ),
                Row(
                  children: const [
                    Expanded(child: Divider(height: 10, color: Colors.black26,)),
                    Expanded(child: Text("or sign up with", textAlign: TextAlign.center,)),
                    Expanded(child: Divider(height: 10, color: Colors.black26,))
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                            minimumSize: const Size(170, 40),
                            textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w200
                            )
                        ),
                        onPressed: ()=>{},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Icon(Ionicons.logo_facebook, size: 20, color: Colors.blueAccent,),
                            SizedBox(width: 10,),
                            Text(
                              "Facebook",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        )
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            minimumSize: const Size(170, 40),
                            textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w200
                            )
                        ),
                        onPressed: ()=>{},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Icon(Ionicons.logo_google, size: 20, color: Colors.red,),
                            SizedBox(width: 10,),
                            Text(
                              "Google",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        )
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}
