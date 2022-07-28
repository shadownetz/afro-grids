import 'package:afro_grids/blocs/dashboard/dashboard_bloc.dart';
import 'package:afro_grids/blocs/dashboard/dashboard_event.dart';
import 'package:afro_grids/screens/service/service_search_screen.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';

import '../../blocs/dashboard/dashboard_state.dart';
import '../../utilities/colours.dart';
import '../../utilities/widgets/widgets.dart';
import 'chat/chats_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({Key? key}) : super(key: key);

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  late GoogleMapController mapController;

  final LatLng _mapCenter = const LatLng(6.465422, 3.406448);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery. of(context). size. width ;
    double deviceHeight = MediaQuery. of(context). size. height;

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        backgroundColor: Colours.tertiary,
        title: appBarLogo(theme: 'dark'),
        actions: [
          IconButton(
              onPressed: ()=>{},
              icon: const Icon(
                Ionicons.settings_outline,
                color: Colours.primary,
              )
          )
        ],
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (BuildContext context)=>DashboardBloc()..add(FetchDashboardInfo()),
          child: BlocConsumer<DashboardBloc, DashboardState>(
            listener: (context, state){
              if(state is DashboardErrorState){
                Alerts(context).showToast(state.message);
              }
              if(state is DashboardLoadedState){
                mapController.animateCamera(CameraUpdate.newLatLng(LatLng(state.devicePosition!.latitude, state.devicePosition!.longitude)));
              }
            },
            builder: (context, state){
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Section 1
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // user profile
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Stack(
                            children: [
                              const Align(
                                alignment: Alignment.topCenter,
                                child: Image(
                                  image: AssetImage('assets/avatars/man.png'), // or woman image depending on gender
                                  width: 170,
                                  height: 170,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    width: double.infinity,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.white.withOpacity(0),
                                            Colors.white.withOpacity(0.9),
                                            Colors.white.withOpacity(1),
                                            Colors.white,
                                          ],
                                        )
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10, top: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            "Lintang C",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "user",
                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                        // favorites & chats
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // favorites
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              height: 90,
                              width: 170,
                              child: GestureDetector(
                                child: Card(
                                  surfaceTintColor: Colors.white,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                    child:  Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: const [
                                            Icon(Ionicons.bookmark, size: 10, color: Colors.grey,),
                                            Text("Favorites", style: TextStyle(color: Colors.grey,),),
                                            Expanded(
                                                child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Icon(Ionicons.chevron_forward_outline, size: 15,color: Colors.grey,),
                                                )
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text("120", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                            Expanded(
                                                child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                            image: DecorationImage(
                                                                image: AssetImage('assets/avatars/man.png')
                                                            )
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        margin: EdgeInsets.only(left: 12),
                                                        decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                            image: DecorationImage(
                                                                image: AssetImage('assets/avatars/woman.png')
                                                            )
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 20,
                                                        height: 20,
                                                        margin: EdgeInsets.only(left: 24),
                                                        decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                            image: DecorationImage(
                                                                image: AssetImage('assets/avatars/man.png')
                                                            )
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // chats
                            SizedBox(
                                height: 90,
                                width: 170,
                                child: GestureDetector(
                                  onTap: ()=>Navigator.of(context).push(createRoute(const ChatScreen())),
                                  child: Card(
                                    surfaceTintColor: Colors.white,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Image(
                                            width: 50,
                                            height: 50,
                                            image: AssetImage('assets/icons/message.png'),
                                          ),
                                          Text(
                                            "Chats",
                                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        )
                      ],
                    ),
                    // history section
                    Container(
                      height: 90,
                      width: deviceWidth-20,
                      margin: const EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10,),
                          const Image(
                            width: 40,
                            height: 40,
                            image: AssetImage("assets/icons/history.png"),
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("History", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                              Text("view your past orders", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),)
                            ],
                          )
                        ],
                      ),
                    ),
                    // find a provider section
                    Container(
                      height: 90,
                      width: deviceWidth-20,
                      margin: const EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: ()=>Navigator.of(context).push(createRoute(const ServiceSearchScreen())),
                        child: Row(
                          children: [
                            const SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Find a Provider", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                Text("locate the closest service provider around you", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),)
                              ],
                            ),
                            const Expanded(
                              child: Image(
                                width: 40,
                                height: 40,
                                alignment: Alignment.centerRight,
                                image: AssetImage("assets/icons/locationPin.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 10,),
                          ],
                        ),
                      ),
                    ),
                    // map section
                    Container(
                      height: 250,
                      width: deviceWidth-20,
                      margin: const EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: _mapCenter,
                          zoom: 5.0,
                        ),
                      ),
                    ),
                    // copyright
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: const Text(
                        'v1.0.0 Afrogrids 2022',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
