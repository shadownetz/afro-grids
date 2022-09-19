import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/local/local_cart_model.dart';
import 'package:afro_grids/models/local/local_order_model.dart';
import 'package:afro_grids/models/model_types.dart';
import 'package:afro_grids/models/order_model.dart';
import 'package:afro_grids/models/payment_response_model.dart';
import 'package:afro_grids/models/user/user_model.dart';
import 'package:afro_grids/repositories/inventory_repo.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:afro_grids/utilities/func_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepo{
  OrderModel? order;
  final CollectionReference _orderRef;
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
        currency: cart.currency,
        deliveryAddress: user.deliveryAddress,
        totalPrice: cart.totalPrice,
        paymentResponse: paymentResponse?.toJson(),
        status: OrderStatus.accepted,
        createdAt: DateTime.now()
    );
    await _orderRef.add(newOrder.toMap());
  }

  Future<List<LocalOrderModel>> fetchOrdersByUser(
      {required String userId, DocumentSnapshot? cursor, int? limit})async{
    Query query = _orderRef.where('createdBy', isEqualTo: userId);
    var orderSize = (await query.get()).size;
    if(cursor != null){
      query = query.startAfterDocument(cursor);
    }
    if(limit != null){
      query = query.limit(limit);
    }
    var querySnapshot = await query.get();
    List<OrderModel> orders = querySnapshot.docs.map((doc) => OrderModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    List<LocalOrderModel> localOrders = [];
    for(var i=0; i < orders.length; i++){
      var futures = orders[i].items.map((item) => InventoryRepo().getInventory(item.inventoryId));
      var inventories = await Future.wait(futures);
      localOrders.add(LocalOrderModel(
          inventories: inventories,
          orderModel: orders[i],
          snapshot: querySnapshot.docs[i],
          totalOrderCount: orderSize
      ));
    }
    return localOrders;
  }

  Future<void> updateOrder() async {
    await _orderRef.doc(order!.id).update(order!.toMap());
  }
}