import 'package:afro_grids/models/user/user_model.dart';
import 'package:afro_grids/screens/auth/provider_membership_info_screen.dart';
import 'package:afro_grids/utilities/forms/auth_forms.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../utilities/alerts.dart';
import '../../utilities/colours.dart';
import '../../utilities/navigation_guards.dart';
import '../../utilities/widgets/widgets.dart';
import 'otp_screen.dart';

class ProviderSignupScreen extends StatefulWidget {
  const ProviderSignupScreen({Key? key}) : super(key: key);

  @override
  State<ProviderSignupScreen> createState() => _ProviderSignupScreenState();
}

class _ProviderSignupScreenState extends State<ProviderSignupScreen> {
  AuthBloc? _authBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colours.tertiary,
        appBar: AppBar(
          title: const AppBarLogo(),
        ),
        body: CustomLoadingOverlay(
          widget: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if(state is AuthLoadingState){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
              if(state is AuthErrorState){
                Alerts(context).showErrorDialog(title: "Could not complete operation", message: state.message);
              }
              if(state is PhoneVerificationState){
                NavigationService.toPage(const OTPScreen());
              }
              if(state is UnAuthenticatedState){
                NavigationService.pushNamedAndRemoveAll("/signin", state.message);
              }
              if(state is AuthenticatedState){
                NavigationGuards(user: state.user!).navigateToDashboard();
                Alerts(context).showToast("Logged in");
              }
            },
            builder: (context, state){
              _authBloc = BlocProvider.of<AuthBloc>(context);
              return Container(
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
                        onComplete: (user, placeId, password, avatarFile)async{
                          _authBloc!.add(SignUpWithEmailPasswordEvent(user: user, placeId: placeId, password: password, avatar: avatarFile));
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
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // FacebookSignInButton(
                          //   onClick: (){},
                          // ),
                          GoogleSignInButton(
                            onClick: ()=>BlocProvider
                                .of<AuthBloc>(context)
                                .add(SignInWithGoogleEvent(user: UserModel.providerInstance())),
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
}
