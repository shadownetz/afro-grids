import 'package:afro_grids/blocs/ads/ads_bloc.dart';
import 'package:afro_grids/blocs/ads/ads_event.dart';
import 'package:afro_grids/blocs/ads/ads_state.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/forms/models/ads_forms.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../utilities/colours.dart';

class AddAdsScreen extends StatefulWidget {
  const AddAdsScreen({Key? key}) : super(key: key);

  @override
  State<AddAdsScreen> createState() => _AddAdsScreenState();
}

class _AddAdsScreenState extends State<AddAdsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white,),
        title: const Text("New Advert"),
      ),
      body: CustomLoadingOverlay(
        widget: Container(
          padding: const EdgeInsets.all(10),
          child: BlocProvider<AdsBloc>(
            create: (context)=>AdsBloc(),
            child: BlocConsumer<AdsBloc, AdsState>(
              listener: (context, state){
                if(state is AdsLoadingState){
                  context.loaderOverlay.show();
                }else{
                  context.loaderOverlay.hide();
                }
                if(state is AdsLoadedState){
                  Alerts(context).showToast("Operation successful");
                  Navigator.of(context).pop(true);
                }
              },
              builder: (context, state){
                return SingleChildScrollView(
                  child: AddAdsForm(
                      onComplete: (ads, file){
                        BlocProvider.of<AdsBloc>(context).add(AddAdsEvent(ads: ads, file: file));
                      }
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
