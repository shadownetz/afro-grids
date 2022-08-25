import 'package:afro_grids/blocs/cart/cart_bloc.dart';
import 'package:afro_grids/blocs/cart/cart_event.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../blocs/cart/cart_state.dart';
import '../../models/local/local_cart_model.dart';
import '../../utilities/currency.dart';
import '../../utilities/widgets/button_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late LocalCartModel localCart;

  @override
  void initState() {
    localCart = localStorage.cart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoadingOverlay(
        widget: BlocConsumer<CartBloc, CartState>(
          listener: (context, state){
            if(state is CartLoadingState){
              context.loaderOverlay.show();
            }else{
              context.loaderOverlay.hide();
            }
            if(state is CartErrorState){
              Alerts(context).showToast("Unable to update cart content");
            }
            if(state is CartLoadedState){
              setState(()=>localCart=localStorage.cart);
            }
          },
          builder: (context, state){
            if(state is CartCheckedOutState){
              return Alerts(context).orderCompleted();
            }
            return Scaffold(
              backgroundColor: Colours.tertiary,
              appBar: AppBar(
                title: const Text("Cart"),
              ),
              body: Container(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      getCartItems(),
                      // delivery info section
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        margin: EdgeInsets.only(top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              child: Row(
                                children: const [
                                  Icon(Icons.info, size: 15),
                                  SizedBox(width: 5,),
                                  Text("Delivery address", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),)
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              child: Text(
                                localStorage.user!.deliveryAddress.isNotEmpty?
                                localStorage.user!.deliveryAddress:
                                "(Important) Update your profile to set your delivery address!",
                                textAlign: localStorage.user!.deliveryAddress.isNotEmpty? TextAlign.left: TextAlign.center,
                                style: TextStyle(
                                    color: localStorage.user!.deliveryAddress.isNotEmpty? Colours.primary: Colors.redAccent
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // order summary section
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        margin: EdgeInsets.only(top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              child: Row(
                                children: const [
                                  Icon(Icons.shopping_bag_outlined, size: 15),
                                  SizedBox(width: 5,),
                                  Text("Order summary", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),)
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("No. of Items", style: TextStyle(fontSize: 17),),
                                      Expanded(child: Text("${localCart.totalItems}", textAlign: TextAlign.right, style: TextStyle(fontSize: 17),))
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Text("Total", style: TextStyle(fontSize: 20),),
                                      Expanded(child: Text("${CurrencyUtil().currencySymbol(localCart.currency)}${localCart.totalPriceStr}", textAlign: TextAlign.right, style: TextStyle(fontSize: 20, color: Colours.secondary),))
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 50,),
                      // pay button
                      ElevatedButton(
                          onPressed: (){
                            if(localStorage.user!.deliveryAddress.isNotEmpty){
                              BlocProvider.of<CartBloc>(context).add(AddCheckoutEvent(localCart: localCart, user: localStorage.user!));
                            }else{
                              Alerts(context).showErrorDialog(title: "Important", message: "Set your delivery address to continue");
                            }
                          },
                          style: buttonPrimaryMdStyle(),
                          child: Text("Pay ${CurrencyUtil().currencySymbol(localCart.currency)}${localCart.totalPriceStr}", overflow: TextOverflow.ellipsis,)
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
    );
  }

  Widget getCartItems(){
    var items =  localCart.cartItems.map((cartItem){
      return Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Container(
                height: 80,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                    image: DecorationImage(
                        image: (cartItem.inventory.images.isNotEmpty?
                        NetworkImage(cartItem.inventory.images.first):
                        const AssetImage("assets/icons/cart.png")) as ImageProvider,
                        fit: BoxFit.cover
                    )
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(cartItem.inventory.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),),
                  SizedBox(width: 10,),
                  Text('${CurrencyUtil().currencySymbol(cartItem.inventory.currency)}${cartItem.priceStr}', style: const TextStyle(fontSize: 17, color: Colours.secondary),),
                  // cart count control buttons
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: (){
                            if(cartItem.count > 1){
                              BlocProvider.of<CartBloc>(context).add(ReduceItemCountEvent(cartItem));
                            }
                          },
                          style: cartCountBtnStyle(),
                          child: const Icon(Icons.remove, size: 15,)
                      ),
                      SizedBox(width: 10,),
                      Text('${cartItem.count}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                      SizedBox(width: 10,),
                      ElevatedButton(
                          onPressed: (){
                            BlocProvider.of<CartBloc>(context).add(AddToCartEvent(cartItem));
                          },
                          style: cartCountBtnStyle(),
                          child: const Icon(Icons.add, size: 15,)
                      ),
                    ],
                  )
                ],
              )),
              Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: (){
                      if(localCart.cartItems.isNotEmpty){
                        BlocProvider.of<CartBloc>(context).add(RemoveFromCartEvent(cartItem));
                      }
                    },
                    icon: Icon(Ionicons.close_circle),
                  )),
            ],
          ),
        ),
      );
    }).toList();
    if(items.isNotEmpty) {
      return Column(
        children: items,
      );
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_shopping_cart, size: 20,),
          SizedBox(width: 10,),
          Text("Your cart is currently empty", style: TextStyle(fontSize: 20),)
        ],
      ),
    );
  }
}
