import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../utilities/colours.dart';
import '../../utilities/widgets/button_styles.dart';
import '../../utilities/widgets/widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

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
                const AuthTab(activeTab: 'signin'),
                const SizedBox(height: 40,),
                const Text(
                  "Sign in",
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
                const SizedBox(height: 40,),
                loginInForm(),
                const SizedBox(height: 40,),
                Row(
                  children: const [
                    Expanded(child: Divider(height: 10, color: Colors.black26,)),
                    Expanded(child: Text("or sign in with", textAlign: TextAlign.center,)),
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

  Form loginInForm(){
    final formKey = GlobalKey<FormState>();

    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "enter your email address"
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length <= 3) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "enter your account's password",
                  suffix: IconButton(
                      onPressed: (){},
                      icon: const Icon(Ionicons.eye_off_sharp)
                  )
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid password';
                }
                return null;
              },
            ),
            SizedBox(height: 50,),
            ElevatedButton(
                style: buttonLgStyle(),
                onPressed: (){
                  if(formKey.currentState != null){
                    if(formKey.currentState!.validate()){

                    }
                  }
                },
                child: const Text("Sign in")
            )
          ],
        )
    );
  }
}
