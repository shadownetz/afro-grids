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
                          child: reviewsTabView(context)
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


  Widget reviewsTabView(BuildContext context){
    List<ReviewModel> reviews = [
      ReviewModel(id: "", createdBy: "", createdFor: "", createdAt: DateTime.now(), rating: 3, message: "The most comfortable shirts i have worn in the past couple of years. These have really surpassed my expectations, they look amazing and have comfort."),
      ReviewModel(id: "", createdBy: "", createdFor: "", createdAt: DateTime.now(), rating: 1, message: "The most comfortable shirts i have worn in the past couple of years. These have really surpassed my expectations, they look amazing and have comfort."),
      ReviewModel(id: "", createdBy: "", createdFor: "", createdAt: DateTime.now(), rating: 5, message: "The most comfortable shirts i have worn in the past couple of years. These have really surpassed my expectations, they look amazing and have comfort."),
      ReviewModel(id: "", createdBy: "", createdFor: "", createdAt: DateTime.now(), rating: 2, message: "The most comfortable shirts i have worn in the past couple of years. These have really surpassed my expectations, they look amazing and have comfort.")

    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: reviews.map((review){
        return Container(
          margin: EdgeInsets.only(bottom: 20, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              roundImage(image: AssetImage('assets/avatars/woman.png'), width: 40, height: 40),
              SizedBox(width: 10,),
              Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Royal Rox", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                          Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: getRatingIcons(review.rating.toInt(), iconSize: 15),
                              )
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text("The most comfortable shirts i have worn in the past couple of years. These have really surpassed my expectations, they look amazing and have comfort."),

                    ],
                  )
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
