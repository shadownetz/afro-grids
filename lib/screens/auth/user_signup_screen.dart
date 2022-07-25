import 'package:afro_grids/utilities/colours.dart';
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
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var middleNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var password2Controller = TextEditingController();

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
                signUpForm(),
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

  Form signUpForm(){
    final formKey = GlobalKey<FormState>();

    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(
                  labelText: "First name",
                  hintText: "enter your first name"
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length <= 3) {
                  return 'Please enter a valid name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(
                  labelText: "Last name",
                  hintText: "enter your last name"
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length <= 3) {
                  return 'Please enter a valid name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: middleNameController,
              decoration: const InputDecoration(
                  labelText: "Middle name (optional)",
                  hintText: "enter your middle name"
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length <= 3) {
                  return 'Please enter a valid name';
                }
                return null;
              },
            ),
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
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone",
                hintText: "enter your phone number",
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length <= 3) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "setup a password for your account",
                  suffix: IconButton(
                      onPressed: (){},
                      icon: const Icon(Ionicons.eye_off_sharp)
                  )
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid password';
                }else if(value.length < 8){
                  return 'Password must be greater than 7 characters';
                }
                return null;
              },
            ),
            TextFormField(
              controller: password2Controller,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Re-enter Password",
                  hintText: "verify your password for your account",
                  suffix: IconButton(
                      onPressed: (){},
                      icon: const Icon(Ionicons.eye_off_sharp)
                  )
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid password';
                }else if(value.length < 8){
                  return 'Password must be greater than 7 characters';
                }
                else if(value != passwordController.text){
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 50,),
            ElevatedButton(
                style: buttonLgStyle(),
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed('/user-dashboard');
                  // if(formKey.currentState != null){
                  //   if(formKey.currentState!.validate()){
                  //
                  //   }
                  // }
                },
                child: const Text("Sign up")
            )
          ],
        )
    );
  }
}