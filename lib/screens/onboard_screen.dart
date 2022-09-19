import 'package:afro_grids/blocs/auth/auth_bloc.dart';
import 'package:afro_grids/blocs/auth/auth_event.dart';
import 'package:afro_grids/blocs/auth/auth_state.dart';
import 'package:afro_grids/screens/welcome_screen.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../utilities/colours.dart';
import '../utilities/services/navigation_service.dart';
import '../utilities/widgets/widgets.dart';
import 'auth/provider_membership_info_screen.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  var currentScreenIndex = 0;
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomLoadingOverlay(
          widget: Container(
              color: Colours.tertiary,
              height: double.infinity,
              width: double.infinity,
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state){
                  if(state is AuthenticatedState){
                    Navigator.of(context).pushReplacementNamed('/user-dashboard');
                  }
                  if(state is PhoneVerificationState){
                    Navigator.of(context).pushReplacementNamed('/phone-verification');
                  }
                  if(state is AuthLoadingState){
                    context.loaderOverlay.show();
                  }else{
                    context.loaderOverlay.hide();
                  }
                  if(state is MembershipSubscriptionState){
                    NavigationService.pushPageReplacement(ProviderMembershipInfoScreen(user: state.user,));
                  }
                },
                builder: (context, state){
                  if(state is UnAuthenticatedState){
                    return Stack(
                      children: [
                        CarouselSlider(
                          carouselController: carouselController,
                          items: [
                            onboardScreenOne(),
                            onboardScreenTwo(),
                            onboardScreenThree()
                          ],
                          options: CarouselOptions(
                              height: double.infinity,
                              viewportFraction: 1,
                              enableInfiniteScroll: false,
                              onPageChanged: (pageNo, reason){
                                setState((){
                                  currentScreenIndex = pageNo;
                                });
                              }
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          heightFactor: 50.5,
                          child: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Icon(
                                      Icons.circle,
                                      size: 15,
                                      color: currentScreenIndex == 0? Colours.secondary: Colours.primary,
                                    )
                                ),
                                Expanded(
                                    child: Icon(
                                        Icons.circle,
                                        size: 15,
                                        color: currentScreenIndex == 1? Colours.secondary: Colours.primary
                                    )
                                ),
                                Expanded(
                                    child: Icon(
                                        Icons.circle,
                                        size: 15,
                                        color: currentScreenIndex == 2? Colours.secondary: Colours.primary
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                        currentScreenIndex != 2 ?
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              onPressed: ()=>carouselController.nextPage(),
                              style: buttonSmStyle(),
                              child: const Text("Next"),
                            ),
                          ),
                        ):
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              onPressed: ()=>{
                                Navigator.of(context).pushReplacementNamed("/user-signup")
                              },
                              style: buttonSmStyle(),
                              child: const Text("Continue"),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  return const WelcomeScreen(isLoading: true,);
                },
              )
          ),
        )
    );
  }

  Widget onboardScreenOne(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Image(
          image: AssetImage("assets/onboard/onboard1.png"),
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            children: const [
              Text(
                "Available anytime anywhere",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30,),
              Text(
                "Locate and discover global services around you",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget onboardScreenTwo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Image(
          image: AssetImage("assets/onboard/onboard2.png"),
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            children: const [
              Text(
                "Discover Services",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30,),
              Text(
                "Register as a service provider or a service seeker to enjoy dynamic resources available just for you",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget onboardScreenThree(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Image(
          image: AssetImage("assets/onboard/onboard3.png"),
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            children: const [
              Text(
                "Leave a Review",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30,),
              Text(
                "You can drop a review and add providers to your favorites list creating a trustworthy ecosystem",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
