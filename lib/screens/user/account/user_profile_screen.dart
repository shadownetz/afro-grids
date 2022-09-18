import 'package:afro_grids/models/user/user_model.dart';
import 'package:afro_grids/screens/provider/account/withdraw_request_screen.dart';
import 'package:afro_grids/screens/user/account/edit_profile_screen.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/currency.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../utilities/widgets/widgets.dart';
import '../../provider/account/view_withdraw_request_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final UserModel user;
  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white,),
        title: const Text("Profile"),
        actions: user.accessLevel == AccessLevel.provider ?
        [
          IconButton(
              onPressed: (){
                NavigationService.toPage(ViewWithdrawRequestScreen(user: user));
              },
              icon: const Icon(Ionicons.file_tray, color: Colors.white,)
          )
        ]: null,
      ),
      body: Container(
        height: deviceHeight,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  RoundImage(
                    image: (user.avatar.isEmpty ? const AssetImage("assets/avatars/man.png"): NetworkImage(user.avatar)) as ImageProvider,
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10,),
                  Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                  const SizedBox(height: 10,),
                  Text(user.address, style: const TextStyle(fontSize: 15, color: Colors.grey),),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            user.accessLevel == AccessLevel.provider?
            ListTile(
              title: Text(
                "${CurrencyUtil().currencySymbol(user.currency)}${user.availableBalance}",
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text("Available balance", style: TextStyle(fontSize: 15, color: Colors.grey),),
              trailing: user.availableBalance > 0 ?
              ElevatedButton(
                child: const Text(
                  "withdraw",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onPressed: (){
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context)=>WithdrawRequestScreen(user: user,)
                  );
                },
              ): null,
            ):
            const SizedBox(),
            // phone
            ListTile(
              title: Text(user.phone, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
              subtitle: const Text("Phone (verified)", style: TextStyle(fontSize: 15, color: Colors.grey),),
            ),
            // email
            ListTile(
              title: Text(user.email, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
              subtitle: const Text("Email", style: TextStyle(fontSize: 15, color: Colors.grey),),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: ()=>NavigationService.toPage(EditProfileScreen(user: user,)),
        style: ElevatedButton.styleFrom(
            elevation: 5,
            minimumSize: const Size(50, 50),
            primary: Colours.primary,
            onPrimary: Colors.white,
            shape:const CircleBorder()
        ),
        child: const Icon(Icons.edit),
      ),
    );
  }
}
