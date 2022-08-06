import 'package:afro_grids/blocs/inventory/inventory_event.dart';
import 'package:afro_grids/blocs/inventory/inventory_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState>{

  InventoryBloc(): super(InventoryInitialState()){
    on<ChooseNewInventoryItemImages>(_mapChooseNewInventoryItemImagesToEvent);
    on<RemoveInventoryImageFromSelection>(_mapRemoveInventoryImageFromSelectionToEvent);
  }

  void _mapChooseNewInventoryItemImagesToEvent(ChooseNewInventoryItemImages event, Emitter<InventoryState> emit)async{
    emit(InventoryLoadingState());
    try{
      final ImagePicker picker = ImagePicker();
      final List<XFile>? images = await picker.pickMultiImage();
      if(images != null){
        emit(NewInventoryItemImagesSelected(images: images));
      }
    }catch(e){
      emit(InventoryErrorState(e.toString()));
    }

  }

  void _mapRemoveInventoryImageFromSelectionToEvent(RemoveInventoryImageFromSelection event, Emitter<InventoryState> emit){
    emit(InventoryLoadingState());
    event.images.remove(event.image);
    emit(NewInventoryItemImagesUpdated(images: event.images));
  }

}