import 'package:afro_grids/blocs/service/service_bloc.dart';
import 'package:afro_grids/models/service_model.dart';
import 'package:afro_grids/repositories/service_repo.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../blocs/service/service_event.dart';
import '../../blocs/service/service_state.dart';
import '../../main.dart';
import '../../models/user_model.dart';
import '../../utilities/alerts.dart';
import '../../utilities/navigation_guards.dart';
import '../../utilities/services/gmap_service.dart';
import '../../utilities/widgets/button_widget.dart';
import '../../utilities/widgets/widgets.dart';

class ServiceMapSelectScreen extends StatefulWidget {
  const ServiceMapSelectScreen({Key? key}) : super(key: key);

  @override
  State<ServiceMapSelectScreen> createState() => _ServiceMapSelectScreenState();
}

class _ServiceMapSelectScreenState extends State<ServiceMapSelectScreen> {
  late GoogleMapController mapController;
  List<UserModel> _users = [];
  Set<Marker> _usersMarker = {};
  ServiceModel? _userService;
  UserModel? _selectedUser;

  final LatLng _mapCenter = const LatLng(6.465422, 3.406448);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  void _initMapValues({required List<UserModel> users})async{
    var markers = await GMapService.getUsersMarker(
        users,
        onTapAction: (user)=>_setUser(user)
    );
    setState((){
      _users = users;
      _usersMarker = markers;
    });
    if(users.isNotEmpty){
      mapController.animateCamera(CameraUpdate.newLatLngBounds(
          GMapService.boundsFromLatLngList(users),
          50
      ));
    }
  }
  void _setUser(UserModel user) async{
    setState((){
      _userService = null;
      _selectedUser = user;
    });
    try{
      var service = await ServiceRepo().getServiceByID(user.serviceId);
      setState(()=>_userService=service);
    }catch(e){
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: CustomLoadingOverlay(
          widget: BlocProvider<ServiceBloc>(
            create: (context)=>ServiceBloc()..add(FetchNearbyProvidersEvent()),
            child: BlocConsumer<ServiceBloc, ServiceState>(
              listener: (context, state){
                if(state is ServiceLoadingState){
                  context.loaderOverlay.show();
                }else{
                  context.loaderOverlay.hide();
                }
                if(state is FetchedServiceProvidersState){
                  _initMapValues(users: state.users);
                }
                if(state is ServiceErrorState){
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
                        markers: _usersMarker,
                        // gestureRecognizers: {
                        //   Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                        // },
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

                              const SizedBox(height: 20,),
                              // confirm button
                              AnimatedCrossFade(
                                  firstChild: ElevatedButton(
                                      onPressed: (){
                                        NavigationGuards(user: _selectedUser!).navigateToPortfolioPage();
                                      },
                                      style: buttonPrimaryMdStyle(),
                                      child: const Text("Confirm selection")
                                  ),
                                  secondChild: Container(),
                                  crossFadeState: _selectedUser!=null?CrossFadeState.showFirst: CrossFadeState.showSecond,
                                  duration: const Duration(milliseconds: 500)
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
          ),
        )
    );
  }

  Widget providerInfoItem(){
    if(_selectedUser != null){
      return GestureDetector(
        onTap: ()=>{},
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              boxShadow: [boxShadow1()],
              color: Colours.tertiary
          ),
          child: Row(
            children: [
              // provider icon
              RoundImage(
                image: NetworkImage(_selectedUser!.avatar),
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${_selectedUser!.firstName} ${_selectedUser!.lastName}", style: const TextStyle(fontSize: 20),),
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
                    children: [
                      Text(
                        _userService!=null?_userService!.name:_selectedUser!.serviceId,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                          "${_selectedUser!.distanceFrom(localStorage.user!.location).toStringAsFixed(2)} km",
                          style: const TextStyle(color: Colors.grey)
                      )
                    ],
                  )
              )
            ],
          ),
        ),
      );
    }
    return const Text(
      "Select a provider from the map to continue",
      style: TextStyle(fontSize: 17, color: Colors.grey),
    );
  }
}
