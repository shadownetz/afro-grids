import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';

Widget appBarLogo({
  theme='light'
}){
  return Image(
      width: 130,
      height: 130,
      image: AssetImage(
          theme=='light'?"assets/splash_light.png":"assets/splash.png"
      )
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

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}