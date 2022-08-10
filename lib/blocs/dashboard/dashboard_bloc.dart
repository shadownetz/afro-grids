import 'package:afro_grids/blocs/dashboard/dashboard_event.dart';
import 'package:afro_grids/blocs/dashboard/dashboard_state.dart';
import 'package:afro_grids/utilities/services/device_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState>{
  DashboardBloc(): super(InitialDashboardState()){
    on<FetchDashboardInfo>(_mapFetchDashboardInfoToState);

  }

  void _mapFetchDashboardInfoToState(DashboardEvent event, Emitter<DashboardState> emit) async {
    try{
      emit(DashboardLoadingState());
      var devicePosition = await DeviceService().determinePosition();
      emit(DashboardLoadedState(devicePosition: devicePosition));
    }catch(e){
      emit(DashboardErrorState(e.toString()));
    }
  }

}