import 'dart:ui';

import 'package:afro_grids/blocs/review/review_bloc.dart';
import 'package:afro_grids/blocs/review/review_event.dart';
import 'package:afro_grids/blocs/service/service_bloc.dart';
import 'package:afro_grids/blocs/service/service_event.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/models/review_model.dart';
import 'package:afro_grids/models/service_model.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../blocs/review/review_state.dart';
import '../../blocs/service/service_state.dart';
import '../../utilities/widgets/button_widget.dart';
import '../../utilities/widgets/widgets.dart';

class LeaveAReviewScreen extends StatefulWidget {
  final UserModel user;
  const LeaveAReviewScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<LeaveAReviewScreen> createState() => _LeaveAReviewScreenState();
}

class _LeaveAReviewScreenState extends State<LeaveAReviewScreen> {
  int ratingValue = 1;
  var reviewController = TextEditingController();
  ServiceModel? _service;

  @override
  Widget build(BuildContext context) {
    return CustomLoadingOverlay(
        widget: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context)=>ServiceBloc()..add(GetServiceEvent(widget.user.serviceId))),
            BlocProvider(create: (context)=>ReviewBloc())
          ],
          child: BlocListener<ServiceBloc, ServiceState>(
            listener: (context, state){
              if(state is ServiceLoadedState){
                setState(()=>_service=state.service);
              }
            },
            child: BlocConsumer<ReviewBloc, ReviewState>(
              listener: (context, state){
                if(state is ReviewLoadingState){
                  context.loaderOverlay.show();
                }else{
                  context.loaderOverlay.hide();
                }
                if(state is ReviewErrorState){
                  Alerts(context).showErrorDialog(title: "Unable to post review", message: state.message);
                }
                if(state is ReviewLoadedState){
                  Alerts(context).showToast("Review posted");
                  NavigationService.exitPage(true);
                }
              },
              builder: (context, state){
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom
                    ),
                    child: Container(
                      // alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // provider avatar
                              RoundImage(
                                image: (widget.user.avatar.isEmpty ?  const AssetImage('assets/avatars/man.png'): NetworkImage(widget.user.avatar)) as ImageProvider,
                                hasShadow: true,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 15,),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.user.name, style: const TextStyle(fontSize: 25),),
                                  Text(_service!=null? _service!.name: widget.user.accessLevel.toLowerCase(), style: const TextStyle(color: Colors.grey),)
                                ],
                              ))
                            ],
                          ),
                          SizedBox(height: 10,),
                          getStarRatings(),
                          SizedBox(height: 20,),
                          TextField(
                            controller: reviewController,
                            maxLength: 250,
                            maxLines: 10,
                            cursorHeight: 20,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              hintText: "Your review",
                              filled: true,
                              fillColor: Color.fromRGBO(240, 240, 240, 1),
                              border: InputBorder.none,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          ElevatedButton(
                              onPressed: (){
                                if(reviewController.text.isNotEmpty && reviewController.text.length > 3){
                                  var review = ReviewModel(
                                      id: '',
                                      createdBy: localStorage.user!.id,
                                      createdFor: widget.user.id,
                                      createdAt: DateTime.now(),
                                      message: reviewController.text,
                                      rating: ratingValue
                                  );
                                  BlocProvider
                                      .of<ReviewBloc>(context)
                                      .add(AddReviewEvent(review));
                                }else{
                                  Alerts(context).showToast("Your review is too short");
                                }

                              },
                              style: buttonPrimaryLgStyle(),
                              child: Text("Done")
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        )
    );
  }

  Widget getStarRatings(){
    List<Widget> ratingIcons = [];
    for(int i=0; i<ratingValue; i++){
      ratingIcons.add(IconButton(
          alignment: Alignment.centerLeft,
          onPressed: ()=>setState(()=>ratingValue=i+1),
          icon: const Icon(
            Icons.star, size: 30,color: Colours.secondary,
          )
      ));
    }
    for(int i=ratingIcons.length; i<5; i++){
      ratingIcons.add(IconButton(
          alignment: Alignment.centerLeft,
          onPressed: ()=>setState(()=>ratingValue=i+1),
          icon: const Icon(
            Icons.star_border, size: 30,color: Colours.secondary,
          )
      ));
    }
    return Row(
      children: ratingIcons,
    );
  }
}
