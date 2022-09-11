import 'package:afro_grids/blocs/inventory/inventory_bloc.dart';
import 'package:afro_grids/models/inventory_model.dart';
import 'package:afro_grids/models/user/user_model.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:afro_grids/utilities/widgets/widget_models.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../blocs/inventory/inventory_event.dart';
import '../../blocs/inventory/inventory_state.dart';
import '../../blocs/review/review_bloc.dart';
import '../../blocs/review/review_event.dart';
import '../../blocs/review/review_state.dart';
import '../../models/local/local_review_model.dart';
import '../../utilities/alerts.dart';
import '../../utilities/colours.dart';
import '../../utilities/widgets/provider_widgets.dart';
import '../user/leave_a_review_screen.dart';


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
  bool showReviewButton = false;
  InventoryModel? _inventory;
  List<LocalReviewModel>? _reviews;
  ReviewBloc? _reviewProvider;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: portfolioAppBar(context),
      body: CustomLoadingOverlay(
        widget: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context)=>InventoryBloc()..add(FetchProviderInventories(widget.user))
            ),
            BlocProvider<ReviewBloc>(create: (context)=>ReviewBloc())
          ],
          child: BlocListener<InventoryBloc, InventoryState>(
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
            child: BlocListener<ReviewBloc,ReviewState>(
              listener: (context, state){
                if(state is ReviewLoadingState){
                  context.loaderOverlay.show();
                }else{
                  context.loaderOverlay.hide();
                }
                if(state is ReviewLoadedState){
                  setState(()=>_reviews = state.reviews);
                }
                if(state is ReviewErrorState){
                  Alerts(context).showToast(state.message);
                }
              },
              child: Builder(
                builder: (context){
                  _reviewProvider = BlocProvider.of<ReviewBloc>(context);
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
                                        children: const [
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
                                        children: const [
                                          Icon(Icons.star_border, size: 15,),
                                          Text("Reviews", style: TextStyle(fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                      child: buildReviews()
                                  )
                                ],
                                onClick: (value){
                                  bool isReviews = value == 'reviews';
                                  setState((){
                                    showReviewButton = isReviews;
                                  });
                                  if(isReviews && _reviews==null){
                                    _reviewProvider!.add(FetchReviewsEvent(widget.user, withMetaInfo: true));
                                  }
                                }
                            ),
                          ],
                        ),
                        showReviewButton?
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                              style: buttonPrimaryLgStyle(),
                              onPressed: ()async{
                                var result = await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context)=>LeaveAReviewScreen(user: widget.user,)
                                );
                                if(result == true){
                                  _reviewProvider!.add(FetchReviewsEvent(widget.user, withMetaInfo: true));
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.star_border, size: 20,),
                                  Text("Leave a review")
                                ],
                              )
                          ),
                        ):
                        Container(height: 0,)
                      ],
                    ),
                  );
                },
              ),
            ),
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

  Widget buildReviews(){
    if(_reviews != null){
      if(_reviews!.isNotEmpty){
        return PortfolioReviewsTabView(reviews: _reviews!,);
      }
    }
    return Container(
      alignment: Alignment.center,
      child: const Text("There are no reviews at this time"),
    );
  }


}
