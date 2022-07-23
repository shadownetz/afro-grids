import 'package:afro_grids/screens/provider/leave_a_review_screen.dart';
import 'package:afro_grids/utilities/colours.dart';
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

ButtonStyle buttonSmStyle(){
  return ElevatedButton.styleFrom(
      minimumSize: const Size(200, 50),
      textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500
      )
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

ButtonStyle buttonPrimaryMdStyle(){
  return ElevatedButton.styleFrom(
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