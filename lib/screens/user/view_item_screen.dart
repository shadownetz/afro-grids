import 'dart:ui';

import 'package:afro_grids/models/inventory_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../utilities/colours.dart';
import '../../utilities/widgets/button_widget.dart';
import '../../utilities/widgets/widgets.dart';

class ViewItemScreen extends StatefulWidget {
  final InventoryModel inventory;
  const ViewItemScreen({Key? key, required this.inventory}) : super(key: key);

  @override
  State<ViewItemScreen> createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {
  var currentScreenIndex = 0;
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: SingleChildScrollView(
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
                    Text('${widget.inventory.currency}${widget.inventory.price}', style: TextStyle(fontSize: 25, color: Colours.secondary),)
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                    onPressed: ()=>Navigator.of(context).pop(),
                    style: buttonLgStyle(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_shopping_cart_outlined),
                        Text("Add to cart")
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
    return [const SizedBox(
      height: 100,
      child: Text("No items available to display", textAlign: TextAlign.center,),
    )];
  }

}
