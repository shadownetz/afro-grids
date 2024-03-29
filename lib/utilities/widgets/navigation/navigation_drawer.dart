import 'package:afro_grids/blocs/auth/auth_state.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/screens/user/cart_screen.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:afro_grids/utilities/widgets/navigation/admin_navigation.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:afro_grids/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../blocs/auth/auth_event.dart';
import '../../../screens/provider/account/inventory_screen.dart';
import '../../../screens/user/account/user_profile_screen.dart';
import '../../alerts.dart';
import '../../colours.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: DrawerHeader(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                  color: Colours.primary,
                  border: Border.all(style: BorderStyle.none, color: Colors.transparent, width: 0)
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      localStorage.user!.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white, fontSize: 30,
                      ),),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: HalfWhiteOverlay2(),
                  )
                ],
              ),
            ),
          ),
          BlocProvider(
            create: (context)=>AuthBloc(),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state){
                if(state is UnAuthenticatedState){
                  Navigator.of(context).pushNamedAndRemoveUntil("/signin", (route)=>false);
                }else if(state is AuthErrorState){
                  Alerts(context).showToast(state.message);
                }
              },
              builder: (context, state){
                return Expanded(
                    flex: 1,
                    child: ListView(
                      padding: const EdgeInsets.only(top: 0),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person, color: Colours.primary),
                          title: const Text("Profile", style: TextStyle(fontSize: 20),),
                          onTap: ()=>Navigator.of(context).push(createRoute(UserProfileScreen(user: localStorage.user!,))),
                        ),
                        const Divider(),
                        localStorage.user!.accessLevel == AccessLevel.provider?
                        ListTile(
                          leading: const Icon(Ionicons.bag_handle, color: Colours.primary),
                          title: const Text("Inventory", style: TextStyle(fontSize: 20),),
                          onTap: ()=>Navigator.of(context).push(createRoute(const InventoryScreen())),
                        ): const SizedBox(),
                        localStorage.user!.accessLevel == AccessLevel.provider? const Divider(): const SizedBox(),
                        ListTile(
                          leading: const Icon(Ionicons.cart, color: Colours.primary),
                          title: const Text("Cart", style: TextStyle(fontSize: 20),),
                          onTap: ()=>Navigator.of(context).push(createRoute(const CartScreen())),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Ionicons.log_out, color: Colours.primary),
                          title: const Text("Logout", style: TextStyle(fontSize: 20),),
                          onTap: ()=>BlocProvider.of<AuthBloc>(context).add(LogoutEvent()),
                        ),
                      ],
                    )
                );
              },
            ),
          ),
          (localStorage.user!.accessLevel == AccessLevel.superAdmin || localStorage.user!.accessLevel == AccessLevel.admin)?
          const Expanded(
              child:  Padding(
                padding: EdgeInsets.all(10),
                child: AdminNav(),
              )
          ):
          const SizedBox()
        ],
      ),
    );
  }
}