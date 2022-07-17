import 'package:afro_grids/blocs/dashboard/dashboard_event.dart';
import 'package:afro_grids/blocs/dashboard/dashboard_state.dart';
import 'package:afro_grids/repositories/device_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState>{
  DashboardBloc(): super(InitialDashboardState()){
    on<FetchDashboardInfo>(_mapFetchDashboardInfoToState);

  }

  void _mapFetchDashboardInfoToState(DashboardEvent event, Emitter<DashboardState> emit) async {
    try{
      emit(DashboardLoadingState());
      var devicePosition = await DeviceRepo().determinePosition();
      emit(DashboardLoadedState(devicePosition: devicePosition));
    }catch(e){
      emit(DashboardErrorState(e.toString()));
    }
  }

}