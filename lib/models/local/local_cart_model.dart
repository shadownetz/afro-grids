
import 'package:afro_grids/utilities/currency.dart';

import '../../utilities/func_utils.dart';
import '../inventory_model.dart';

class LocalCartItem{
  InventoryModel inventory;
  int count;
  LocalCartItem({
    required this.inventory,
    required this.count
  });

  get priceStr{
    return CurrencyUtil().format(inventory.price);
  }
}

class LocalCartModel{
  String id;
  List<LocalCartItem> cartItems;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  LocalCartModel({required this.id, required this.cartItems});

  String get currency{
    if(cartItems.isNotEmpty){
      return cartItems.first.inventory.currency;
    }
    return "";
  }

  int get totalItems{
    return cartItems.map((cartItem) => cartItem.count).reduce((val1, val2) => val1+val2);
  }

  num get totalPrice{
    return cartItems.map((cartItem) => cartItem.inventory.price*cartItem.count).reduce((val1, val2) => val1+val2);
  }

  String get totalPriceStr{
    return CurrencyUtil().format(totalPrice);
  }

}