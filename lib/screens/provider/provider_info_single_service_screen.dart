import 'package:afro_grids/blocs/inventory/inventory_bloc.dart';
import 'package:afro_grids/models/inventory_model.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:afro_grids/utilities/widgets/widget_models.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../blocs/inventory/inventory_event.dart';
import '../../blocs/inventory/inventory_state.dart';
import '../../utilities/alerts.dart';
import '../../utilities/colours.dart';
import '../../utilities/widgets/provider_widgets.dart';


class ProviderInfoSingleServiceScreen extends StatefulWidget {
  final UserModel user;
  const ProviderInfoSingleServiceScreen({
    Key? key,
    required this.user
  }) : super(key: key);

  @override
  State<ProviderInfoSingleServiceScreen> createState() => _ProviderInfoSingleServiceScreenState();
}

class _ProviderInfoSingleServiceScreenState extends State<ProviderInfoSingleServiceScreen> {
  bool showReviewButton = true;
  InventoryModel? _inventory;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: portfolioAppBar(context),
      body: CustomLoadingOverlay(
        widget: BlocProvider(
          create: (context)=>InventoryBloc()..add(FetchProviderInventories(widget.user)),
          child: BlocConsumer<InventoryBloc, InventoryState>(
            listener: (context, state){
              if(state is InventoryLoadingState){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
              if(state is InventoryLoadedState){
                if(state.inventories.isNotEmpty){
                  setState(()=>_inventory = state.inventories.first);
                }
              }
              if(state is InventoryErrorState){
                Alerts(context).showToast(state.message);
              }
            },
            builder: (context, state){
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // provider stats block
                        portfolioActionBar(context, provider: widget.user),
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
                                  child: const PortfolioReviewsTabView(reviews: [],)
                              )
                            ],
                            onClick: (value){
                              setState((){
                                showReviewButton = (value == 'details');
                              });
                            }
                        ),
                      ],
                    ),
                    showReviewButton?
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: leaveAReviewButton(context,provider: UserModel.providerInstance()),
                    ):
                    Container(height: 0,)
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget detailsTabView(){
    if(_inventory != null){
      return Container(
        padding: const EdgeInsets.only(bottom: 50),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text("Message from this provider", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),),
            const SizedBox(height: 20,),
            Text(_inventory!.description, style: TextStyle(fontSize: 20),)
          ],
        ),
      );
    }
    return Container(
      alignment: Alignment.center,
      child: const Text("This provider has no message available for now"),
    );

  }


}
