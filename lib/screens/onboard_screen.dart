import 'package:afro_grids/utilities/widgets/button_styles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../utilities/colours.dart';

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
        body: Container(
            color: Colours.tertiary,
            height: double.infinity,
            width: double.infinity,
            child: Stack(
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
                  child: ElevatedButton(
                    onPressed: ()=>carouselController.nextPage(),
                    style: buttonSmStyle(),
                    child: const Text("Next"),
                  ),
                ):
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: ()=>{
                      Navigator.of(context).pushReplacementNamed("/user-signup")
                    },
                    style: buttonSmStyle(),
                    child: const Text("Continue"),
                  ),
                )
              ],
            )
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
