import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../utilities/colours.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
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
                  items: [
                    onboardScreenOne(),
                  ],
                  options: CarouselOptions(
                    height: double.infinity,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 50.5,
                  child: SizedBox(
                    width: 100,
                    child: Row(
                      children: const [
                        Expanded(child: Icon(Icons.circle, size: 15, color: Colours.secondary,)),
                        Expanded(child: Icon(Icons.circle, size: 15, color: Colours.secondary)),
                        Expanded(child: Icon(Icons.circle, size: 15, color: Colours.secondary))
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: ()=>{},
                    child: const Text("Next"),
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
                    fontWeight: FontWeight.w400,
                    color: Colours.secondary
                ),
              ),
              SizedBox(height: 30,),
              Text(
                "Locate and discover global services around you",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.w400,
                    color: Colours.secondary
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
