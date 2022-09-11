import 'package:afro_grids/blocs/user/user_bloc.dart';
import 'package:afro_grids/blocs/user/user_event.dart';
import 'package:afro_grids/models/user/user_model.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../blocs/user/user_state.dart';
import '../alerts.dart';
import '../class_constants.dart';
import '../func_utils.dart';
import '../widgets/button_widget.dart';
import '../widgets/selectors/avatar_selector.dart';
import 'input/gplace_autocomplete.dart';

// class UpdateUserProfileForm extends StatefulWidget {
//   final UserModel user;
//   final void Function(UserModel user) onUpdate;
//   const UpdateUserProfileForm({Key? key, required this.onUpdate, required this.user}) : super(key: key);
//
//   @override
//   State<UpdateUserProfileForm> createState() => _UpdateUserProfileFormState();
// }
//
// class _UpdateUserProfileFormState extends State<UpdateUserProfileForm> {
//   var firstNameController = TextEditingController();
//   var lastNameController = TextEditingController();
//   var middleNameController = TextEditingController();
//   var emailController = TextEditingController();
//   var phoneController = TextEditingController();
//   var oldPasswordController = TextEditingController();
//   var passwordController = TextEditingController();
//   var password2Controller = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Form(
//         key: formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             TextFormField(
//               controller: firstNameController,
//               decoration: const InputDecoration(
//                   labelText: "First name",
//                   hintText: "enter your first name"
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty || value.length <= 3) {
//                   return 'Please enter a valid name';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: lastNameController,
//               decoration: const InputDecoration(
//                   labelText: "Last name",
//                   hintText: "enter your last name"
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty || value.length <= 3) {
//                   return 'Please enter a valid name';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: middleNameController,
//               decoration: const InputDecoration(
//                   labelText: "Middle name (optional)",
//                   hintText: "enter your middle name"
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty || value.length <= 3) {
//                   return 'Please enter a valid name';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: const InputDecoration(
//                   labelText: "Email",
//                   hintText: "enter your email address"
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty || value.length <= 3) {
//                   return 'Please enter a valid email';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: phoneController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(
//                 labelText: "Phone",
//                 hintText: "enter your phone number",
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty || value.length <= 3) {
//                   return 'Please enter a valid phone number';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: oldPasswordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                   labelText: "Old Password",
//                   hintText: "enter your old password to update with a new one",
//                   suffix: IconButton(
//                       onPressed: (){},
//                       icon: const Icon(Ionicons.eye_off_sharp)
//                   )
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a valid password';
//                 }else if(value.length < 8){
//                   return 'Password must be greater than 7 characters';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                   labelText: "New Password",
//                   hintText: "setup a new password for your account",
//                   suffix: IconButton(
//                       onPressed: (){},
//                       icon: const Icon(Ionicons.eye_off_sharp)
//                   )
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a valid password';
//                 }else if(value.length < 8){
//                   return 'Password must be greater than 7 characters';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: password2Controller,
//               obscureText: true,
//               decoration: InputDecoration(
//                   labelText: "Re-enter Password",
//                   hintText: "verify the new password for your account",
//                   suffix: IconButton(
//                       onPressed: (){},
//                       icon: const Icon(Ionicons.eye_off_sharp)
//                   )
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a valid password';
//                 }else if(value.length < 8){
//                   return 'Password must be greater than 7 characters';
//                 }
//                 else if(value != passwordController.text){
//                   return 'Passwords do not match';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 50,),
//             ElevatedButton(
//                 style: buttonLgStyle(),
//                 onPressed: (){
//                   if(formKey.currentState!.validate()){
//                     widget.onUpdate(
//                       UserModel.userInstance()
//                     );
//                   }
//                 },
//                 child: const Text("Update")
//             )
//           ],
//         )
//     );
//   }
// }

class UpdateUserProfileForm extends StatefulWidget {
  final UserModel user;
  final void Function(UserModel user, String? placeId, String? newPassword, XFile? newAvatar) onUpdate;

  const UpdateUserProfileForm({Key? key, required this.onUpdate, required this.user}) : super(key: key);

  @override
  State<UpdateUserProfileForm> createState() => _UpdateUserProfileFormState();
}

class _UpdateUserProfileFormState extends State<UpdateUserProfileForm> {
  final formKey = GlobalKey<FormState>();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var middleNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var password2Controller = TextEditingController();
  var deliveryAddressController = TextEditingController();
  XFile? _avatarFile;
  String? locationPlaceId = "";
  String locationName = "";
  bool obscurePassword = true;
  bool obscurePassword2 = true;
  UserModel? user;

  @override
  void initState() {
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    middleNameController.text = widget.user.middleName;
    emailController.text = widget.user.email;
    phoneController.text = widget.user.phone;
    locationName = widget.user.address;
    deliveryAddressController.text = widget.user.deliveryAddress;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoadingOverlay(
        widget: BlocProvider(
          create:(context)=> UserBloc()..add(GetUserEvent(widget.user.id)),
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state){
              if(state is UserLoadingState){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
              if(state is UserLoadedState){
                setState(()=>user = state.user);
              }
            },
            builder: (context, state){
              if(user != null){
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
                            value: user!.avatar,
                            onUpdated: (image)=>_avatarFile=image,
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
                        ),
                        TextFormField(
                          controller: emailController,
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: "Email (read only)",
                              hintText: "enter your email address"
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty || value.length <= 3 || !FuncUtils.validateEmail(value)) {
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
                          value: locationName,
                          onSelected: (placeId, placeName){
                            locationPlaceId=placeId;
                            locationName = placeName;
                          },
                        ),
                        TextFormField(
                          controller: deliveryAddressController,
                          decoration: const InputDecoration(
                              labelText: "Delivery Address (optional)",
                              hintText: "Where would your item be delivered to?"
                          ),
                        ),
                        user!.authType == AuthType.email ?
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
                        ):
                        Container(),
                        user!.authType == AuthType.email ?
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
                        ):
                        Container(),
                        const SizedBox(height: 50,),
                        ElevatedButton(
                            style: buttonLgStyle(),
                            onPressed: (){
                              if(formKey.currentState != null){
                                if(formKey.currentState!.validate()){
                                  if(locationPlaceId != null && locationName.isEmpty){
                                    Alerts(context).showToast("Select your location");
                                  }else{
                                    return _updateProfile();
                                  }
                                }
                              }
                            },
                            child: const Text("Save")
                        )
                      ],
                    )
                );
              }
              return Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: const Text("We were unable to load your profile information", style: TextStyle(fontSize: 20),),
              );
            },
          ),
        )
    );
  }

  void _updateProfile(){
    if(user != null){
      user!.firstName = firstNameController.text;
      user!.lastName = lastNameController.text;
      user!.middleName = middleNameController.text;
      user!.phone = phoneController.text;
      user!.email = emailController.text;
      user!.address = locationName;
      user!.deliveryAddress = deliveryAddressController.text;
      widget.onUpdate(user!, locationPlaceId, passwordController.text, _avatarFile);
    }
  }
}

class UpdateProviderProfileForm extends StatefulWidget {
  final void Function(UserModel user) onUpdate;

  const UpdateProviderProfileForm({Key? key, required this.onUpdate}) : super(key: key);

  @override
  State<UpdateProviderProfileForm> createState() => _UpdateProviderProfileFormState();
}

class _UpdateProviderProfileFormState extends State<UpdateProviderProfileForm> {
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var middleNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var oldPasswordController = TextEditingController();
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
              controller: oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Old Password",
                  hintText: "enter your old password to update with a new one",
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
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "New Password",
                  hintText: "setup a new password for your account",
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
                  hintText: "verify the new password for your account",
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
