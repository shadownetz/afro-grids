import 'package:afro_grids/blocs/inventory/inventory_bloc.dart';
import 'package:afro_grids/blocs/inventory/inventory_event.dart';
import 'package:afro_grids/blocs/user/user_bloc.dart';
import 'package:afro_grids/blocs/user/user_event.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/screens/provider/account/add_multiple_service_inventory_screen.dart';
import 'package:afro_grids/screens/provider/account/update_single_service_inventory_screen.dart';
import 'package:afro_grids/screens/provider/account/view_multiple_service_inventory_screen.dart';
import 'package:afro_grids/utilities/alerts.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/forms/models/service_forms.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../blocs/inventory/inventory_state.dart';
import '../../../blocs/user/user_state.dart';
import '../../../models/inventory_model.dart';
import '../../../models/user/user_model.dart';
import '../../../utilities/class_constants.dart';
import '../../../utilities/widgets/provider_widgets.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String viewMode = localStorage.user!.serviceType;
  UserBloc? _userProvider;
  InventoryBloc? _inventoryBloc;
  UserModel? _user;
  List<InventoryModel> _inventories = [];
  String _inventoryDescription = "";

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    _user = localStorage.user;

    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white,),
        title: const Text("Inventory"),
      ),
      body: CustomLoadingOverlay(
        widget: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context)=>UserBloc())
          ],
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state){
              if(state is UserLoadingState){
                context.loaderOverlay.show();
              }else{
                context.loaderOverlay.hide();
              }
              if(state is UserLoadedState){
                setState(()=>viewMode=localStorage.user!.serviceType);
              }
              if(state is UserErrorState){
                Alerts(context).showToast(state.message, duration: const Duration(seconds: 5));
              }
            },
            builder: (context, state){
              _userProvider = BlocProvider.of<UserBloc>(context);
              return Container(
                width: deviceWidth,
                height: deviceHeight,
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
                // margin: EdgeInsets.only(bottom: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UpdateProviderServiceForm(
                        onUpdated: (serviceId, serviceType){
                          saveChanges(serviceId, serviceType);
                        },
                      ),
                      const SizedBox(height: 20,),
                      CustomLoadingOverlay(
                          widget: BlocProvider<InventoryBloc>(
                            create: (context)=>InventoryBloc()..add(FetchProviderInventories(localStorage.user!)),
                            child: BlocConsumer<InventoryBloc, InventoryState>(
                              listener: (context, state){
                                if(state is InventoryLoadingState){
                                  context.loaderOverlay.show();
                                }else{
                                  context.loaderOverlay.hide();
                                }
                                if(state is InventoryErrorState){
                                  Alerts(context).showErrorDialog(title: "Unable to add inventory", message: state.message);
                                }
                                if(state is InventoryLoadedState){
                                  setState(()=>_inventories=state.inventories);
                                }
                              },
                              builder: (context, state){
                                _inventoryBloc = BlocProvider.of<InventoryBloc>(context);
                                return AnimatedCrossFade(
                                    firstChild: multipleServiceItemsUI(),
                                    secondChild: singleServiceItemUI(),
                                    crossFadeState: viewMode==ServiceType.multiple?CrossFadeState.showFirst: CrossFadeState.showSecond,
                                    duration: const Duration(milliseconds: 500)
                                );
                              },
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: AnimatedCrossFade(
          firstChild: floatingAction1(),
          secondChild: floatingAction2(),
          crossFadeState: viewMode==ServiceType.multiple?CrossFadeState.showFirst: CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 500)
      ),
    );
  }

  Widget floatingAction1(){
    return ElevatedButton(
      onPressed: ()async{
        var result = await NavigationService.toPage(const AddMultipleServiceInventoryScreen());
        if(result == true){
          _inventoryBloc!.add(FetchProviderInventories(localStorage.user!));
        }
      },
      style: ElevatedButton.styleFrom(
          elevation: 2,
          minimumSize: const Size(50, 50),
          primary: Colours.secondary,
          onPrimary: Colours.primary,
          shape:const CircleBorder()
      ),
      child: const Icon(Icons.add),
    );
  }
  Widget floatingAction2(){
    return ElevatedButton(
      onPressed: ()async{
        InventoryModel? inventory;
        if(_inventories.isNotEmpty){
          inventory = _inventories.first;
        }
        var result = await NavigationService.toPage(UpdateSingleServiceInventoryScreen(inventory: inventory,));
        if(result == true){
          _inventoryBloc!.add(FetchProviderInventories(localStorage.user!));
        }
      },
      style: ElevatedButton.styleFrom(
          elevation: 2,
          minimumSize: const Size(50, 50),
          primary: Colours.secondary,
          onPrimary: Colours.primary,
          shape:const CircleBorder()
      ),
      child: const Icon(Icons.edit_outlined),
    );
  }
  Widget multipleServiceItemsUI(){
    return BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state){
          if(_inventories.isNotEmpty){
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("showing ${_inventories.length} of ${_inventories.length} items"),
                    PopupMenuButton(
                        position: PopupMenuPosition.under,
                        icon: const Icon(Icons.filter_list),
                        onSelected: (String item){
                          // print(item);
                        },
                        itemBuilder: (context){
                          return [
                            const PopupMenuItem<String>(
                                enabled: false,
                                child: Text("Date")
                            ),
                            const PopupMenuItem<String>(
                                value: "date_asc",
                                child: Text("ascending")
                            ),
                            const PopupMenuItem<String>(
                                value: "date_desc",
                                child: Text("descending")
                            ),
                            const PopupMenuItem<String>(
                                enabled: false,
                                child: Text("Price")
                            ),
                            const PopupMenuItem<String>(
                                value: "price_asc",
                                child: Text("ascending")
                            ),
                            const PopupMenuItem<String>(
                                value: "price_desc",
                                child: Text("descending")
                            )
                          ];
                        }
                    )
                  ],
                ),
                InventoryView(
                  items:  _inventories,
                  onClick: (item) async {
                    var result = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context)=>ViewMultipleServiceInventoryScreen(inventory: item)
                    );
                    if(result == true){
                      _inventoryBloc!.add(FetchProviderInventories(localStorage.user!));
                    }
                  },
                )
              ],
            );
          }
          return Container(
            alignment: Alignment.center,
            child: const Text(
              "You do not have any items in your inventory at the moment",
              style: TextStyle(fontSize: 17, color: Colors.black26),
            ),
          );
        }
    );
  }
  Widget singleServiceItemUI(){
    return BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state){
          if(_inventories.isNotEmpty){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Description", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                const SizedBox(height: 20,),
                Text(_inventories.first.description),
              ],
            );
          }
          return Container(
            alignment: Alignment.center,
            child: const Text(
              "You have no description of your service at the moment",
              style: TextStyle(fontSize: 17, color: Colors.black26),
            ),
          );
        }
    );
  }

  saveChanges(String? serviceId, String? serviceType)async{
    if(viewMode != serviceType){
      var decision = await Alerts(context)
          .showConfirmDialog(
          title: "Critical change",
          message: "You are attempting to modify your service type. If you proceed with this operation every items in your inventory will be cleared"
      );
      if(decision != true){
        NavigationService.exitPage();
        return null;
      }
    }
    _user?.serviceId = serviceId??localStorage.user!.serviceId;
    _user?.serviceType = serviceType??localStorage.user!.serviceType;
    _userProvider?.add(UpdateUserEvent(_user!));
  }
}
