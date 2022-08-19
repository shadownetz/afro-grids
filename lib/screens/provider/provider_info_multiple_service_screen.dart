import 'package:afro_grids/screens/provider/view_item_screen.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:afro_grids/utilities/widgets/widget_models.dart';
import 'package:flutter/material.dart';

import '../../models/inventory_model.dart';
import '../../models/user_model.dart';
import '../../utilities/class_constants.dart';
import '../../utilities/colours.dart';
import '../../utilities/widgets/provider_widgets.dart';


class ProviderInfoMultipleServiceScreen extends StatefulWidget {
  final UserModel user;
  const ProviderInfoMultipleServiceScreen({
    Key? key,
    required this.user
  }) : super(key: key);

  @override
  State<ProviderInfoMultipleServiceScreen> createState() => _ProviderInfoMultipleServiceScreenState();
}

class _ProviderInfoMultipleServiceScreenState extends State<ProviderInfoMultipleServiceScreen> {
  bool showReviewButton = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: portfolioAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // provider stats block
                  portfolioActionBar2(context),
                  const SizedBox(height: 30,),
                  // Tab section
                  ProviderPortfolioTab(
                      tabs: [
                        ProviderPortfolioTabModel(
                            label: "services",
                            labelWidget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart, size: 15,),
                                Text("Services", style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            ),
                            child: InventoryView(
                              items:  [
                                InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Strawberries", price: 5000, currency: Currency.ngn, description: "Sizes XL&M", images: ["https://picsum.photos/id/1080/200/300","https://picsum.photos/id/119/200/300", "https://picsum.photos/id/133/200/300"], visible: true),
                                InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Apple MacBook", price: 150000, currency: Currency.ngn, description: "Refurbished", images: ["https://picsum.photos/id/119/200/300"], visible: true),
                                InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Cars", price: 250000, currency: Currency.ngn, description: "Working condition", images: ["https://picsum.photos/id/133/200/300"], visible: true),
                                InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Skate Board", price: 3500, currency: Currency.ngn, description: "Antique (the best)", images: ["https://picsum.photos/id/157/200/300"], visible: true),
                                InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Strawberries", price: 5000, currency: Currency.ngn, description: "Sizes XL&M", images: ["https://picsum.photos/id/1080/200/300"], visible: true),
                                InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Apple MacBook", price: 150000, currency: Currency.ngn, description: "Refurbished", images: ["https://picsum.photos/id/119/200/300"], visible: true),
                                InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Cars", price: 250000, currency: Currency.ngn, description: "Working condition", images: ["https://picsum.photos/id/133/200/300"], visible: true),
                                InventoryModel(id: "", createdBy: "", createdAt: DateTime.now(), name: "Skate Board", price: 3500, currency: Currency.ngn, description: "Antique (the best)", images: ["https://picsum.photos/id/157/200/300"], visible: true),
                              ],
                              onClick: (item){
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context)=>ViewItemScreen(inventory: item)
                                );
                              },
                            )
                        ),
                        ProviderPortfolioTabModel(
                            label: "reviews",
                            labelWidget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star_border, size: 15,),
                                Text("Reviews", style: TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                            child: const PortfolioReviewsTabView()
                        )
                      ],
                      onClick: (value){
                        setState((){
                          showReviewButton = (value == 'reviews');
                        });
                        print(value);
                      }
                  ),
                ],
              ),
            ),
            showReviewButton?
            Align(
              alignment: Alignment.bottomCenter,
              child: leaveAReviewButton(context),
            ):
            Align(
              alignment: Alignment.bottomCenter,
              child: checkoutButton(context),
            )
          ],
        ),
      ),
    );
  }


}
