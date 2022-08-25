import 'package:afro_grids/models/inventory_model.dart';
import 'package:afro_grids/models/local/local_review_model.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:afro_grids/screens/user/cart_screen.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../models/review_model.dart';
import '../colours.dart';
import '../currency.dart';
import 'widget_models.dart';
import 'widgets.dart';

AppBar portfolioAppBar(BuildContext context){
  return AppBar(
    // backgroundColor: Colours.tertiary,
    // foregroundColor: Colours.primary,
    title: const Text("Provider Portfolio"),
    actions: const [
      CartButton()
    ],
  );
}

Widget portfolioActionBar(BuildContext context, {required UserModel provider}){
  final deviceWidth = MediaQuery.of(context).size.width;
  return Container(
    width: deviceWidth-20,
    // margin: const EdgeInsets.all(10),
    height: 150,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [boxShadow2()]
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // provider avatar
        SizedBox(
          width: 150,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: (provider.avatar.isEmpty ? const AssetImage('assets/avatars/man.png'):NetworkImage(provider.avatar)) as ImageProvider,
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                      )
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: HalfWhiteOverlay(),
              )
            ],
          ),
        ),
        Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(provider.name, style: const TextStyle(fontSize: 27, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w500),),
                  Row(
                    children: [
                      // star rating and favorites
                      Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Chip(
                                avatar: Icon(Icons.stars, color: Colors.white, size: 15,),
                                label: Text("3.5", style: TextStyle(fontSize: 15),),
                                backgroundColor: Colors.lightGreen,
                              ),
                              Chip(
                                avatar: Icon(Icons.bookmarks,size: 15, color: Colours.primary,),
                                label: Text("Favorite", style: TextStyle(fontSize: 15, color: Colours.primary),),
                                backgroundColor: Colours.tertiary,
                                elevation: 2,
                              ),
                            ],
                          )
                      ),
                      SizedBox(width: 20,),
                      // chat and report
                      Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Chip(
                                avatar: Icon(Ionicons.chatbubbles_outline, color: Colors.white,size: 15,),
                                label: Text("Chat", style: TextStyle(fontSize: 15, color: Colors.white),),
                                backgroundColor: Colours.secondary,
                                elevation: 2,
                              ),
                              Chip(
                                avatar: Icon(Icons.error, color: Colors.white,size: 15,),
                                label: Text("Report", style: TextStyle(fontSize: 15, color: Colors.white),),
                                backgroundColor: Colors.redAccent,
                                elevation: 2,
                              ),
                            ],
                          )
                      )
                    ],
                  )
                ],
              ),
            )
        )
      ],
    ),
  );
}

Widget portfolioActionBar2(BuildContext context, {required UserModel provider}){
  final deviceWidth = MediaQuery.of(context).size.width;
  return Container(
    width: deviceWidth-20,
    // margin: const EdgeInsets.all(10),
    height: 150,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [boxShadow2()]
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // star rating and favorites
        Container(
          padding: const EdgeInsets.only(left: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Chip(
                avatar: Icon(Icons.stars, color: Colors.white, size: 15,),
                label: Text("3.5", style: TextStyle(fontSize: 15),),
                backgroundColor: Colors.lightGreen,
              ),
              Chip(
                avatar: Icon(Icons.bookmarks,size: 15, color: Colors.white,),
                label: Text("Favorited", style: TextStyle(fontSize: 15, color: Colors.white),),
                backgroundColor: Colours.primary,
                elevation: 2,
              ),
            ],
          ),
        ),
        // provider avatar
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: (provider.avatar.isEmpty ? const AssetImage('assets/avatars/man.png'):NetworkImage(provider.avatar)) as ImageProvider,
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: HalfWhiteOverlay(),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(provider.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),),
                      )
                  )
                ],
              ),
            ),
          ],
        ),
        // chat and report
        Container(
          padding: const EdgeInsets.only(right: 5),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Chip(
                avatar: Icon(Ionicons.chatbubbles_outline, color: Colors.white,size: 15,),
                label: Text("Chat", style: TextStyle(fontSize: 15, color: Colors.white),),
                backgroundColor: Colours.secondary,
                elevation: 2,
              ),
              Chip(
                avatar: Icon(Icons.error, color: Colors.white,size: 15,),
                label: Text("Report", style: TextStyle(fontSize: 15, color: Colors.white),),
                backgroundColor: Colors.redAccent,
                elevation: 2,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


class PortfolioReviewsTabView extends StatefulWidget {
  final List<LocalReviewModel> reviews;

  const PortfolioReviewsTabView({Key? key, required this.reviews}) : super(key: key);

  @override
  State<PortfolioReviewsTabView> createState() => _PortfolioReviewsTabViewState();
}

class _PortfolioReviewsTabViewState extends State<PortfolioReviewsTabView> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.reviews.map((localReview){
        return Container(
          margin: EdgeInsets.only(bottom: 20, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundImage(
                image: (localReview.creatorAvatar!=null?NetworkImage(localReview.creatorAvatar!): const AssetImage('assets/avatars/woman.png')) as ImageProvider,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10,),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            localReview.creatorName??localReview.review.createdBy,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: RatingIcons(localReview.review.rating.toInt(), iconSize: 15),
                              )
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text(localReview.review.message)

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

class InventoryView extends StatefulWidget {
  final List<InventoryModel> items;
  final void Function(InventoryModel inventory)? onClick;
  const InventoryView({Key? key, required this.items, this.onClick}) : super(key: key);

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          // alignment: WrapAlignment.center,
          children: widget.items.map((item){
            return GestureDetector(
              onTap: (){
                if(widget.onClick != null){
                  widget.onClick!(item);
                }
              },
              child: Container(
                width: 180,
                height: 170,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: (item.images.isNotEmpty?
                              NetworkImage(item.images.first):
                              AssetImage("assets/icons/cart.png")) as ImageProvider,
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: HalfWhiteOverlay2(height: 120),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, overflow: TextOverflow.ellipsis),),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: Row(
                              children: [
                                Text(item.description, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, overflow: TextOverflow.ellipsis),),
                                Expanded(
                                    child: Text("${CurrencyUtil().currencySymbol(item.currency)}${item.price}", style: TextStyle(fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis), textAlign: TextAlign.end,)
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        )
    );
  }
}



class ProviderPortfolioTab extends StatefulWidget {
  final List<ProviderPortfolioTabModel> tabs;
  final void Function(String value)? onClick;

  const ProviderPortfolioTab({
    Key? key,
    required this.tabs,
    this.onClick
  }) : super(key: key);

  @override
  State<ProviderPortfolioTab> createState() => _PortfolioTabsState();
}

class _PortfolioTabsState extends State<ProviderPortfolioTab> {
  late String activeTab;

  @override
  void initState() {
    activeTab = widget.tabs.isEmpty?"":widget.tabs.first.label;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color.fromRGBO(200, 200, 200, 1)))
            ),
            child: Row(
                children: widget.tabs.map((tab){
                  return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          setState((){
                            activeTab = tab.label;
                          });

                          if(widget.onClick != null){
                            widget.onClick!(tab.label);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          // highlighted tab section
                          decoration: tab.label==activeTab? const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colours.primary,
                                    width: 3
                                )
                            ),
                          ): null,
                          alignment: Alignment.center,
                          child: tab.labelWidget,
                        ),
                      )
                  );
                }).toList()
            )
        ),
        const SizedBox(height: 10,),
        widget.tabs.isEmpty?
        Container():
        widget.tabs.where((tab) => tab.label==activeTab).first.child,
        const SizedBox(height: 70,),
      ],
    );
  }
}