import 'dart:ui';

import 'package:afro_grids/blocs/inventory/inventory_bloc.dart';
import 'package:afro_grids/screens/provider/account/update_multiple_service_inventory_screen.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/currency.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../blocs/inventory/inventory_event.dart';
import '../../../blocs/inventory/inventory_state.dart';
import '../../../models/inventory_model.dart';
import '../../../utilities/colours.dart';
import '../../../utilities/services/navigation_service.dart';
import '../../../utilities/widgets/button_widget.dart';
import '../../../utilities/widgets/widgets.dart';

class ViewMultipleServiceInventoryScreen extends StatefulWidget {
  final InventoryModel inventory;

  const ViewMultipleServiceInventoryScreen({Key? key, required this.inventory}) : super(key: key);

  @override
  State<ViewMultipleServiceInventoryScreen> createState() => _ViewMultipleServiceInventoryScreenState();
}

class _ViewMultipleServiceInventoryScreenState extends State<ViewMultipleServiceInventoryScreen> {
  var currentScreenIndex = 0;
  InventoryBloc? inventoryProvider;
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: CustomLoadingOverlay(
        widget: BlocProvider(
          create: (context)=>InventoryBloc(),
          child: BlocConsumer<InventoryBloc, InventoryState>(
            listener: (context, state){
              if(state is InventoryLoadingState){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
              if(state is InventoryErrorState){
                Alerts(context).showErrorDialog(title: "Something happened", message: state.message);
              }
              if(state is InventoryUpdatedState){
                Alerts(context).showToast("Item deleted successfully");
                NavigationService.exitPage(true);
              }
            },
            builder: (context, state){
              inventoryProvider = BlocProvider.of<InventoryBloc>(context);
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom
                ),
                child: Container(
                  // alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.only(bottom: 20),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                            boxShadow: [boxShadow2()]
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 500,
                              child: Stack(
                                children: [
                                  // indicator
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: modalDragIndicator(),
                                  ),
                                  // carousel items
                                  Container(
                                    padding: EdgeInsets.only(top: 30),
                                    child: CarouselSlider(
                                      carouselController: carouselController,
                                      items: itemsView(),
                                      options: CarouselOptions(
                                          autoPlay: true,
                                          height: double.infinity,
                                          viewportFraction: 1,
                                          enableInfiniteScroll: false,
                                          onPageChanged: (pageNo, reason){
                                            setState((){
                                              currentScreenIndex = pageNo;
                                            });
                                          }
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            // carousel indicators
                            Container(
                              width: 100,
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                children: widget.inventory.images.map((image){
                                  final isActive = (widget.inventory.images.indexOf(image)==currentScreenIndex);
                                  if(widget.inventory.images.length != 1){
                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.fastOutSlowIn,
                                      margin: EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: isActive ? Colours.secondary: Colours.primary
                                      ),
                                      width: isActive? 30: 10,
                                      height: 10,
                                    );
                                  }
                                  return Container();
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.inventory.name, style: TextStyle(fontSize: 30),),
                            Text('# ${widget.inventory.description}', style: TextStyle(fontSize: 20, color: Colors.grey),),
                            SizedBox(height: 10,),
                            Text('${CurrencyUtil().currencySymbol(widget.inventory.currency)}${widget.inventory.price}', style: TextStyle(fontSize: 25, color: Colours.secondary),)
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                var result = await NavigationService.toPage(UpdateMultipleServiceInventoryScreen(inventory: widget.inventory));
                                return NavigationService.exitPage(result);
                              },
                              style: buttonSmStyle(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.mode_edit_outlined),
                                  Text("Update")
                                ],
                              )
                          ),
                          ElevatedButton(
                              onPressed: ()async{
                                final decision = await Alerts(context)
                                    .showConfirmDialog(
                                    title: "Critical operation",
                                    message: "You are attempting to delete this item from your inventory. Note that this action is not reversible"
                                );
                                if(decision == true){
                                  inventoryProvider!.add(DisableInventoryEvent(inventory: widget.inventory));
                                }
                              },
                              style: buttonPrimarySmStyle(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.delete),
                                  Text("Remove")
                                ],
                              )
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> itemsView(){
    if(widget.inventory.images.isNotEmpty){
      return widget.inventory.images.map((image){
        return Container(
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.contain
            ),
          ),
        );
      }).toList();
    }
    return [Container(
      alignment: Alignment.center,
      child: Text("No items available to display", textAlign: TextAlign.center,),
    )];
  }
}
