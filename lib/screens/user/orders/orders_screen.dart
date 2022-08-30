import 'package:afro_grids/blocs/order/order_bloc.dart';
import 'package:afro_grids/blocs/order/order_event.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/models/local/local_order_model.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/currency.dart';
import 'package:afro_grids/utilities/type_extensions.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../blocs/order/order_state.dart';
import '../orders/view_order_screen.dart';



class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<LocalOrderModel> _orders = [];
  final ScrollController _scrollController = ScrollController();
  OrderBloc? orderBloc;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
        if(_orders.isNotEmpty){
          if(_orders.first.totalOrderCount! != _orders.length){
            orderBloc!.add(FetchNextUserOrders(user: localStorage.user!, cursor: _orders.last));
          }
        }
      }
      // if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
      //     !_scrollController.position.outOfRange) {
      //
      // }

    });
    super.initState();
  }

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
      body: CustomLoadingOverlay(
        widget: BlocProvider<OrderBloc>(
          create: (context)=>OrderBloc()..add(FetchUserOrders(user: localStorage.user!)),
          child: BlocConsumer<OrderBloc, OrderState>(
            listener: (context, state){
              if(state is OrderLoadingState){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
              if(state is OrderLoadedState){
                setState(()=>_orders.addAll(state.userOrders!));
              }
              if(state is OrderErrorState){
                Alerts(context).showErrorDialog(title: "Error", message: state.message);
              }
            },
            builder: (context, state){
              orderBloc = BlocProvider.of<OrderBloc>(context);
              if(_orders.isEmpty){
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: const Text("You have not made any orders yet", style: TextStyle(fontSize: 20, color: Colors.grey),),
                );
              }
              return Container(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  controller: _scrollController,
                  children: buildList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> buildList(){
    List<Widget> items = [];
    for (var order in _orders) {
      for (var inventory in order.inventories) {
        items.add(ListTile(
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
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (inventory != null ?
                      NetworkImage(inventory.images.first):
                      const AssetImage("assets/icons/cart.png")) as ImageProvider,
                      fit: BoxFit.contain,
                    )
                ),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                inventory!=null? inventory.name: "####",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
              ),
              Text(
                "order ${order.orderModel.orderNo}",
                style: const TextStyle(fontSize: 15, color: Colors.grey, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${CurrencyUtil().currencySymbol(order.orderModel.currency)}${inventory!=null?inventory.price:0}",
                style: const TextStyle(fontSize: 20, color: Colours.secondary, overflow: TextOverflow.ellipsis),
              ),
              Text(
                "created on ${inventory!=null?order.orderModel.createdAt.toDateTimeStr():""}",
                style: const TextStyle(color: Colours.primary, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          trailing: Text("X${inventory!=null?order.inventorySize(inventory): '0'}", style: const TextStyle(fontSize: 20, color: Colors.grey),),
          onTap: (){
            if(inventory != null){
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context)=>ViewOrderScreen(inventory: inventory, order: order,)
              );
            }
          },
        ));
      }
    }
    return items;
  }
}
