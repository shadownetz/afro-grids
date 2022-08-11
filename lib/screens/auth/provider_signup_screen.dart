import 'package:afro_grids/utilities/forms/auth_forms.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../utilities/colours.dart';
import '../../utilities/widgets/widgets.dart';

class ProviderSignupScreen extends StatefulWidget {
  const ProviderSignupScreen({Key? key}) : super(key: key);

  @override
  State<ProviderSignupScreen> createState() => _ProviderSignupScreenState();
}

class _ProviderSignupScreenState extends State<ProviderSignupScreen> {
  

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
                  "Get Started as a Service Provider",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                ProviderSignUpForm(
                  onComplete: (user){
                    //
                  },
                ),
                TextButton(
                    onPressed: ()=>{
                      Navigator.of(context).pushReplacementNamed('/user-signup')
                    },
                    child: const Center(
                      child: Text(
                        "Sign up as a service seeker instead",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colours.secondary),
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
