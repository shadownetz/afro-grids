import 'package:afro_grids/screens/user/cart_screen.dart';
import 'package:afro_grids/screens/user/leave_a_review_screen.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

Widget leaveAReviewButton(BuildContext context){
  return ElevatedButton(
      style: buttonPrimaryLgStyle(),
      onPressed: (){
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context)=>const LeaveAReviewScreen()
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.star_border, size: 20,),
          Text("Leave a review")
        ],
      )
  );
}

Widget checkoutButton(BuildContext context){
  return ElevatedButton(
      style: buttonPrimaryLgStyle(),
      onPressed: ()=>Navigator.of(context).push(createRoute(const CartScreen())),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.shopping_cart_checkout, size: 20,),
          Text("Checkout")
        ],
      )
  );
}

ButtonStyle buttonSmStyle(){
  return ElevatedButton.styleFrom(
      minimumSize: const Size(200, 50),
      textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500
      )
  );
}

ButtonStyle buttonMdStyle({
  double? elevation
}){
  return ElevatedButton.styleFrom(
    elevation: elevation,
    minimumSize: const Size(300, 50),
    textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500
    ),
  );
}

ButtonStyle buttonLgStyle(){
  return ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 50),
      textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500
      )
  );
}

ButtonStyle buttonPrimarySmStyle(){
  return ElevatedButton.styleFrom(
      primary: Colours.primary,
      onPrimary: Colors.white,
      minimumSize: const Size(200, 50),
      textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500
      )
  );
}

ButtonStyle buttonPrimaryMdStyle({
  double? elevation
}){
  return ElevatedButton.styleFrom(
      elevation: elevation,
      primary: Colours.primary,
      onPrimary: Colors.white,
      minimumSize: const Size(300, 50),
      textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500
      )
  );
}

ButtonStyle buttonPrimaryLgStyle(){
  return ElevatedButton.styleFrom(
      primary: Colours.primary,
      onPrimary: Colors.white,
      minimumSize: const Size(double.infinity, 50),
      textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500
      )
  );
}

ButtonStyle cartCountBtnStyle(){
  return ElevatedButton.styleFrom(
      elevation: 2,
      primary: Colors.white,
      surfaceTintColor: Colors.white,
      minimumSize: const Size(30, 30),
      padding: EdgeInsets.symmetric(horizontal: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap
  );
}

class RoundSMButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const RoundSMButton({
    Key? key,
    required this.child,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ()=>onPressed(),
      style: ElevatedButton.styleFrom(
        elevation: 2,
        fixedSize: const Size(50, 50),
        shape: const CircleBorder(),
      ),
      child: const Icon(Icons.add),
    );
  }
}


class GoogleSignInButton extends StatelessWidget {
  final void Function()? onClick;
  const GoogleSignInButton({Key? key, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            minimumSize: const Size(170, 40),
            textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200
            )
        ),
        onPressed: (){
          if(onClick != null){
            onClick!();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Ionicons.logo_google, size: 20, color: Colors.red,),
            SizedBox(width: 10,),
            Text(
              "Google",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        )
    );
  }
}

class FacebookSignInButton extends StatelessWidget {
  final void Function()? onClick;
  const FacebookSignInButton({Key? key, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            minimumSize: const Size(170, 40),
            textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200
            )
        ),
        onPressed: (){
          if(onClick != null){
            onClick!();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Ionicons.logo_facebook, size: 20, color: Colors.blueAccent,),
            SizedBox(width: 10,),
            Text(
              "Facebook",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        )
    );
  }
}
