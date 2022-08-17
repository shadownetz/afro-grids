import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../../utilities/forms/profile_forms.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        title: const Text("Update Profile"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            Center(
              child: GestureDetector(
                onTap: (){},
                child: Stack(
                  children: [
                    RoundImage(
                        image: const AssetImage("assets/avatars/man.png"),
                        width: 130,
                        height: 130
                    ),
                    Container(
                      height: 130,
                      width: 130,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          shape: BoxShape.circle
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image, color: Colors.white,),
                          SizedBox(width: 5,),
                          Text("update", style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            UpdateUserProfileForm(
              onUpdate: (user){
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
