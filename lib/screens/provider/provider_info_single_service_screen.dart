import 'package:afro_grids/models/review_model.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:afro_grids/utilities/widgets/widget_models.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../utilities/colours.dart';
import '../../utilities/widgets/providerWidgets.dart';


class ProviderInfoSingleServiceScreen extends StatefulWidget {
  const ProviderInfoSingleServiceScreen({Key? key}) : super(key: key);

  @override
  State<ProviderInfoSingleServiceScreen> createState() => _ProviderInfoSingleServiceScreenState();
}

class _ProviderInfoSingleServiceScreenState extends State<ProviderInfoSingleServiceScreen> {
  bool showReviewButton = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: portfolioAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Column(
              children: [
                // provider stats block
                portfolioActionBar(context),
                const SizedBox(height: 30,),
                // Tab section
                ProviderPortfolioTab(
                    tabs: [
                      ProviderPortfolioTabModel(
                          label: "details",
                          labelWidget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info, size: 15,),
                              Text("Details", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                          child: detailsTabView()
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
                        showReviewButton = (value == 'details');
                      });
                      print(value);
                    }
                ),
              ],
            ),
            showReviewButton?
            Align(
              alignment: Alignment.bottomCenter,
              child: leaveAReviewButton(context),
            ):
            Container(height: 0,)
          ],
        ),
      ),
    );
  }

  Widget detailsTabView(){
    return Container(
      padding: const EdgeInsets.only(bottom: 50),
      child:  Column(
        children: const [
          Text("Message from this provider", style: TextStyle(fontSize: 15),),
          SizedBox(height: 20,),
          Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Leo morbi dui tincidunt egestas nunc a. Tincidunt vel id nulla neque nisl. Donec imperdiet at mattis tristique senectus facilisi. In lobortis et egestas odio quis amet, turpis.\n        Egestas congue ut blandit nam in risus massa gravida in. Rutrum ut dolor suscipit quam pellentesque. Integer convallis faucibus id neque turpis ut vivamus nisl. Ac congue morbi quis congue feugiat dictum in. Faucibus egestas in cursus odio mattis volutpat. Tellus ut lorem ut aliquet iaculis commodo.")
        ],
      ),
    );
  }


}
