import 'dart:async';

import 'package:afro_grids/models/user_model.dart';

import 'local_cart_model.dart';

class LocalStorageModel{
  UserModel? user;
  StreamSubscription? userListener;
  final List<String> _notifications;
  LocalCartModel cart;

  LocalStorageModel({this.user}):
        cart = LocalCartModel(cartItems: [], id: ''),
        _notifications = [];

  String get getNextNotification{
    return _notifications.removeAt(0);
  }

  List<String>? get notifications{
    return _notifications.isEmpty? null: _notifications;
  }

  void addItemToCart(LocalCartItem cartItem){
    var idx = cart.cartItems.indexWhere((localCartItem) => cartItem.inventory.id == localCartItem.inventory.id);
    if(idx >= 0){
      cart.cartItems[idx].count++;
    }else{
      cart.cartItems.add(cartItem);
    }
  }

  void removeItemFromCart(LocalCartItem cartItem){
    var idx = cart.cartItems.indexWhere((localCartItem) => cartItem.inventory.id == localCartItem.inventory.id);
    if(idx >= 0){
      cart.cartItems.removeAt(idx);
    }
  }

  void reduceItemFromCart(LocalCartItem cartItem){
    var idx = cart.cartItems.indexWhere((localCartItem) => cartItem.inventory.id == localCartItem.inventory.id);
    if(idx >= 0){
      cart.cartItems[idx].count--;
    }
  }

  void addNotification(String value){
    _notifications.add(value);
  }


}