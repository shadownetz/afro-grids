import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.linear;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

BoxShadow boxShadow1(){
  return BoxShadow(color: Colors.black26, spreadRadius: 3, blurRadius: 5, offset: Offset.fromDirection(1));
}
BoxShadow boxShadow2(){
  return const BoxShadow(color: Colors.black26, blurRadius: 9, offset: Offset(0.0, 5));
}

class AppBarLogo extends StatelessWidget {
  final String theme;
  const AppBarLogo({Key? key, this.theme='light'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
        width: 130,
        height: 130,
        image: AssetImage(
            theme=='light'?"assets/splash_light.png":"assets/splash.png"
        )
    );
  }
}

class CartIcon extends StatelessWidget{
  final int? itemCount;
  
  const CartIcon({Key? key, this.itemCount}): super(key: key);
  
  @override
  Widget build(BuildContext context){
    return Stack(
      children: [
        const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                Ionicons.cart,
                size: 30,
                color: Colors.white,
              ),
            )
        ),
        itemCount != null ?
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(top: 5),
            alignment: Alignment.center,
            padding: EdgeInsets.all(2),
            decoration: const BoxDecoration(
                color: Colours.secondary,
                shape: BoxShape.circle
            ),
            child: Text("$itemCount", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12),),
          ),
        ):
        Container(),
      ],
    );
  }
}

class RoundImage extends StatelessWidget {
  final ImageProvider image;
  final double width;
  final double height;
  final bool hasShadow;
  final BoxFit? fit;

  const RoundImage({
    Key? key,
    required this.image,
    this.width=50,
    this.height=50,
    this.hasShadow=false,
    this.fit
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          image: DecorationImage(
              image: image,
              fit: fit
          ),
          boxShadow: hasShadow? [
            boxShadow2()
          ]: null
      ),
    );
  }
}

class RatingIcons extends StatelessWidget {
  final List<Widget> ratingIcons = [];
  final int ratingValue;
  final double iconSize;
  final MainAxisAlignment? alignment;
  
  RatingIcons(this.ratingValue, {Key? key, this.iconSize=30, this.alignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    for(int i=0; i<ratingValue; i++){
      ratingIcons.add(Icon(
        Icons.star, size: iconSize,color: Colours.secondary,
      ));
    }
    for(int i=ratingIcons.length; i<5; i++){
      ratingIcons.add(Icon(
        Icons.star_border, size: iconSize,color: Colours.secondary,
      ));
    }
    return Row(
      mainAxisAlignment: alignment ?? MainAxisAlignment.end,
      children: ratingIcons,
    );
  }
}

class HalfWhiteOverlay extends StatelessWidget {
  final double height;
  const HalfWhiteOverlay({Key? key, this.height=50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
          color: Colors.grey,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0),
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.9),
              Colors.white,
            ],
          )
      ),
    );
  }
}

class HalfWhiteOverlay2 extends StatelessWidget {
  final double height;
  const HalfWhiteOverlay2({Key? key, this.height=50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
          color: Colors.grey,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0),
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(1),
              Colors.white,
            ],
          )
      ),
    );
  }
}

class ModalDragIndicator extends StatelessWidget {
  const ModalDragIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 10,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Color.fromRGBO(220, 220, 220, 1),
          borderRadius: BorderRadius.circular(20)
      ),
    );
  }
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

class CustomLoadingOverlay extends StatelessWidget {
  final Widget widget;
  const CustomLoadingOverlay({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
        useDefaultLoading: false,
        overlayOpacity: 0.5,
        overlayColor: Colors.white,
        overlayWidget: const Center(
          child: Image(
            image: AssetImage('assets/icons/animated/afro-grid-logo-dark.gif'),
          ),
        ),
        child: widget
    );
  }
}

class LoadingThreeBounce extends StatelessWidget {
  const LoadingThreeBounce({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SpinKitThreeBounce(
      color: Colours.primary,
      size: 30,
    );
  }
}

