import 'package:afro_grids/blocs/service/service_bloc.dart';
import 'package:afro_grids/blocs/service/service_event.dart';
import 'package:afro_grids/blocs/serviceCategory/service_category_bloc.dart';
import 'package:afro_grids/models/service_model.dart';
import 'package:afro_grids/repositories/service_category_repo.dart';
import 'package:afro_grids/screens/view_ads_screen.dart';
import 'package:afro_grids/screens/service/service_map_select_screen.dart';
import 'package:afro_grids/screens/service/service_search_result_screen.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../blocs/service/service_state.dart';
import '../../blocs/serviceCategory/service_category_event.dart';
import '../../blocs/serviceCategory/service_category_state.dart';
import '../../models/service_category_model.dart';
import '../../utilities/colours.dart';

class ServiceSearchScreen extends StatefulWidget {
  const ServiceSearchScreen({Key? key}) : super(key: key);

  @override
  State<ServiceSearchScreen> createState() => _ServiceSearchScreenState();
}

class _ServiceSearchScreenState extends State<ServiceSearchScreen> {
  List<ServiceModel> _services = [];
  List<ServiceCategoryModel> _serviceCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        backgroundColor: Colours.tertiary,
        foregroundColor: Colours.primary,
        leading: IconButton(
          onPressed: ()=>Navigator.of(context).pop(),
          icon: const Icon(Ionicons.close_outline),
        ),
        title: const Text("Enter Service Category"),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ServiceBloc>(
              create: (context)=>ServiceBloc()..add(FetchServiceEvent(null))
          ),
          BlocProvider<ServiceCategoryBloc>(
              create: (context)=>ServiceCategoryBloc()..add(FetchServiceCategoryEvent())
          ),
        ],
        child: BlocListener<ServiceBloc, ServiceState>(
          listener: (context, state){
            if(state is ServiceErrorState){
              Alerts(context).showToast(state.message);
            }
            if(state is ServiceLoadedState){
              setState((){
                _services = state.services;
              });
            }
          },
          child: BlocListener<ServiceCategoryBloc, ServiceCategoryState>(
            listener: (context, state){
              if(state is ServiceCategoryErrorState){
                Alerts(context).showToast(state.message);
              }
              if(state is ServiceCategoryLoadedState){
                setState((){
                  _serviceCategories = state.serviceCategories;
                });
              }
            },
            child: Builder(
              builder: (context){
                return Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/logo_map.png"),
                          alignment: Alignment(0.8, 0.8)
                      )
                  ),
                  child: Column(
                    children: [
                      // Search Section
                      Container(
                        decoration: BoxDecoration(
                            color: Colours.tertiary,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, spreadRadius: 3, blurRadius: 5, offset: Offset.fromDirection(1))
                            ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child:  Row(
                            children: [
                              const Icon(Ionicons.locate_outline, color: Colours.primary,size: 25,),
                              const SizedBox(width: 30,),
                              // Search Bar
                              Expanded(
                                child: Autocomplete<ServiceModel>(
                                  displayStringForOption: (service)=>service.name,
                                  optionsBuilder: (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<ServiceModel>.empty();
                                    }
                                    return _services.where((ServiceModel option) {
                                      return option.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                    });
                                  },
                                  optionsViewBuilder: (
                                      BuildContext context,
                                      AutocompleteOnSelected<ServiceModel> onSelected,
                                      Iterable<ServiceModel> options
                                      ) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        width: 330,
                                        height: 400,
                                        margin: const EdgeInsets.only(top: 10),
                                        decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(color: Colors.black26,blurRadius: 5)
                                            ]
                                        ),
                                        child: Material(
                                            color: Colours.tertiary,
                                            elevation: 20,
                                            child: MediaQuery.removePadding(
                                              context: context,
                                              removeTop: true,
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                itemCount: options.length,
                                                separatorBuilder: (context, i) {
                                                  return const Divider();
                                                },
                                                itemBuilder: (BuildContext context, int index) {
                                                  final ServiceModel option = options.elementAt(index);
                                                  return GestureDetector(
                                                      onTap: () {
                                                        onSelected(option);
                                                      },
                                                      child: ListTile(
                                                        minLeadingWidth: 20,
                                                        dense: true,
                                                        visualDensity: const VisualDensity(vertical: -3, horizontal: -4),
                                                        leading: const Icon(Ionicons.pin_outline),
                                                        title: Text(option.name, style: const TextStyle(color: Colours.primary, fontSize: 18)),
                                                        subtitle: Text(
                                                            ServiceCategoryRepo()
                                                                .getServiceCategoryFromOptions(_serviceCategories, option.serviceCategoryId)
                                                                .getName?? option.serviceCategoryId,
                                                            style: const TextStyle(color: Colours.primary)
                                                        ),
                                                      )
                                                  );
                                                },
                                              ),
                                            )
                                        ),
                                      ),
                                    );
                                  },
                                  fieldViewBuilder: (
                                      BuildContext context,
                                      TextEditingController fieldTextEditingController,
                                      FocusNode fieldFocusNode,
                                      VoidCallback onFieldSubmitted
                                      ) {
                                    return TextField(
                                      controller: fieldTextEditingController,
                                      focusNode: fieldFocusNode,
                                      decoration: const InputDecoration(
                                        hintText: 'What service are you looking for',
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                                      ),
                                    );
                                  },
                                  onSelected: (ServiceModel selection) {
                                    NavigationService.toPage(ServiceSearchResultScreen(serviceModel: selection));
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Expanded(
                          child: SizedBox(
                            height: double.infinity,
                            child: ViewAdsScreen(),
                          )
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [boxShadow1()]
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: ()=>Navigator.of(context).push(createRoute(const ServiceMapSelectScreen())),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.location_on_sharp, color: Colours.primary, size: 15,),
                                Text("Choose on map", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
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
