import 'package:afro_grids/blocs/serviceCategory/service_category_event.dart';
import 'package:afro_grids/blocs/serviceCategory/service_category_state.dart';
import 'package:afro_grids/repositories/service_category_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceCategoryBloc extends Bloc<ServiceCategoryEvent, ServiceCategoryState>{
  ServiceCategoryBloc(): super(ServiceCategoryInitialState()){
    on<FetchServiceCategoryEvent>(_mapFetchServiceCategoryEventToEvent);
  }

  void _mapFetchServiceCategoryEventToEvent(FetchServiceCategoryEvent event, Emitter<ServiceCategoryState> emit)async{
    emit(ServiceCategoryLoadingState());
    try{
      var serviceCategories = await ServiceCategoryRepo().fetchServiceCategories();
      emit(ServiceCategoryLoadedState(serviceCategories: serviceCategories));
    }catch(e){
      emit(ServiceCategoryErrorState(e.toString()));
    }
  }
}