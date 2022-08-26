import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/models/cart_model.dart';
import 'package:afro_grids/models/local/local_cart_model.dart';
import 'package:afro_grids/models/model_types.dart';
import 'package:afro_grids/repositories/inventory_repo.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/payment_response_model.dart';
import '../models/purchase_item_model.dart';
import '../models/user_model.dart';
import '../utilities/services/firebase_analytics_service.dart';
import '../utilities/services/payment_service.dart';

class CartRepo{
  CartModel? cart;
  late final CollectionReference _cartRef;

  CartRepo({this.cart}): _cartRef = FirestoreRef().cartRef;

  Future<LocalCartModel?> getCart(String cartId)async{
    var cartDoc = await _cartRef.doc(cartId).get();
    if(cartDoc.exists){
      var cart = CartModel.fromFirestore(cartDoc as DocumentSnapshot<Map<String, dynamic>>);
      var inventoryFutures = cart.items.map((item) => InventoryRepo().getInventory(item.inventoryId));
      var futuresResult = await Future.wait(inventoryFutures);
      List<LocalCartItem> cartItems = [];
      for(var i=0; i<cart.items.length; i++){
        var cartItem = cart.items[i];
        var inventory = futuresResult.elementAt(i);
        if(inventory!= null){
          cartItems.add(LocalCartItem(inventory: inventory, count: cartItem.count));
        }
      }
      var localCart = LocalCartModel(id: cartDoc.id, cartItems: cartItems);
      localCart.createdAt = cart.createdAt;
      localCart.updatedAt = cart.updatedAt;
      return localCart;
    }
    return null;
  }

  Future<void> emptyCart(LocalCartModel localCart){
    var tmpCart = CartModel(
        id: localCart.id,
        createdBy: localStorage.user!.id,
        items: [],
        createdAt: localCart.createdAt,
        updatedAt: DateTime.now()
    );
    return _cartRef.doc(localCart.id).update(tmpCart.toMap());
  }

  Future<void> addToCart(LocalCartModel localCart){
    List<OrderItem> items = localCart
        .cartItems
        .map((cartItem){
          return OrderItem(cartItem.inventory.id, cartItem.count);
        })
        .toList();
    var tmpCart = CartModel(
        id: "",
        createdBy: localStorage.user!.id,
        items: items,
        createdAt: localCart.createdAt,
        updatedAt: DateTime.now()
    );
    return _cartRef.doc(localCart.id).set(tmpCart.toMap());
  }

  Future<PaymentResponseModel> checkout(LocalCartModel localCart, UserModel user) async {
    FirebaseAnalyticsService firebaseAnalyticsService = FirebaseAnalyticsService();
    PaymentResponseModel response;
    await firebaseAnalyticsService.logBeginCheckoutEvent(
        currency: localCart.currency,
        price: localCart.totalPrice
    );
    response = await PaymentService().pay(
        context: NavigationService.navigatorKey.currentContext!,
        email: user.email,
        firstName: user.firstName,
        userId: user.id,
        phone: user.phone,
        amount: localCart.totalPrice.toString(),
        paymentLabel: "Checkout for ${user.email}",
        description: "Paying for items in cart",
        currency: localCart.currency
    );
    var items = localCart.cartItems.map((item){
      return PurchaseItemModel(item.inventory.name, item.inventory.description, item.inventory.price, item.count, item.inventory.currency);
    });
    await firebaseAnalyticsService.logPaymentEvent(
        currency: response.currency!,
        price: response.amount!,
        transactionId: response.txRef!,
        items: items.toList()
    );
    return response;
  }


}