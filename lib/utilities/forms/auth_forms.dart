import 'package:afro_grids/blocs/service/service_bloc.dart';
import 'package:afro_grids/models/model_types.dart';
import 'package:afro_grids/models/service_category_model.dart';
import 'package:afro_grids/models/service_model.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/currency.dart';
import 'package:afro_grids/utilities/forms/input/custom_country_dropdown.dart';
import 'package:afro_grids/utilities/forms/input/gplace_autocomplete.dart';
import 'package:afro_grids/utilities/forms/input/service_category_autocomplete.dart';
import 'package:afro_grids/utilities/func_utils.dart';
import 'package:afro_grids/utilities/services/geofire_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import '../../../models/user_model.dart';
import '../../blocs/service/service_event.dart';
import '../class_constants.dart';
import '../widgets/button_widget.dart';
import '../widgets/selectors/avatar_selector.dart';
import 'input/service_autocomplete.dart';

class ProviderSignUpForm extends StatefulWidget {
  final void Function(UserModel user, String placeId, String password) onComplete;

  const ProviderSignUpForm({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<ProviderSignUpForm> createState() => _ProviderSignUpFormState();
}

class _ProviderSignUpFormState extends State<ProviderSignUpForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();
  final _serviceTypeController = TextEditingController(text: ServiceType.single);
  XFile? _avatarFile;
  String _locationPlaceId = "";
  String? _currencyVal;
  ServiceCategoryModel? _serviceCategory;
  ServiceModel? _service;
  bool _obscurePassword = true;
  bool _obscurePassword2 = true;

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
                onUpdated: (image)=>_avatarFile=image,
              ),
            ),
            TextFormField(
              controller: _firstNameController,
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
              controller: _lastNameController,
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
              controller: _middleNameController,
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
              controller: _emailController,
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
              controller: _phoneController,
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
                _locationPlaceId=placeId;
              },
            ),
            const SizedBox(height: 10,),
            CustomCountryDropdown(
                onSelected: (value){
                  _currencyVal = value;
                }
            ),
            const SizedBox(height: 15,),
            ServiceCategoryInput(
                onSelected: (category, inputText){
                  setState((){
                    _serviceCategory = category;
                  });
                }
            ),
            const SizedBox(height: 15,),
            ServiceInput(
                serviceCategoryId: _serviceCategory?.id,
                onSelected: (service, inputText){
                  _service = service;
                }
            ),
            const SizedBox(height: 15,),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                  labelText: "Select your service type"
              ),
              value: _serviceTypeController.text,
              onChanged: (value)=>{
                setState(()=>{
                  _serviceTypeController.text = value!
                })
              },
              items: [ServiceType.single, ServiceType.multiple]
                  .map((serviceType) => DropdownMenuItem<String>(
                value: serviceType,
                child: Text(serviceType),
              )).toList(),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "setup a password for your account",
                  suffix: IconButton(
                      onPressed: ()=>setState(()=>_obscurePassword = !_obscurePassword),
                      icon: Icon(
                          _obscurePassword? Ionicons.eye: Ionicons.eye_off_sharp
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
              controller: _password2Controller,
              obscureText: _obscurePassword2,
              decoration: InputDecoration(
                  labelText: "Re-enter Password",
                  hintText: "verify your password for your account",
                  suffix: IconButton(
                      onPressed: ()=>setState(()=>_obscurePassword2 = !_obscurePassword2),
                      icon: Icon(
                          _obscurePassword2? Ionicons.eye: Ionicons.eye_off_sharp
                      )
                  )
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid password';
                }else if(value.length < 8){
                  return 'Password must be greater than 7 characters';
                }
                else if(value != _passwordController.text){
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 50,),
            ElevatedButton(
                style: buttonLgStyle(),
                onPressed: (){
                  if(formKey.currentState != null){
                    if(formKey.currentState!.validate()){
                      if(_locationPlaceId.isEmpty){
                        return Alerts(context).showToast("Select your location");
                      }
                      if(_serviceCategory == null){
                        return Alerts(context).showToast("Select a service category");
                      }
                      if(_service == null){
                        return Alerts(context).showToast("Select a service field");
                      }
                      // sign up event
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
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        middleName: _middleNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        authType: AuthType.email,
        accessLevel: AccessLevel.provider,
        currency: _currencyVal ?? CurrencyUtil().currencyName,
        location: GeoFireService().geo.point(latitude: 0, longitude: 0),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        serviceId: _service!.id,
        serviceType: _serviceTypeController.text,
        ratings: Ratings(0,0,0),
        accessStatus: AccessStatus.pending,
        reviews: Reviews(0,0),
        favorites: [],
        avatar: ""
    );
    widget.onComplete(user, _locationPlaceId, _passwordController.text);
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
        accessStatus: AccessStatus.approved,
        reviews: Reviews(0,0),
        favorites: [],
        avatar: ""
    );
    widget.onComplete(user, locationPlaceId, passwordController.text);
  }
}

