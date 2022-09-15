import 'package:afro_grids/blocs/delivery/delivery_bloc.dart';
import 'package:afro_grids/blocs/delivery/delivery_event.dart';
import 'package:afro_grids/blocs/delivery/delivery_state.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/models/local/local_delivery_model.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/currency.dart';
import 'package:afro_grids/utilities/type_extensions.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import './view_delivery_screen.dart';



class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final List<LocalDeliveryModel> _deliveries = [];
  final ScrollController _scrollController = ScrollController();
  DeliveryBloc? deliveryBloc;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
        if(_deliveries.isNotEmpty){
          if(_deliveries.first.totalDeliveryCount! != _deliveries.length){
            deliveryBloc!.add(FetchNextProviderDeliveriesEvent(provider: localStorage.user!, cursor: _deliveries.last));
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
        title: const Text("Deliveries"),
        leading: const BackButton(color: Colors.white,),
        actions: [
          PopupMenuButton(
              position: PopupMenuPosition.under,
              icon: const Icon(Icons.filter_list, color: Colors.white,),
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
        widget: BlocProvider<DeliveryBloc>(
          create: (context)=>DeliveryBloc()..add(FetchProviderDeliveriesEvent(provider: localStorage.user!)),
          child: BlocConsumer<DeliveryBloc, DeliveryState>(
            listener: (context, state){
              if(state is DeliveryLoadingState){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
              if(state is DeliveryLoadedState){
                setState(()=>_deliveries.addAll(state.deliveries!));
              }
              if(state is DeliveryErrorState){
                Alerts(context).showErrorDialog(title: "Error", message: state.message);
              }
              if(state is DeliveryUpdatedState){
                Alerts(context).showToast("status updated");
              }
            },
            builder: (context, state){
              deliveryBloc = BlocProvider.of<DeliveryBloc>(context);
              if(_deliveries.isEmpty){
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: const Text("You have no deliveries", style: TextStyle(fontSize: 20, color: Colors.grey),),
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
    for (var delivery in _deliveries) {
      var inventory = delivery.inventory;
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
              "Total: ${delivery.deliveryModel.deliveryCount}",
              style: const TextStyle(fontSize: 15, color: Colors.grey, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              delivery.deliveryModel.status,
              style: const TextStyle(fontSize: 15, color: Colours.secondary, overflow: TextOverflow.ellipsis),
            ),
            Text(
              inventory!=null?delivery.deliveryModel.createdAt.toDateTimeStr():"",
              style: const TextStyle(color: Colours.primary, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        trailing: delivery.deliveryModel.status != DeliveryStatus.delivered?
        PopupMenuButton(
            position: PopupMenuPosition.under,
            icon: const Icon(Ionicons.ellipsis_vertical, color: Colours.primary,size: 18,),
            onSelected: (String status)async{
              var decision = await Alerts(context).showConfirmDialog(
                  title: "Critical operation",
                  message: "You will be updating this delivery status to $status. Note that once a delivery is marked ${DeliveryStatus.delivered} no other updates can be made."
              );
              if(decision == true){
                delivery.deliveryModel.status = status;
                deliveryBloc!.add(UpdateDeliveryEvent(delivery.deliveryModel));
              }
            },
            itemBuilder: (context){
              return [
                const PopupMenuItem<String>(
                    enabled: false,
                    child: Text("Toggle status")
                ),
                const PopupMenuItem<String>(
                    value: DeliveryStatus.delayed,
                    child: Text(DeliveryStatus.delayed)
                ),
                const PopupMenuItem<String>(
                    value: DeliveryStatus.delivering,
                    child: Text(DeliveryStatus.delivering)
                ),
                const PopupMenuItem<String>(
                    value: DeliveryStatus.delivered,
                    child: Text(DeliveryStatus.delivered)
                ),
              ];
            }
        ):
        null,
        onTap: (){
          if(inventory != null){
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context)=>ViewDeliveryScreen(inventory: inventory, delivery: delivery,)
            );
          }
        },
      ));
    }
    return items;
  }
}
