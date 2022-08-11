import 'package:afro_grids/models/model_types.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/currency.dart';
import 'package:afro_grids/utilities/forms/input/gplace_autocomplete.dart';
import 'package:afro_grids/utilities/func_utils.dart';
import 'package:afro_grids/utilities/services/geofire_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import '../../../models/user_model.dart';
import '../class_constants.dart';
import '../widgets/button_widget.dart';
import '../widgets/selectors/avatar_selector.dart';

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
  XFile? avatarFile;
  
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: AvatarSelector(
                onUpdated: (image)=>avatarFile=image,
              ),
            ),
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
  final void Function(UserModel user, String placeId, String password) onComplete;

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
  String locationPlaceId = "";
  bool obscurePassword = true;
  bool obscurePassword2 = true;

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
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "enter your email address"
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length <= 3 || !validateEmail(value)) {
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
            GPlaceAutoComplete(
              onSelected: (placeId){
                locationPlaceId=placeId;
              },
            ),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "setup a password for your account",
                  suffix: IconButton(
                      onPressed: ()=>setState(()=>obscurePassword = !obscurePassword),
                      icon: Icon(
                          obscurePassword? Ionicons.eye: Ionicons.eye_off_sharp
                      )
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
              obscureText: obscurePassword2,
              decoration: InputDecoration(
                  labelText: "Re-enter Password",
                  hintText: "verify your password for your account",
                  suffix: IconButton(
                      onPressed: ()=>setState(()=>obscurePassword2 = !obscurePassword2),
                      icon: Icon(
                          obscurePassword2? Ionicons.eye: Ionicons.eye_off_sharp
                      )
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
                  // Navigator.of(context).pushReplacementNamed('/user-dashboard');
                  if(formKey.currentState != null){
                    if(formKey.currentState!.validate()){
                      if(locationPlaceId.isEmpty){
                        Alerts(context).showToast("Select your location");
                      }else{
                        return _signUp();
                      }
                    }
                  }
                },
                child: const Text("Sign up")
            )
          ],
        )
    );
  }

  void _signUp(){
    final user = UserModel(
        id: "",
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        middleName: middleNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        authType: AuthType.email,
        accessLevel: AccessLevel.user,
        currency: CurrencyUtil().currencyName,
        location: GeoFireService().geo.point(latitude: 0, longitude: 0),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        serviceId: "",
        serviceType: "",
        ratings: Ratings(0,0,0),
        accessStatus: AccessStatus.pending,
        reviews: Reviews(0,0),
        favorites: [],
        avatar: ""
    );
    widget.onComplete(user, locationPlaceId, passwordController.text);
  }
}

