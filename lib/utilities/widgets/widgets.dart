import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';

Widget appBarLogo(){
  return const Image(
      width: 130,
      height: 130,
      image: AssetImage("assets/splash_light.png")
  );
}

class AuthTab extends StatelessWidget {
  final String activeTab;

  const AuthTab({
    Key? key,
    this.activeTab = 'signin'
  }) : super(key: key);

  ButtonStyle tabBtnStyle(String tab){
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
            activeTab == tab?Colours.tertiary: Colors.white
        ),
        minimumSize: MaterialStateProperty.all(const Size(180, 40)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              style: tabBtnStyle('signin'),
              onPressed: ()=>Navigator.of(context).pushReplacementNamed("/signin"),
              child: const Text(
                "Sign in",
              )
          ),
          TextButton(
              style: tabBtnStyle('signup'),
              onPressed: ()=>Navigator.of(context).pushReplacementNamed("/user-signup"),
              child: const Text(
                "Sign up",
              )
          )
        ],
      ),
    );
  }
}