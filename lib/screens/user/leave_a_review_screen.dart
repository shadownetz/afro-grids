import 'dart:ui';

import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';

import '../../utilities/widgets/button_widget.dart';
import '../../utilities/widgets/widgets.dart';

class LeaveAReviewScreen extends StatefulWidget {
  const LeaveAReviewScreen({Key? key}) : super(key: key);

  @override
  State<LeaveAReviewScreen> createState() => _LeaveAReviewScreenState();
}

class _LeaveAReviewScreenState extends State<LeaveAReviewScreen> {
  int ratingValue = 0;
  var reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        child: Container(
          // alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // provider avatar
                  roundImage(
                    image: AssetImage('assets/avatars/man.png'),
                    hasShadow: true
                  ),
                  SizedBox(width: 15,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("George Rufus", style: TextStyle(fontSize: 25),),
                      Text("minter", style: TextStyle(color: Colors.grey),)
                    ],
                  ))
                ],
              ),
              SizedBox(height: 10,),
              getStarRatings(),
              SizedBox(height: 20,),
              TextField(
                controller: reviewController,
                maxLength: 250,
                maxLines: 10,
                cursorHeight: 20,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Your review",
                  filled: true,
                  fillColor: Color.fromRGBO(240, 240, 240, 1),
                  border: InputBorder.none,
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: ()=>Navigator.of(context).pop(),
                  style: buttonPrimaryLgStyle(),
                  child: Text("Done")
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getStarRatings(){
    List<Widget> ratingIcons = [];
    for(int i=0; i<ratingValue; i++){
      ratingIcons.add(IconButton(
        alignment: Alignment.centerLeft,
          onPressed: ()=>setState(()=>ratingValue=i+1),
          icon: const Icon(
            Icons.star, size: 30,color: Colours.secondary,
          )
      ));
    }
    for(int i=ratingIcons.length; i<5; i++){
      ratingIcons.add(IconButton(
          alignment: Alignment.centerLeft,
          onPressed: ()=>setState(()=>ratingValue=i+1),
          icon: const Icon(
            Icons.star_border, size: 30,color: Colours.secondary,
          )
      ));
    }
    return Row(
      children: ratingIcons,
    );
  }
}
