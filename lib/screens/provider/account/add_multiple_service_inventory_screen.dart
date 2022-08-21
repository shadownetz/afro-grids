import 'package:afro_grids/blocs/inventory/inventory_bloc.dart';
import 'package:afro_grids/blocs/inventory/inventory_event.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../blocs/inventory/inventory_state.dart';
import '../../../utilities/alerts.dart';
import '../../../utilities/forms/models/inventory_forms.dart';


class AddMultipleServiceInventoryScreen extends StatefulWidget {
  const AddMultipleServiceInventoryScreen({Key? key}) : super(key: key);

  @override
  State<AddMultipleServiceInventoryScreen> createState() => _AddMultipleServiceInventoryScreenState();
}

class _AddMultipleServiceInventoryScreenState extends State<AddMultipleServiceInventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colours.tertiary,
        appBar: AppBar(
          title: const Text("New Inventory"),
        ),
        body: CustomLoadingOverlay(
          widget: BlocProvider<InventoryBloc>(
            create: (context)=>InventoryBloc(),
            child: BlocConsumer<InventoryBloc, InventoryState>(
              listener: (context, state){
                if(state is InventoryLoadingState){
                  context.loaderOverlay.show();
                }else{
                  context.loaderOverlay.hide();
                }
                if(state is InventoryErrorState){
                  Alerts(context).showErrorDialog(title: "Unable to fetch inventories", message: state.message);
                }
                if(state is InventoryLoadedState){
                  Alerts(context).showToast("Item added successfully");
                  NavigationService.exitPage(true);
                }
              },
              builder: (context, state){
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      NewMultiServiceInventoryForm(
                        onComplete: (inventory, images){
                          BlocProvider.of<InventoryBloc>(context).add(
                              CreateInventoryEvent(
                                  inventory: inventory,
                                  images: images
                              )
                          );
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        )
    );
  }
}
