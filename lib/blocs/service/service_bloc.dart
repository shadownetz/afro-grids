import 'package:afro_grids/blocs/service/service_event.dart';
import 'package:afro_grids/blocs/service/service_state.dart';
import 'package:afro_grids/models/service_model.dart';
import 'package:afro_grids/repositories/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/service_repo.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState>{
  ServiceBloc(): super(ServiceInitialState()){
    on<FetchServiceEvent>(_mapFetchServiceEventToEvent);
    on<AddServiceEvent>(_mapAddServiceEventToEvent);
    on<FetchServiceProvidersEvent>(_mapFetchServiceProvidersToEvent);
  }

  void _mapFetchServiceEventToEvent(FetchServiceEvent event, Emitter<ServiceState> emit)async{
    emit(ServiceLoadingState());
    try{
      List<ServiceModel> services;
      if(event.serviceCategoryId != null){
        services = await ServiceRepo().fetchServices(event.serviceCategoryId!);
      }else{
        services = await ServiceRepo().fetchAllServices();
      }
      emit(ServiceLoadedState(services: services));
    }catch(e){
      emit(ServiceErrorState(e.toString()));
    }
  }

  void _mapAddServiceEventToEvent(AddServiceEvent event, Emitter<ServiceState> emit) async{
    emit(ServiceLoadingState());
    try{
      await ServiceRepo(service: event.service).addService();
      emit(ServiceLoadedState());
    }catch(e){
      emit(ServiceErrorState(e.toString()));
    }
  }
  
  void _mapFetchServiceProvidersToEvent(FetchServiceProvidersEvent event, Emitter<ServiceState> emit)async{
    emit(ServiceLoadingState());
    try{
      var users = await UserRepo().fetchUsersByServiceID(event.service.id);
      emit(FetchedServiceProvidersState(users));
    }catch(e){
      emit(ServiceErrorState(e.toString()));
    }
  }
}