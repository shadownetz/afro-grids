import 'package:afro_grids/blocs/inventory/inventory_event.dart';
import 'package:afro_grids/blocs/inventory/inventory_state.dart';
import 'package:afro_grids/repositories/inventory_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState>{

  InventoryBloc(): super(InventoryInitialState()){
    on<CreateInventoryEvent>(_mapCreateInventoryEventToEvent);
    on<FetchProviderInventories>(_mapFetchProviderInventoriesToEvent);
    on<UpdateInventoryEvent>(_mapUpdateInventoryEventToEvent);
    on<GetInventoryEvent>(_mapGetInventoryEventToEvent);
    on<DisableInventoryEvent>(_mapDisableInventoryEventToEvent);
  }

  void _mapGetInventoryEventToEvent(GetInventoryEvent event, Emitter<InventoryState> emit)async{
    emit(InventoryLoadingState());
    try{
      var inventory = await InventoryRepo().getInventory(event.inventoryId);
      if(inventory != null){
        emit(InventoryLoadedState(inventory: inventory));
      }else{
        emit(InventoryErrorState("There was an error retrieving this item data"));
      }
    }catch(e){
      emit(InventoryErrorState(e.toString()));
    }
  }

  void _mapFetchProviderInventoriesToEvent(FetchProviderInventories event, Emitter<InventoryState> emit)async{
    emit(InventoryLoadingState());
    try{
      var inventories = await InventoryRepo().fetchProviderItems(event.provider.id);
      emit(InventoryLoadedState(inventories: inventories));
    }catch(e){
      emit(InventoryErrorState(e.toString()));
    }
  }

  void _mapCreateInventoryEventToEvent(CreateInventoryEvent event, Emitter<InventoryState> emit)async{
    emit(InventoryLoadingState());
    try{
      var inventory = InventoryRepo(inventory: event.inventory);
      if(event.images != null){
        await inventory.uploadImages(event.images!);
      }
      await inventory.addInventory();
      emit(InventoryLoadedState());
    }catch(e){
      emit(InventoryErrorState(e.toString()));
    }
  }

  void _mapUpdateInventoryEventToEvent(UpdateInventoryEvent event, Emitter<InventoryState> emit)async{
    emit(InventoryLoadingState());
    try{
      var inventory = InventoryRepo(inventory: event.inventory);
      if(event.imagesToDelete != null){
        await inventory.deleteImages(event.imagesToDelete!);
      }
      if(event.images != null){
        await inventory.uploadImages(event.images!);
      }
      await inventory.updateInventory();
      emit(InventoryUpdatedState());
    }catch(e){
      emit(InventoryErrorState(e.toString()));
    }
  }

  void _mapDisableInventoryEventToEvent(DisableInventoryEvent event, Emitter<InventoryState> emit)async{
    emit(InventoryLoadingState());
    try{
      await InventoryRepo(inventory: event.inventory).softDeleteInventory();
      emit(InventoryUpdatedState());
    }catch(e){
      emit(InventoryErrorState(e.toString()));
    }
  }


}