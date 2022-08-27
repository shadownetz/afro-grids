import 'package:afro_grids/models/local/local_order_model.dart';
import 'package:afro_grids/models/order_model.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';

import '../../../models/inventory_model.dart';
import '../../../utilities/class_constants.dart';
import '../orders/view_order_screen.dart';



class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // TODO: generate model for orders because the template contains hardcoded values
  // this model is for view order
  LocalOrderModel localOrderModel = LocalOrderModel(
      inventory: InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Strawberries", price: 5000, currency: Currency.ngn, description: "Sizes XL&M", images: ["https://picsum.photos/id/1080/200/300","https://picsum.photos/id/119/200/300", "https://picsum.photos/id/133/200/300"], visible: true),
      orderModel: OrderModel(id: '', orderNo: '2397834789', createdBy: '', items: [], currency: '', deliveryAddress: '', totalPrice: 0, paymentResponse: {}, status: '', createdAt: DateTime.now())
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        title: const Text("Orders"),
        actions: [
          PopupMenuButton(
              position: PopupMenuPosition.under,
              icon: const Icon(Icons.filter_list),
              onSelected: (String item){
                print(item);
              },
              itemBuilder: (context){
                return [
                  const PopupMenuItem<String>(
                      enabled: false,
                      child: Text("Sort By")
                  ),
                  const PopupMenuItem<String>(
                      value: "date_asc",
                      child: Text("date (ascending)")
                  ),
                  const PopupMenuItem<String>(
                      value: "date_desc",
                      child: Text("date (descending)")
                  )
                ];
              }
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.separated(
            itemCount: 3,
            separatorBuilder: (context, idx)=>const Divider(),
            itemBuilder: (context, idx){
              return ListTile(
                isThreeLine: true,
                leading: Transform.translate(
                  offset: Offset(0, -5),
                  child: Card(
                    margin: EdgeInsets.all(0),
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 3,
                    child: Container(
                      width: 70,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icons/cart.png"),
                            fit: BoxFit.contain,
                          )
                      ),
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Sweather (black)", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),),
                    Text("order 472890827", style: TextStyle(fontSize: 15, color: Colors.grey, overflow: TextOverflow.ellipsis),),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("N3000", style: TextStyle(fontSize: 20, color: Colours.secondary, overflow: TextOverflow.ellipsis),),
                    Text("created on 3 February 2022 at 15:01", style: TextStyle(color: Colours.primary, overflow: TextOverflow.ellipsis),),
                  ],
                ),
                trailing: const Text("X3", style: TextStyle(fontSize: 20, color: Colors.grey),),
                onTap: (){
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context)=>ViewOrderScreen(localOrder: localOrderModel)
                  );
                },
              );
            }
        ),
      ),
    );
  }
}
