import 'package:afro_grids/blocs/inventory/inventory_bloc.dart';
import 'package:afro_grids/blocs/inventory/inventory_event.dart';
import 'package:afro_grids/models/inventory_model.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../blocs/inventory/inventory_state.dart';
import '../../../utilities/alerts.dart';
import '../../../utilities/forms/models/inventory_forms.dart';
import '../../../utilities/services/navigation_service.dart';


class UpdateSingleServiceInventoryScreen extends StatefulWidget {
  final InventoryModel? inventory;
  const UpdateSingleServiceInventoryScreen({Key? key, this.inventory}) : super(key: key);

  @override
  State<UpdateSingleServiceInventoryScreen> createState() => _UpdateSingleServiceInventoryScreenState();
}

class _UpdateSingleServiceInventoryScreenState extends State<UpdateSingleServiceInventoryScreen> {
  InventoryModel? _inventory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.tertiary,
      appBar: AppBar(
        title: const Text("Update Inventory"),
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
                Alerts(context).showErrorDialog(title: "Something unexpected happened", message: state.message);
              }
              if(state is InventoryLoadedState){
                setState(()=>_inventory = state.inventory);
              }
              if(state is InventoryUpdatedState){
                Alerts(context).showToast("Description updated successfully");
                NavigationService.exitPage(true);
              }
            },
            builder: (context, state){
              if(state is InventoryInitialState){
                if(widget.inventory != null){
                  BlocProvider.of<InventoryBloc>(context).add(GetInventoryEvent(inventoryId: widget.inventory!.id));
                }
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    UpdateSingleServiceInventoryForm(
                      key: Key("${_inventory?.id}"),
                      inventory: _inventory,
                      onComplete: (inventory){
                        BlocProvider.of<InventoryBloc>(context).add(
                            UpdateInventoryEvent(inventory: inventory)
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
