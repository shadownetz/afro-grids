import 'package:afro_grids/screens/user/cart_screen.dart';
import 'package:afro_grids/screens/user/leave_a_review_screen.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';

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