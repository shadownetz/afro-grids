import 'package:afro_grids/blocs/auth/auth_bloc.dart';
import 'package:afro_grids/blocs/auth/auth_event.dart';
import 'package:afro_grids/screens/auth/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../blocs/auth/auth_state.dart';
import '../../models/user/user_model.dart';
import '../../utilities/alerts.dart';
import '../../utilities/colours.dart';
import '../../utilities/navigation_guards.dart';
import '../../utilities/services/navigation_service.dart';
import '../../utilities/widgets/button_widget.dart';
import '../../utilities/widgets/widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool _obscurePassword = true;
  AuthBloc? _authBlocProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colours.tertiary,
        appBar: AppBar(
          title: AppBarLogo(),
        ),
        body: CustomLoadingOverlay(
          widget: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state){
              if(state is AuthLoadingState){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
              if(state is AuthErrorState){
                Alerts(context).showErrorDialog(title: "Oops!", message: state.message);
              }
              if(state is PhoneVerificationState){
                Navigator.of(context).push(createRoute(const OTPScreen()));
              }
              if(state is AuthenticatedState){
                NavigationGuards(user: state.user!).navigateToDashboard();
                Alerts(context).showToast("Logged in");
              }
              if(state is UnAuthenticatedState){
                NavigationService.pushNamedAndRemoveAll("/signin", state.message);
              }
            },
            builder: (context, state){
              _authBlocProvider = BlocProvider.of<AuthBloc>(context);
              return Container(
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
                          // FacebookSignInButton(
                          //   onClick: (){},
                          // ),
                          GoogleSignInButton(
                            onClick: ()=>BlocProvider
                                .of<AuthBloc>(context)
                                .add(SignInWithGoogleEvent(user: UserModel.userInstance())),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
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
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "enter your account's password",
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
                      _authBlocProvider!.add(
                          LoginWithEmailPasswordEvent(
                              email: emailController.text, password: passwordController.text
                          )
                      );
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
