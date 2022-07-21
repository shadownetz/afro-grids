import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/widgets/widget_models.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

Widget appBarLogo({
  theme='light'
}){
  return Image(
      width: 130,
      height: 130,
      image: AssetImage(
          theme=='light'?"assets/splash_light.png":"assets/splash.png"
      )
  );
}

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

BoxShadow boxShadow1(){
  return BoxShadow(color: Colors.black26, spreadRadius: 3, blurRadius: 5, offset: Offset.fromDirection(1));
}
BoxShadow boxShadow2(){
  return const BoxShadow(color: Colors.black26, blurRadius: 9, offset: Offset(0.0, 5));
}

Widget cartIcon({int? itemCount}){
  return Stack(
    children: [
      const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              Ionicons.cart,
              size: 30,
            ),
          )
      ),
      itemCount != null ?
      Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.only(top: 5),
          alignment: Alignment.center,
          padding: EdgeInsets.all(2),
          decoration: const BoxDecoration(
              color: Colours.secondary,
              shape: BoxShape.circle
          ),
          child: Text("$itemCount", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12),),
        ),
      ):
      Container(),
    ],
  );
}

class AuthTab extends StatelessWidget {
  final String activeTab;

  const AuthTab({
    Key? key,
    this.activeTab = 'signin'
  }) : super(key: key);

  ButtonStyle tabBtnStyle(String tab){
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
            activeTab == tab?Colours.tertiary: Colors.white
        ),
        minimumSize: MaterialStateProperty.all(const Size(180, 40)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              style: tabBtnStyle('signin'),
              onPressed: ()=>Navigator.of(context).pushReplacementNamed("/signin"),
              child: const Text(
                "Sign in",
              )
          ),
          TextButton(
              style: tabBtnStyle('signup'),
              onPressed: ()=>Navigator.of(context).pushReplacementNamed("/user-signup"),
              child: const Text(
                "Sign up",
              )
          )
        ],
      ),
    );
  }
}

class ProviderWidgets{
  final BuildContext context;
  ProviderWidgets({required this.context});

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

  Widget portfolioActionBar(){
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

  Widget portfolioTabs({
    required List<ProviderPortfolioTabModel> tabs,
    void Function(String value)? onClick
  }){
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color.fromRGBO(200, 200, 200, 1)))
      ),
      child: Row(
          children: tabs.map((tab){
            return Expanded(
              child: GestureDetector(
                onTap: (){
                  if(onClick != null){
                    onClick(tab.label);
                  }
                },
                child: tab.labelWidget,
              ),
            );
          }).toList()
      ),
    );
  }
}

class PortfolioTabs extends StatefulWidget {
  final List<ProviderPortfolioTabModel> tabs;
  final void Function(String value)? onClick;

  const PortfolioTabs({
    Key? key,
    required this.tabs,
    this.onClick
  }) : super(key: key);

  @override
  State<PortfolioTabs> createState() => _PortfolioTabsState();
}

class _PortfolioTabsState extends State<PortfolioTabs> {
  late String activeTab;

  @override
  void initState() {
    activeTab = widget.tabs.first.label;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: widget.tabs.where((tab) => tab.label==activeTab).first.child,
        )
      ],
    );
  }
}

