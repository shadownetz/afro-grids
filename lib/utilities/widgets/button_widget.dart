import 'package:afro_grids/blocs/cart/cart_bloc.dart';
import 'package:afro_grids/blocs/cart/cart_state.dart';
import 'package:afro_grids/blocs/user/user_bloc.dart';
import 'package:afro_grids/blocs/user/user_event.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/models/local/local_cart_model.dart';
import 'package:afro_grids/models/user/user_model.dart';
import 'package:afro_grids/screens/user/cart_screen.dart';
import 'package:afro_grids/screens/user/leave_a_review_screen.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../blocs/user/user_state.dart';

Widget leaveAReviewButton(BuildContext context, {required UserModel provider}){
  return ElevatedButton(
      style: buttonPrimaryLgStyle(),
      onPressed: (){
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context)=>LeaveAReviewScreen(user: provider,)
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
      onPressed: ()=>NavigationService.toPage(const CartScreen()),
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

class RoundSMButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const RoundSMButton({
    Key? key,
    required this.child,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ()=>onPressed(),
      style: ElevatedButton.styleFrom(
        elevation: 2,
        fixedSize: const Size(50, 50),
        shape: const CircleBorder(),
      ),
      child: child,
    );
  }
}


class GoogleSignInButton extends StatelessWidget {
  final void Function()? onClick;
  const GoogleSignInButton({Key? key, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            minimumSize: const Size(170, 40),
            textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200
            )
        ),
        onPressed: (){
          if(onClick != null){
            onClick!();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Ionicons.logo_google, size: 20, color: Colors.red,),
            SizedBox(width: 10,),
            Text(
              "Google",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        )
    );
  }
}

class FacebookSignInButton extends StatelessWidget {
  final void Function()? onClick;
  const FacebookSignInButton({Key? key, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            minimumSize: const Size(170, 40),
            textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200
            )
        ),
        onPressed: (){
          if(onClick != null){
            onClick!();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Ionicons.logo_facebook, size: 20, color: Colors.blueAccent,),
            SizedBox(width: 10,),
            Text(
              "Facebook",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        )
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({Key? key}) : super(key: key);

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  late LocalCartModel cart;

  @override
  void initState() {
    cart = localStorage.cart;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state){
        if(state is CartLoadedState){
          setState(()=>cart=localStorage.cart);
        }
      },
      builder: (context, state){
        return IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: ()=>Navigator.of(context).push(createRoute(const CartScreen())),
            icon: CartIcon(itemCount: cart.totalItems)
        );
      },
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final UserModel user;
  const FavoriteButton({Key? key, required this.user}) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;

  @override
  void initState() {
    _isFavorite = localStorage.user!.isFavorite(widget.user.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context)=>UserBloc(),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state){
            if(state is UserLoadedState){
              setState(()=>_isFavorite=!_isFavorite);
              if(_isFavorite){
                Alerts(context).showToast("Added to favorites");
              }else{
                Alerts(context).showToast("Removed from favorites");
              }
            }
            if(state is UserErrorState){
              Alerts(context).showToast(state.message);
            }
          },
          builder: (context, state){
            return IconButton(
                onPressed: (){
                  var user = UserModel.copyWith(localStorage.user!);
                  if(_isFavorite){
                    user.favorites.remove(widget.user.id);
                  }else{
                    user.favorites.add(widget.user.id);
                  }
                  BlocProvider.of<UserBloc>(context).add(UpdateUserEvent(user));
                },
                icon: Icon(
                  _isFavorite ? Icons.star: Icons.star_border,
                  color: Colors.white,
                )
            );
          },
        ),
    );
  }
}

class FavoriteButton2 extends StatefulWidget {
  final UserModel user;
  const FavoriteButton2({Key? key, required this.user}) : super(key: key);

  @override
  State<FavoriteButton2> createState() => _FavoriteButton2State();
}

class _FavoriteButton2State extends State<FavoriteButton2> {
  bool _isFavorite = false;

  @override
  void initState() {
    _isFavorite = localStorage.user!.isFavorite(widget.user.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>UserBloc(),
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state){
          if(state is UserLoadedState){
            setState(()=>_isFavorite=!_isFavorite);
            if(_isFavorite){
              Alerts(context).showToast("Added to favorites");
            }else{
              Alerts(context).showToast("Removed from favorites");
            }
          }
          if(state is UserErrorState){
            Alerts(context).showToast(state.message);
          }
        },
        builder: (context, state){
          return GestureDetector(
            child: Chip(
              avatar: Icon(Icons.bookmarks,size: 15, color: _isFavorite? Colors.white: Colours.primary,),
              label: Text(
                _isFavorite? "Favorited":"Favorite",
                style: TextStyle(fontSize: 15, color: _isFavorite? Colors.white:Colours.primary),
              ),
              backgroundColor: _isFavorite? Colours.primary: Colours.tertiary,
              elevation: 2,
            ),
            onTap: (){
              var user = UserModel.copyWith(localStorage.user!);
              if(_isFavorite){
                user.favorites.remove(widget.user.id);
              }else{
                user.favorites.add(widget.user.id);
              }
              BlocProvider.of<UserBloc>(context).add(UpdateUserEvent(user));
            },
          );
        },
      ),
    );

  }
}

