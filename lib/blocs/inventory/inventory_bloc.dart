import 'package:afro_grids/blocs/inventory/inventory_event.dart';
import 'package:afro_grids/blocs/inventory/inventory_state.dart';
import 'package:afro_grids/repositories/inventory_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState>{

  InventoryBloc(): super(InventoryInitialState()){
    on<CreateInventoryEvent>(_mapCreateInventoryEventToEvent);
    on<FetchProviderInventories>(_mapFetchProviderInventoriesToEvent);
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


}