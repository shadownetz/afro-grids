import 'package:afro_grids/blocs/device/device_event.dart';
import 'package:afro_grids/blocs/device/device_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../utilities/services/device_service.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState>{
  DeviceBloc(): super(DeviceInitialState()){
    on<FetchDeviceLocationEvent>(_mapFetchDeviceLocationToState);
    on<ChooseImagesEvent>(_mapChooseImagesEventToEvent);
    on<ChooseImageEvent>(_mapChooseImageEventToEvent);
    on<RemoveItemFromImagesEvent>(_mapRemoveItemFromImagesEventToEvent);
  }

  void _mapFetchDeviceLocationToState(DeviceEvent event, Emitter<DeviceState> emit)async{
    try{
      emit(DeviceLoadingState());
      var devicePosition = await DeviceService().determinePosition();
      emit(DeviceLoadedState(devicePosition: devicePosition));
    }catch(e){
      emit(DeviceErrorState(e.toString()));
    }
  }

  void _mapChooseImagesEventToEvent(ChooseImagesEvent event, Emitter<DeviceState> emit)async{
    emit(DeviceLoadingState());
    try{
      final ImagePicker picker = ImagePicker();
      final List<XFile>? images = await picker.pickMultiImage();
      if(images != null){
        emit(NewImagesSelected(images: images));
      }
    }catch(e){
      emit(DeviceErrorState(e.toString()));
    }

  }

  void _mapRemoveItemFromImagesEventToEvent(RemoveItemFromImagesEvent event, Emitter<DeviceState> emit){
    emit(DeviceLoadingState());
    event.images.remove(event.image);
    emit(NewImagesUpdated(images: event.images));
  }

  void _mapChooseImageEventToEvent(ChooseImageEvent event, Emitter<DeviceState> emit)async{
    emit(DeviceLoadingState());
    try{
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if(image != null){
        emit(NewImageSelected(image: image));
      }
    }catch(e){
      emit(DeviceErrorState(e.toString()));
    }

  }

}