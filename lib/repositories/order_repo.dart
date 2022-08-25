import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/local/local_cart_model.dart';
import 'package:afro_grids/models/model_types.dart';
import 'package:afro_grids/models/order_model.dart';
import 'package:afro_grids/models/payment_response_model.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:afro_grids/utilities/func_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepo{
  OrderModel? order;
  CollectionReference _orderRef;
  OrderRepo({this.order}): _orderRef = FirestoreRef().orderRef;

  Future<void> saveOrder({required LocalCartModel cart, required UserModel user, PaymentResponseModel? paymentResponse})async{
    var items = cart.cartItems.map((cartItem){
      return OrderItem(cartItem.inventory.id, cartItem.count);
    });
    var newOrder = OrderModel(
        id: '',
        orderNo: FuncUtils.getRandomString(length: 10),
        createdBy: user.id,
        items: items.toList(),
        deliveryAddress: user.deliveryAddress,
        totalPrice: cart.totalPrice,
        paymentResponse: paymentResponse,
        status: OrderStatus.approved,
        createdAt: DateTime.now()
    );
    await _orderRef.add(newOrder.toMap());
  }
}