import 'dart:ui';

import 'package:afro_grids/blocs/user/user_bloc.dart';
import 'package:afro_grids/blocs/user/user_event.dart';
import 'package:afro_grids/models/inventory_model.dart';
import 'package:afro_grids/models/local/local_delivery_model.dart';
import 'package:afro_grids/models/local/local_order_model.dart';
import 'package:afro_grids/screens/user/leave_a_review_screen.dart';
import 'package:afro_grids/utilities/navigation_guards.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:afro_grids/utilities/type_extensions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../../blocs/user/user_state.dart';
import '../../../utilities/colours.dart';
import '../../../utilities/widgets/button_widget.dart';
import '../../../utilities/widgets/widgets.dart';

class ViewDeliveryScreen extends StatefulWidget {
  final InventoryModel inventory;
  final LocalDeliveryModel delivery;
  const ViewDeliveryScreen({Key? key, required this.inventory, required this.delivery}) : super(key: key);

  @override
  State<ViewDeliveryScreen> createState() => _ViewDeliveryScreenState();
}

class _ViewDeliveryScreenState extends State<ViewDeliveryScreen> {
  var currentScreenIndex = 0;
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        child: Container(
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
                      height: 400,
                      child: Stack(
                        children: [
                          // indicator
                          Align(
                            alignment: Alignment.topCenter,
                            child: ModalDragIndicator(),
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
                width: deviceWidth,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.inventory.name, style: const TextStyle(fontSize: 20,),),
                    const SizedBox(height: 10,),
                    Text(widget.delivery.deliveryModel.status, style: const TextStyle(fontSize: 15, color: Colours.secondary,),),
                    const SizedBox(height: 10,),
                    // price
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${widget.inventory.currency.currencySymbol()}${widget.inventory.price*widget.delivery.deliveryModel.deliveryCount}', style: const TextStyle(fontSize: 15),),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Total price',textAlign: TextAlign.left, style: TextStyle(fontSize: 12, color: Colors.grey),),
                    ),
                    const SizedBox(height: 10,),
                    // quantity
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${widget.delivery.deliveryModel.deliveryCount}', style: const TextStyle(fontSize: 15),),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Quantity',textAlign: TextAlign.left, style: TextStyle(fontSize: 12, color: Colors.grey),),
                    ),
                    const SizedBox(height: 10,),
                    // created
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.delivery.deliveryModel.createdAt.toDateTimeStr(), style: const TextStyle(fontSize: 15),),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Created',textAlign: TextAlign.left, style: TextStyle(fontSize: 12, color: Colors.grey),),
                    ),
                    const SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.delivery.deliveryModel.contactName, style: const TextStyle(fontSize: 15),),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Contact name',textAlign: TextAlign.left, style: TextStyle(fontSize: 12, color: Colors.grey),),
                    ),
                    const SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.delivery.deliveryModel.contactPhone, style: const TextStyle(fontSize: 15),),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Contact phone',textAlign: TextAlign.left, style: TextStyle(fontSize: 12, color: Colors.grey),),
                    ),
                    const SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.delivery.deliveryModel.contactAddress, style: const TextStyle(fontSize: 15),),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Delivery address',textAlign: TextAlign.left, style: TextStyle(fontSize: 12, color: Colors.grey),),
                    ),
                  ],
                ),
              ),
            ],
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
      child: const Text("No items available to display", textAlign: TextAlign.center,),
    )];
  }
}
