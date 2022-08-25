import 'dart:ui';

import 'package:afro_grids/models/local/local_order_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../utilities/colours.dart';
import '../../../utilities/widgets/button_widget.dart';
import '../../../utilities/widgets/widgets.dart';

class ViewOrderScreen extends StatefulWidget {
  final LocalOrderModel localOrder;

  const ViewOrderScreen({Key? key, required this.localOrder}) : super(key: key);

  @override
  State<ViewOrderScreen> createState() => _ViewOrderScreenState();
}

class _ViewOrderScreenState extends State<ViewOrderScreen> {
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
                      height: 500,
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
                        children: widget.localOrder.inventory.images.map((image){
                          final isActive = (widget.localOrder.inventory.images.indexOf(image)==currentScreenIndex);
                          if(widget.localOrder.inventory.images.length != 1){
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
                    Text(widget.localOrder.inventory.name, style: TextStyle(fontSize: 20,),),
                    // order
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${widget.localOrder.orderModel.orderNo}', style: TextStyle(fontSize: 15),),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Order',textAlign: TextAlign.left, style: TextStyle(fontSize: 12, color: Colors.grey),),
                    ),
                    const SizedBox(height: 10,),
                    // price
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${widget.localOrder.inventory.currency}${widget.localOrder.inventory.price}', style: TextStyle(fontSize: 15),),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Price',textAlign: TextAlign.left, style: TextStyle(fontSize: 12, color: Colors.grey),),
                    ),
                    const SizedBox(height: 10,),
                    // quantity
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${widget.localOrder.count}', style: TextStyle(fontSize: 15),),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Quantity',textAlign: TextAlign.left, style: TextStyle(fontSize: 12, color: Colors.grey),),
                    ),
                    const SizedBox(height: 10,),
                    // created
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${widget.localOrder.orderModel.createdAt}', style: TextStyle(fontSize: 15),),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Created',textAlign: TextAlign.left, style: TextStyle(fontSize: 12, color: Colors.grey),),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                    onPressed: ()=>Navigator.of(context).pop(),
                    style: buttonPrimaryLgStyle(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person),
                        Text("View provider")
                      ],
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> itemsView(){
    if(widget.localOrder.inventory.images.isNotEmpty){
      return widget.localOrder.inventory.images.map((image){
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
