import 'package:afro_grids/screens/user/account/edit_profile_screen.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';

import '../../../utilities/widgets/widgets.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Container(
        height: deviceHeight,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  roundImage(
                      image: AssetImage("assets/avatars/man.png"),
                      width: 130,
                      height: 130
                  ),
                  SizedBox(height: 10,),
                  Text("Tony Anderson", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Text("Lagos, Nigeria", style: TextStyle(fontSize: 15, color: Colors.grey),),
                ],
              ),
            ),
            SizedBox(height: 30,),
            // phone
            ListTile(
              title: Text("+238967677682", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
              subtitle: Text("Phone", style: TextStyle(fontSize: 15, color: Colors.grey),),
            ),
            // email
            ListTile(
              title: Text("tony@gmail.com", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
              subtitle: Text("Email", style: TextStyle(fontSize: 15, color: Colors.grey),),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: ()=>Navigator.of(context).push(createRoute(const EditProfileScreen())),
        style: ElevatedButton.styleFrom(
          elevation: 5,
          minimumSize: Size(50, 50),
          primary: Colours.primary,
          onPrimary: Colors.white,
          shape:CircleBorder()
        ),
        child: Icon(Icons.edit),
      ),
    );
  }
}
