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


class UpdateMultipleServiceInventoryScreen extends StatefulWidget {
  final InventoryModel inventory;
  const UpdateMultipleServiceInventoryScreen({Key? key, required this.inventory}) : super(key: key);

  @override
  State<UpdateMultipleServiceInventoryScreen> createState() => _UpdateMultipleServiceInventoryScreenState();
}

class _UpdateMultipleServiceInventoryScreenState extends State<UpdateMultipleServiceInventoryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colours.tertiary,
        appBar: AppBar(
          title: const Text("Update Inventory"),
        ),
        body: CustomLoadingOverlay(
          widget: BlocProvider(
            create: (context)=>InventoryBloc()..add(GetInventoryEvent(inventoryId: widget.inventory.id)),
            child: BlocConsumer<InventoryBloc, InventoryState>(
              listener: (context, state){
                if(state is InventoryLoadingState){
                  context.loaderOverlay.show();
                }else{
                  context.loaderOverlay.hide();
                }
                if(state is InventoryErrorState){
                  Alerts(context).showErrorDialog(title: "Something happened", message: state.message);
                }
                if(state is InventoryUpdatedState){
                  Alerts(context).showToast("Item updated successfully");
                  NavigationService.exitPage(true);
                }
              },
              builder: (context, state){
                if(state is InventoryLoadedState){
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        UpdateMultiServiceInventoryForm(
                          inventory: state.inventory!,
                          onComplete: (inventory, images){
                            final List<String> modImages;
                            if(images != null){
                              modImages = state.inventory!.images;
                            }else{
                              modImages = state.inventory!.images.where((image) => !inventory.images.contains(image)).toList();
                            }
                            BlocProvider.of<InventoryBloc>(context).add(
                                UpdateInventoryEvent(
                                    inventory: inventory,
                                    images: images,
                                    imagesToDelete: modImages
                                )
                            );
                          },
                        )
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        )
    );
  }
}
