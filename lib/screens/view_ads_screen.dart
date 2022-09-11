import 'package:afro_grids/blocs/ads/ads_bloc.dart';
import 'package:afro_grids/blocs/ads/ads_event.dart';
import 'package:afro_grids/utilities/func_utils.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/ads/ads_state.dart';
import '../models/ads_model.dart';

class ViewAdsScreen extends StatefulWidget {
  const ViewAdsScreen({Key? key}) : super(key: key);

  @override
  State<ViewAdsScreen> createState() => _ViewAdsScreenState();
}

class _ViewAdsScreenState extends State<ViewAdsScreen> {
  List<AdsModel>? _ads;
  final CarouselController _carouselCtrller= CarouselController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdsBloc>(
      create: (context)=>AdsBloc()..add(FetchAdsEvent()),
      child: BlocConsumer<AdsBloc, AdsState>(
        listener: (context, state){
          if(state is AdsLoadedState){
            setState(()=>_ads=state.adsList);
          }
        },
        builder: (context, state){
          if(state is AdsLoadingState){
            return const Center(
              child: LoadingThreeBounce(),
            );
          }
          if(_ads != null){
            if(_ads!.isNotEmpty){
              return CarouselSlider(
                carouselController: _carouselCtrller,
                items: buildAds(),
                options: CarouselOptions(
                  autoPlay: true,
                  height: double.infinity,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                ),
              );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }

  List<Widget> buildAds(){
    return _ads!.map((ad){
      return GestureDetector(
        onTap: ()=>FuncUtils.openWebURL(ad.vendorLink),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(ad.fileURL),
                      fit: BoxFit.contain
                  )
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.only(right: 10, bottom: 10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromRGBO(255, 255, 255, 0.5)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.info, size: 18,),
                    SizedBox(width: 5,),
                    Text("sponsored ads")
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }).toList();
  }
}
