import 'package:afro_grids/blocs/device/device_event.dart';
import 'package:afro_grids/blocs/device/device_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/device_repo.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState>{
  DeviceBloc(): super(DeviceInitialState()){
    on<FetchDeviceLocation>(_mapFetchDeviceLocationToState);
  }

  void _mapFetchDeviceLocationToState(DeviceEvent event, Emitter<DeviceState> emit)async{
    try{
      emit(DeviceLoadingState());
      var devicePosition = await DeviceRepo().determinePosition();
      emit(DeviceLoadedState(devicePosition: devicePosition));
    }catch(e){
      emit(DeviceErrorState(e.toString()));
    }
  }
}