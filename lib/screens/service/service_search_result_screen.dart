import 'package:afro_grids/models/service_model.dart';
import 'package:afro_grids/screens/provider/provider_info_single_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';

import '../../blocs/device/device_bloc.dart';
import '../../blocs/device/device_event.dart';
import '../../blocs/device/device_state.dart';
import '../../utilities/alerts.dart';
import '../../utilities/colours.dart';
import '../../utilities/widgets/button_widget.dart';
import '../../utilities/widgets/widgets.dart';

class ServiceSearchResultScreen extends StatefulWidget {
  final ServiceModel serviceModel;
  const ServiceSearchResultScreen({Key? key, required this.serviceModel}) : super(key: key);

  @override
  State<ServiceSearchResultScreen> createState() => _ServiceSearchResultScreenState();
}

class _ServiceSearchResultScreenState extends State<ServiceSearchResultScreen> {
  late GoogleMapController mapController;
  double _verticalH = 0;

  final LatLng _mapCenter = const LatLng(6.465422, 3.406448);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceMargin = deviceHeight/3;
    bool dragIsMidScreen = _verticalH > (deviceHeight/2);
    double _height = _verticalH==0?deviceMargin:_verticalH;
    AppBar? _appBar ;

    if(dragIsMidScreen){
      _appBar = AppBar(
        title: const Text("Select a provider"),
        leading: IconButton(
          icon: Icon(Ionicons.arrow_back),
          onPressed: ()=>{
            setState((){
              _verticalH = 0;
            })
          },
        ),
      );
    }

    return Scaffold(
        appBar: _appBar,
        body: BlocProvider(
          create: (BuildContext context)=>DeviceBloc()..add(FetchDeviceLocation()),
          child: BlocConsumer<DeviceBloc, DeviceState>(
            listener: (context, state){
              if(state is DeviceLoadedState){
                if(state.devicePosition != null){
                  mapController.animateCamera(
                      CameraUpdate.newLatLng(LatLng(state.devicePosition!.latitude, state.devicePosition!.longitude))
                  );
                }
              }
              if(state is DeviceErrorState){
                Alerts(context).showToast(state.message);
              }
            },
            builder: (context, state){
              return Stack(
                children: [
                  SizedBox(
                    height: deviceHeight-deviceMargin,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: _mapCenter,
                        zoom: 15.0,
                      ),
                    ),
                  ),
                  // search bar
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 100),
                    firstChild: searchBar(deviceWidth: deviceWidth),
                    secondChild: Container(),
                    crossFadeState: dragIsMidScreen? CrossFadeState.showSecond: CrossFadeState.showFirst,
                  ),
                  // provider list container
                  providerList(
                      height: _height,
                      deviceHeight: deviceHeight,
                      deviceMargin: deviceMargin,
                      deviceWidth: deviceWidth,
                      dragIsMidScreen: dragIsMidScreen
                  )
                ],
              );
            },
          ),
        )
    );
  }

  Widget searchBar({required deviceWidth}){
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: deviceWidth-20,
        height: 50,
        margin: EdgeInsets.only(left: 10,right: 10, top: 50),
        clipBehavior: Clip.antiAlias,
        // padding: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Ionicons.chevron_back),
              onPressed: ()=>Navigator.of(context).pop(),
            ),
            Expanded(
                child: Container(
                  height: 40,
                  width: deviceWidth-40,
                  decoration: BoxDecoration(
                      color: Colours.tertiary,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: Colors.grey, size: 15,),
                      SizedBox(width: 5,),
                      Text(widget.serviceModel.name, style: TextStyle(color: Colors.grey, fontSize: 17),)
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Widget providerList({required height, required deviceWidth, required deviceHeight, required deviceMargin, required dragIsMidScreen}){
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: GestureDetector(
            onVerticalDragUpdate: (details){
              final dy = deviceHeight - details.globalPosition.dy;
              setState(()=>{
                // should not slide down if it exceeds initial height
                if(dy > deviceMargin){
                  _verticalH = dy
                }else{
                  _verticalH = deviceMargin
                }
              });
            },
            onVerticalDragEnd: (details){
              if(_verticalH > (deviceHeight/2)){
                _verticalH = deviceHeight;
              }else{
                _verticalH = 0;
              }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: deviceWidth,
              decoration: BoxDecoration(
                  color: Colours.tertiary,
                  boxShadow: [
                    boxShadow1()
                  ]
              ),
              height: height,
              child: SingleChildScrollView(
                physics: dragIsMidScreen? AlwaysScrollableScrollPhysics(): NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    AnimatedCrossFade(
                        firstChild: Column(
                          children: [
                            // drag indicator
                            modalDragIndicator(),
                            const SizedBox(height: 20,),
                            const SizedBox(
                              width: 250,
                              child: Text(
                                "Select a provider to continue or swipe up to view complete list",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 17, color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                        secondChild: Container(),
                        crossFadeState: dragIsMidScreen? CrossFadeState.showSecond: CrossFadeState.showFirst,
                        duration: const Duration(seconds: 1)
                    ),
                    const SizedBox(height: 25,),
                    Column(
                      children: [
                        providerListItem(dragIsMidScreen: dragIsMidScreen),
                        providerListItem(dragIsMidScreen: dragIsMidScreen),
                        providerListItem(dragIsMidScreen: dragIsMidScreen),
                        providerListItem(dragIsMidScreen: dragIsMidScreen)
                      ],
                    ),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }

  Widget providerListItem({required dragIsMidScreen}){
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: ()=>Navigator.of(context).push(createRoute(const ProviderInfoSingleServiceScreen())),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: dragIsMidScreen? null : BoxDecoration(
            boxShadow: [boxShadow1()],
            color: Colours.tertiary
        ),
        child: Container(
          padding: const EdgeInsets.only(bottom: 10),
          decoration: !dragIsMidScreen? null : const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color.fromRGBO(200, 200, 200, 1))
              )
          ),
          child: Row(
            children: [
              // Item 1
              // provider icon
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/avatars/woman.png')
                    )
                ),
              ),
              const SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mary Yvonne", style: TextStyle(fontSize: 20),),
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.green, size: 15,),
                      Icon(Icons.star, color: Colors.green, size: 15),
                      Icon(Icons.star, color: Colors.green, size: 15),
                      Icon(Icons.star, color: Colors.green, size: 15),
                      Icon(Icons.star, color: Colors.green, size: 15),
                      SizedBox(width: 10,),
                      Text("5.0 [1k+ reviews]", style: TextStyle(color: Colors.grey),)
                    ],
                  )
                ],
              ),
              const Expanded(
                  child: Text(
                    "0.3 km",
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

}
