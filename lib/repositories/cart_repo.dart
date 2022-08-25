import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/models/cart_model.dart';
import 'package:afro_grids/models/local/local_cart_model.dart';
import 'package:afro_grids/models/model_types.dart';
import 'package:afro_grids/repositories/inventory_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

}