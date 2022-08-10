
import 'package:afro_grids/utilities/currency.dart';

import '../../utilities/func_utils.dart';
import '../inventory_model.dart';

class LocalCartItem{
  InventoryModel inventory;
  int count;
  LocalCartItem(this.inventory, this.count);

  get priceStr{
    return CurrencyUtil().format(inventory.price);
  }
}

class LocalCartModel{
  List<LocalCartItem> cartItems;
  String currency = '';

  LocalCartModel(this.cartItems){
    if(cartItems.isNotEmpty){
      currency = cartItems.first.inventory.currency;
    }
  }

  get totalItems{
    return cartItems.map((cartItem) => cartItem.count).reduce((val1, val2) => val1+val2);
  }

  get totalPrice{
    return cartItems.map((cartItem) => cartItem.inventory.price*cartItem.count).reduce((val1, val2) => val1+val2);
  }

  get totalPriceStr{
    return CurrencyUtil().format(totalPrice);
  }

}