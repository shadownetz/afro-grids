import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../colours.dart';
import 'widget_models.dart';
import 'widgets.dart';

AppBar portfolioAppBar(){
  return AppBar(
    backgroundColor: Colours.tertiary,
    foregroundColor: Colours.primary,
    title: const Text("Provider Portfolio"),
    actions: [
      IconButton(
          padding: const EdgeInsets.all(0),
          onPressed: ()=>{},
          icon: cartIcon(itemCount: 30)
      )
    ],
  );
}

Widget portfolioActionBar(BuildContext context){
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
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/avatars/man.png'),
                        alignment: Alignment.bottomCenter,
                        fit: BoxFit.contain,
                      )
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0),
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.9),
                          Colors.white,
                        ],
                      )
                  ),
                ),
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
                  const Text("George Rufus", style: TextStyle(fontSize: 30, overflow: TextOverflow.ellipsis),),
                  Row(
                    children: [
                      // star rating and favorites
                      Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.stars, color: Colours.secondary, size: 20,),
                                  Text("3.5", style: TextStyle(fontSize: 20),)
                                ],
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                children: const [
                                  Icon(Icons.bookmarks_outlined,size: 20,),
                                  Text("Favorite", style: TextStyle(fontSize: 20),)
                                ],
                              )
                            ],
                          )
                      ),
                      SizedBox(width: 20,),
                      // chat and report
                      Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Icon(Ionicons.chatbubbles_outline, color: Colors.green,size: 20,),
                                  Text("Chat", style: TextStyle(fontSize: 20),)
                                ],
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                children: const [
                                  Icon(Icons.error, color: Colors.redAccent,size: 20,),
                                  Text("Report", style: TextStyle(fontSize: 20),)
                                ],
                              )
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
        SingleChildScrollView(
          child: widget.tabs.isEmpty?
          Container():
          widget.tabs.where((tab) => tab.label==activeTab).first.child,
        )
      ],
    );
  }
}