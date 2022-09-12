import 'dart:math';

import 'package:afro_grids/models/user/provider_membership_model.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:afro_grids/utilities/type_extensions.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../models/user/user_model.dart';
import '../../utilities/alerts.dart';
import '../../utilities/colours.dart';
import '../../utilities/navigation_guards.dart';
import '../../utilities/widgets/widgets.dart';
import '../user/cart_blank_screen.dart';

class ProviderMembershipInfoScreen extends StatefulWidget{
  final UserModel user;

  const ProviderMembershipInfoScreen({Key? key, required this.user}): super(key: key);

  @override
  State<ProviderMembershipInfoScreen> createState() => _ProviderMembershipInfoScreenState();

}

class _ProviderMembershipInfoScreenState extends State<ProviderMembershipInfoScreen> {
  final CarouselController _carouselCtrller= CarouselController();
  final monthlyAMT = 14.99;
  final yearlyAMT = 143.88;
  double selectedAMT = 0;

  @override
  void initState() {
    selectedAMT = monthlyAMT;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: Colours.tertiary,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white,),
        title: const AppBarLogo(theme: "light",),
      ),
      body: CustomLoadingOverlay(
        widget: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state){
            if(state is AuthLoadingState){
              context.loaderOverlay.show();
            }else{
              context.loaderOverlay.hide();
            }
            if(state is UnAuthenticatedState){
              NavigationService.pushNamedAndRemoveAll("/signin", state.message);
            }
            if(state is AuthenticatedState){
              NavigationGuards(user: state.user!).navigateToDashboard();
              Alerts(context).showToast("Logged in");
            }
          },
          builder: (context, state){
            return Container(
              height: deviceHeight,
              padding: const EdgeInsets.only(top: 100, left: 10, right: 10),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/grid-abstract.jpg"),
                      fit: BoxFit.cover
                  )
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        "Become part of the GRID",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 50,),
                    SizedBox(
                      height: 200,
                      child: buildInfo(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: ()=>setState(()=>selectedAMT=monthlyAMT),
                          child: Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colours.primary,
                                border: selectedAMT==monthlyAMT?  Border.all(color: Colours.secondary): null
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text("Monthly",style: TextStyle(color: Colors.white),),
                                Text("\$$monthlyAMT /month",style: TextStyle(color: Colors.white),),
                                Text("Recurring payment of \$$monthlyAMT", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),)
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: ()=>setState(()=>selectedAMT=yearlyAMT),
                          child: Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colours.primary,
                                border: selectedAMT==yearlyAMT?  Border.all(color: Colours.secondary): null
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text("Yearly",style: TextStyle(color: Colors.white),),
                                Text("\$${yearlyAMT/12} /month",style: TextStyle(color: Colors.white),),
                                Text("Recurring payment \$$yearlyAMT", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 50,),
                    ElevatedButton(
                        style: buttonSmStyle(),
                        onPressed: ()async{
                          DateTime today = await DateTime.now().networkTimestamp();
                          DateTime expiration;
                          if(selectedAMT == monthlyAMT){
                            expiration = DateTime(today.year, today.month+1, today.day);
                          }else{
                            expiration = DateTime(today.year+1, today.month, today.day);
                          }
                          var subscription = UserSubscriptionModel(
                              id: "",
                              context: SubscriptionContext.membership,
                              amount: selectedAMT,
                              paymentResponse: null,
                              status: SubscriptionStatus.pending,
                              currency: "USD",
                              createdAt: DateTime.now(),
                              createdBy: widget.user.id,
                              expireAt: expiration
                          );
                          NavigationService.toPage(
                              BlankScreen(
                                run: ()=>BlocProvider
                                    .of<AuthBloc>(context)
                                    .add(SubscribeMemberEvent(user: widget.user, subscription: subscription)),
                              )
                          );
                        },
                        child: const Text("Join")
                    ),
                    const SizedBox(height: 30,),
                    Text("You will be billed \$$selectedAMT", style: const TextStyle(color: Colors.white, fontSize: 18),),
                    const SizedBox(height: 10,),
                    const Text("*you can cancel anytime",
                      style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 10,),
                    const Text(
                      "After completing this process, it takes not less than 24 hours for your account to be activated.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildInfo(){
    final infoTexts = [
      "Highly regulated customer base",
      "You put yourself and your services globally",
      "Instant payouts on request"
    ];
    return CarouselSlider(
      carouselController: _carouselCtrller,
      items: infoTexts.map((text){
        return Text(
          text,
          style: const TextStyle(
              fontSize: 25,
              color: Colors.white
          ),
        );
      }).toList(),
      options: CarouselOptions(
          autoPlay: true,
          height: double.infinity,
          viewportFraction: 1,
          autoPlayInterval: const Duration(seconds: 2)
      ),
    );
  }
}
