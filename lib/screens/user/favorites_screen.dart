import 'package:afro_grids/blocs/user/user_bloc.dart';
import 'package:afro_grids/utilities/navigation_guards.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';
import '../../models/user_model.dart';
import '../../utilities/alerts.dart';
import '../../utilities/colours.dart';

class FavoritesScreen extends StatefulWidget {
  final UserModel user;
  const FavoritesScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  UserBloc? _userBloc;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white,),
        title: const Text("Favorites"),
      ),
      body: CustomLoadingOverlay(
        widget: SizedBox(
          height: deviceHeight,
          width: deviceWidth,
          child: BlocProvider(
            create: (context)=>UserBloc()..add(GetUserFavoritesEvent(widget.user)),
            child: BlocConsumer<UserBloc, UserState>(
              listener: (context, state){
                if(state is UserLoadingState){
                  context.loaderOverlay.show();
                }else{
                  context.loaderOverlay.hide();
                }
                if(state is UserErrorState){
                  Alerts(context).showToast(state.message);
                }
              },
              builder: (context, state){
                _userBloc = BlocProvider.of<UserBloc>(context);
                if(state is UserLoadedState){
                  if(state.users != null){
                    if(state.users!.isNotEmpty){
                      return ListView.separated(
                          itemBuilder: (context, idx){
                            final user = state.users![idx];
                            return ListTile(
                              leading: RoundImage(
                                  fit: BoxFit.cover,
                                  image: (user!.avatar.isNotEmpty? NetworkImage(user.avatar): const AssetImage("assets/avatars/woman.png")) as ImageProvider
                              ),
                              title: Text(user.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                              subtitle: RatingIcons(user.reviews.average.toInt(), iconSize: 20, alignment: MainAxisAlignment.start,),
                              onTap: ()async{
                                await NavigationGuards(user: user).navigateToPortfolioPage();
                                _userBloc!.add(GetUserFavoritesEvent(widget.user));
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                          itemCount: state.users!.length
                      );
                    }
                  }
                }
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: const Text("You have no favorites", style: TextStyle(fontSize: 20, color: Colors.grey),),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
