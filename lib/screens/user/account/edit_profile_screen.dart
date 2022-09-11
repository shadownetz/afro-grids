import 'package:afro_grids/blocs/user/user_bloc.dart';
import 'package:afro_grids/blocs/user/user_event.dart';
import 'package:afro_grids/models/user/user_model.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/navigation_guards.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../blocs/user/user_state.dart';
import '../../../utilities/forms/profile_forms.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white,),
        title: const Text("Update Profile"),
      ),
      body: CustomLoadingOverlay(
        widget: BlocProvider<UserBloc>(
          create: (context)=>UserBloc(),
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state){
              if(state is UserLoadingState){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
              if(state is UserErrorState){
                Alerts(context).showErrorDialog(title: "Update Error", message: state.message);
              }
              if(state is UserLoadedState){
                Alerts(context).showToast("Profile updated");
                NavigationGuards(user: widget.user).navigateToDashboard();
              }
            },
            builder: (context, state){
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    UpdateUserProfileForm(
                      user: widget.user,
                      onUpdate: (user, placeId, newPassword, newAvatar){
                        BlocProvider
                            .of<UserBloc>(context)
                            .add(UpdateUserEvent(
                            user,
                            placeId: placeId,
                            password: newPassword,
                            avatar: newAvatar
                        ));
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
