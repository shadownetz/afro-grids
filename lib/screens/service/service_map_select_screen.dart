import 'package:afro_grids/blocs/device/device_bloc.dart';
import 'package:afro_grids/blocs/device/device_state.dart';
import 'package:afro_grids/screens/provider/provider_info_multiple_service_screen.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';

import '../../blocs/device/device_event.dart';
import '../../utilities/alerts.dart';
import '../../utilities/widgets/button_widget.dart';
import '../../utilities/widgets/widgets.dart';
import '../provider/provider_info_single_service_screen.dart';

class ServiceMapSelectScreen extends StatefulWidget {
  const ServiceMapSelectScreen({Key? key}) : super(key: key);

  @override
  State<ServiceMapSelectScreen> createState() => _ServiceMapSelectScreenState();
}

class _ServiceMapSelectScreenState extends State<ServiceMapSelectScreen> {
  late GoogleMapController mapController;

  final LatLng _mapCenter = const LatLng(6.465422, 3.406448);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocProvider(
        create: (BuildContext context)=>DeviceBloc()..add(FetchDeviceLocationEvent()),
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
                  height: deviceHeight-(deviceHeight/4),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: _mapCenter,
                      zoom: 15.0,
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(-0.9, -0.9),
                  child: Container(
                    width: 40,
                    height: 40,
                    // padding: EdgeInsets.only(left: 5),
                    decoration: const BoxDecoration(
                        color: Colours.tertiary,
                        shape: BoxShape.circle
                    ),
                    child: IconButton(
                      icon: const Icon(Ionicons.chevron_back),
                      onPressed: ()=>Navigator.of(context).pop(),
                    ),
                  ),
                ),
                // extra info bottom container
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Container(
                      width: deviceWidth,
                      decoration: BoxDecoration(
                          color: Colours.tertiary,
                          boxShadow: [
                            boxShadow1()
                          ]
                      ),
                      height: deviceHeight/4,
                      child: Column(
                        children: [
                          modalDragIndicator(),
                          const SizedBox(height: 20,),
                          const Text("Confirm selection", style: TextStyle(fontSize: 17, color: Colors.grey),),
                          const SizedBox(height: 25,),

                          providerInfoItem(),

                          SizedBox(height: 20,),
                          // confirm button
                          ElevatedButton(
                              onPressed: ()=>Navigator.of(context).push(createRoute(const ProviderInfoMultipleServiceScreen())),
                              style: buttonPrimaryMdStyle(),
                              child: Text("Confirm selection")
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      )
    );
  }

  Widget providerInfoItem(){
    return GestureDetector(
      onTap: ()=>Navigator.of(context).push(createRoute(const ProviderInfoSingleServiceScreen())),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            boxShadow: [boxShadow1()],
            color: Colours.tertiary
        ),
        child: Row(
          children: [
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
            SizedBox(width: 10,),
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
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text("Hair Dresser", style: TextStyle(color: Colors.grey),),
                    Text("0.3 km", style: TextStyle(color: Colors.grey))
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
