import 'package:afro_grids/blocs/inventory/inventory_bloc.dart';
import 'package:afro_grids/blocs/inventory/inventory_event.dart';
import 'package:afro_grids/blocs/inventory/inventory_state.dart';
import 'package:afro_grids/screens/provider/view_item_screen.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:afro_grids/utilities/widgets/widget_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../models/inventory_model.dart';
import '../../models/user_model.dart';
import '../../utilities/class_constants.dart';
import '../../utilities/colours.dart';
import '../../utilities/widgets/provider_widgets.dart';
import '../../utilities/widgets/widgets.dart';


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
  List<InventoryModel>? _inventories;

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
                  setState(()=>_inventories = state.inventories);
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
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            // provider stats block
                            portfolioActionBar2(context, provider: widget.user),
                            const SizedBox(height: 30,),
                            // Tab section
                            ProviderPortfolioTab(
                                tabs: [
                                  ProviderPortfolioTabModel(
                                      label: "services",
                                      labelWidget: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.shopping_cart, size: 15,),
                                          Text("Services", style: TextStyle(fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                      child: buildServices()
                                  ),
                                  ProviderPortfolioTabModel(
                                      label: "reviews",
                                      labelWidget: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
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
                );
              },
            ),
          )
      ),
    );
  }

  Widget buildServices(){
    if(_inventories != null){
      if(_inventories!.isNotEmpty){
        return InventoryView(
          items: _inventories!,
          onClick: (item){
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context)=>ViewItemScreen(inventory: item)
            );
          },
        );
      }
    }
    return Container(
      alignment: Alignment.center,
      child: const Text("This provider has no item(s) available for now"),
    );
  }


}
