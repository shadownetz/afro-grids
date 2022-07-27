import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:afro_grids/utilities/widgets/widget_models.dart';
import 'package:flutter/material.dart';

import '../../utilities/colours.dart';
import '../../utilities/widgets/providerWidgets.dart';


class ProviderInfoMultipleServiceScreen extends StatefulWidget {
  const ProviderInfoMultipleServiceScreen({Key? key}) : super(key: key);

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
                            child: const InventoryView()
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
