import 'package:flutter/material.dart';

import '../../main.dart';
import '../../utilities/colours.dart';
import '../../utilities/navigation_guards.dart';
import '../../utilities/widgets/button_widget.dart';

class OrderCompleteScreen extends StatelessWidget {
  const OrderCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colours.tertiary,
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: Colours.secondary),
                  color: Colours.secondaryAccent,
                  shape: BoxShape.circle
              ),
              child: Container(
                alignment: Alignment.center,
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                    border: Border.all(color: Colours.secondary),
                    color: Colours.secondary,
                    shape: BoxShape.circle
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                  ),
                  child: const Image(
                    image: AssetImage("assets/icons/animated/shopping-bag.gif"),
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    // color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            const Text(
              "Payment Successful!",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 20,),
            const Text(
              "Your order is being processed",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 50,),
            ElevatedButton(
                onPressed: (){},
                style: buttonMdStyle(
                    elevation: 3
                ),
                child: const Text("View history")
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  NavigationGuards(user: localStorage.user!).navigateToDashboard();
                },
                style: buttonPrimaryMdStyle(
                    elevation: 3
                ),
                child: const Text("Continue to service hunt")
            )
          ],
        ),
      ),
    );
  }
}
