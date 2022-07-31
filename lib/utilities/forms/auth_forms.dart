import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../models/user_model.dart';
import '../class_constants.dart';
import '../widgets/button_widget.dart';

class ProviderSignUpForm extends StatefulWidget {
  final void Function(UserModel user) onComplete;

  const ProviderSignUpForm({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<ProviderSignUpForm> createState() => _ProviderSignUpFormState();
}

class _ProviderSignUpFormState extends State<ProviderSignUpForm> {
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var middleNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var password2Controller = TextEditingController();
  var currencyController = TextEditingController(text: 'NGN');
  var serviceTypeController = TextEditingController(text: ServiceType.single);
  var serviceCategoryController = TextEditingController();
  
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
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
              // controller: lastNameController,
              decoration: const InputDecoration(
                  labelText: "Location",
                  hintText: "enter your address"
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length <= 3) {
                  return 'Please enter a valid address';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                  labelText: "Currency"
              ),
              value: currencyController.text,
              onChanged: (value)=>{
                setState(()=>{
                  currencyController.text = value!
                })
              },
              items: ['NGN'].map((code) => DropdownMenuItem<String>(
                value: code,
                child: Text(code),
              )).toList(),
            ),
            TextFormField(
              controller: serviceCategoryController,
              decoration: const InputDecoration(
                  labelText: "Select or enter your service category",
                  hintText: "e.g fashion"
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length <= 3) {
                  return 'Please enter a valid service category';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                  labelText: "Select your service type"
              ),
              value: serviceTypeController.text,
              onChanged: (value)=>{
                setState(()=>{
                  serviceTypeController.text = value!
                })
              },
              items: [ServiceType.single, ServiceType.multiple]
                  .map((serviceType) => DropdownMenuItem<String>(
                value: serviceType,
                child: Text(serviceType),
              )).toList(),
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

class UserSignUpForm extends StatefulWidget {
  final void Function(UserModel user) onComplete;

  const UserSignUpForm({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<UserSignUpForm> createState() => _UserSignUpFormState();
}

class _UserSignUpFormState extends State<UserSignUpForm> {
  final formKey = GlobalKey<FormState>();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var middleNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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

