import 'package:afro_grids/blocs/ads/ads_bloc.dart';
import 'package:afro_grids/blocs/ads/ads_event.dart';
import 'package:afro_grids/blocs/ads/ads_state.dart';
import 'package:afro_grids/screens/admin/ads/add_ads_screen.dart';
import 'package:afro_grids/screens/preview_media_screen.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:afro_grids/utilities/type_extensions.dart';
import 'package:afro_grids/utilities/widgets/button_widget.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../models/ads_model.dart';
import '../../../utilities/colours.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({Key? key}) : super(key: key);

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  AdsBloc? _adsBloc;
  List<AdsModel> _adsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white,),
        title: const Text("Ads"),
      ),
      body: CustomLoadingOverlay(
        widget: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context)=>AdsBloc()..add(FetchAdsEvent()))
          ],
          child: BlocConsumer<AdsBloc, AdsState>(
            listener: (context, state){
              if(state is AdsLoadingState){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
              if(state is AdsLoadedState){
                if(state.adsList != null){
                  if(state.adsList!.isNotEmpty){
                    setState(()=>_adsList = state.adsList!);
                  }
                }
              }
              if(state is AdsUpdatedState){
                _adsBloc!.add(FetchAdsEvent());
                Alerts(context).showToast("Done");
              }
            },
            builder: (context, state){
              _adsBloc = BlocProvider.of<AdsBloc>(context);
              if(_adsList.isNotEmpty){
                return ListView(
                  children: _adsList.map((ads){
                    return ListTile(
                      leading: const Icon(Ionicons.videocam),
                      title: Text(ads.name),
                      isThreeLine: true,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('vendor: ${ads.vendorName}'),
                          Text('created: ${ads.createdAt.toDateTimeStr()}'),
                          Text('end: ${ads.expireAt.toDateTimeStr()}')
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent,),
                        onPressed: ()async{
                          bool? decision = await Alerts(context)
                              .showConfirmDialog(
                              title: "Critical operation",
                              message: "This advert can not be recovered once deleted. Continue with this operation?"
                          );
                          if(decision == true){
                            _adsBloc!.add(RemoveAdsEvent(ads: ads));
                          }
                        },
                      ),
                      onTap: (){
                        NavigationService.toPage(PreviewMediaScreen(files: [ads.fileURL]));
                      },
                    );
                  }).toList(),
                );
              }
              return Container(
                alignment: Alignment.center,
                child: const Text("You have not uploaded any ads"),
              );
            },
          ),
        ),
      ),
      floatingActionButton: RoundSMButton(
        onPressed: ()async{
          bool? result = await NavigationService.toPage(const AddAdsScreen());
          if(result == true){
            _adsBloc!.add(FetchAdsEvent());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
