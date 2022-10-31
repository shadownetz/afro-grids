import 'package:afro_grids/blocs/auth/auth_bloc.dart';
import 'package:afro_grids/blocs/auth/auth_state.dart';
import 'package:afro_grids/models/user/user_model.dart';
import 'package:afro_grids/screens/provider/account/withdraw_request_screen.dart';
import 'package:afro_grids/screens/user/account/edit_profile_screen.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/currency.dart';
import 'package:afro_grids/utilities/func_utils.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../blocs/auth/auth_event.dart';
import '../../../utilities/alerts.dart';
import '../../../utilities/widgets/widgets.dart';
import '../../provider/account/view_withdraw_request_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';


class UserProfileScreen extends StatefulWidget {
  final UserModel user;

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  AuthBloc? authBloc;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white,),
        title: const Text("Profile"),
        actions: widget.user.accessLevel == AccessLevel.provider ?
        [
          IconButton(
              onPressed: (){
                NavigationService.toPage(ViewWithdrawRequestScreen(user: widget.user));
              },
              icon: const Icon(Ionicons.file_tray, color: Colors.white,)
          )
        ]: null,
      ),
      body: CustomLoadingOverlay(
        widget: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state){
            if(state is AuthLoadingState){
              context.loaderOverlay.show();
            }else{
              context.loaderOverlay.hide();
            }
            if(state is UnAuthenticatedState){
              Navigator.of(context).pushNamedAndRemoveUntil("/signin", (route)=>false);
            }
            else if(state is AuthErrorState){
              Alerts(context).showErrorDialog(title: "Error", message: state.message);
            }
          },
          builder: (context, state){
            authBloc = BlocProvider.of<AuthBloc>(context);
            return Container(
              height: deviceHeight,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Expanded(
                      child: ListView(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                RoundImage(
                                  image: (widget.user.avatar.isEmpty ? const AssetImage("assets/avatars/man.png"): NetworkImage(widget.user.avatar)) as ImageProvider,
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 10,),
                                Text(widget.user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                                const SizedBox(height: 10,),
                                Text(widget.user.address, style: const TextStyle(fontSize: 15, color: Colors.grey),),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30,),
                          widget.user.accessLevel == AccessLevel.provider?
                          ListTile(
                            title: Text(
                              "${CurrencyUtil().currencySymbol(widget.user.currency)}${widget.user.availableBalance.toStringAsPrecision(2)}",
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            subtitle: const Text("Available balance", style: TextStyle(fontSize: 15, color: Colors.grey),),
                            trailing: widget.user.availableBalance > 0 ?
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
                                    builder: (context)=>WithdrawRequestScreen(user: widget.user,)
                                );
                              },
                            ): null,
                          ):
                          const SizedBox(),
                          widget.user.accessLevel == AccessLevel.provider?
                          ListTile(
                            title: Text(
                              "${CurrencyUtil().currencySymbol(widget.user.currency)}${widget.user.outstandingBalance.toStringAsPrecision(2)}",
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            subtitle: const Text("Outstanding balance", style: TextStyle(fontSize: 15, color: Colors.grey),),
                          ):
                          const SizedBox(),
                          // phone
                          ListTile(
                            title: Text(widget.user.phone, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                            subtitle: const Text("Phone (verified)", style: TextStyle(fontSize: 15, color: Colors.grey),),
                          ),
                          // email
                          ListTile(
                            title: Text(widget.user.email, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                            subtitle: const Text("Email", style: TextStyle(fontSize: 15, color: Colors.grey),),
                          ),
                          ListTile(
                            title: const Text("Contact support", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                            onTap: (){
                              FuncUtils.openWhatsappURL(phoneNumber: "2349065172898", message: "Hello my name is ");
                            },
                          ),
                        ],
                      )
                  ),
                  Center(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: Colors.grey),
                      icon: const Icon(Icons.delete, size: 15,),
                      label: const Text("Delete account", style: TextStyle(fontSize: 15),),
                      onPressed: () async {
                        bool? decision = await Alerts(context).showConfirmDialog(
                            title: "Critical Information",
                            message: "You are about to delete your account. Note that this operation will delete your data that exist on other AfroGrids apps"
                        );
                        if(decision == true){
                          authBloc!.add(DeleteAccountEvent(user: widget.user));
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: ()=>NavigationService.toPage(EditProfileScreen(user: widget.user,)),
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
