import 'package:afro_grids/blocs/delivery/delivery_event.dart';
import 'package:afro_grids/repositories/delivery_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'delivery_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState>{

  DeliveryBloc(): super(DeliveryInitialState()){
    on<FetchProviderDeliveriesEvent>(_onFetchProviderDeliveriesEvent);
    on<FetchNextProviderDeliveriesEvent>(_onFetchNextProviderDeliveriesEvent);
    on<UpdateDeliveryEvent>(_onUpdateDeliveryEvent);
  }

  void _onFetchProviderDeliveriesEvent(FetchProviderDeliveriesEvent event, Emitter<DeliveryState> emit)async{
    emit(DeliveryLoadingState());
    try{
      final deliveries = await DeliveryRepo().fetchProviderDeliveries(
        providerId: event.provider.id,
        limit: event.limit??25,
      );
      emit(DeliveryLoadedState(deliveries: deliveries));
    }catch(e){
      emit(DeliveryErrorState(e.toString()));
    }
  }

  void _onFetchNextProviderDeliveriesEvent(FetchNextProviderDeliveriesEvent event, Emitter<DeliveryState> emit)async{
    emit(DeliveryLoadingState());
    try{
      final deliveries = await DeliveryRepo().fetchProviderDeliveries(
        providerId: event.provider.id,
        limit: 25,
        cursor: event.cursor.snapshot,
      );
      emit(DeliveryLoadedState(deliveries: deliveries));
    }catch(e){
      emit(DeliveryErrorState(e.toString()));
    }
  }

  void _onUpdateDeliveryEvent(UpdateDeliveryEvent event, Emitter<DeliveryState> emit) async {
    emit(DeliveryLoadingState());
    try{
      await DeliveryRepo(deliveryModel: event.delivery).updateDelivery();
      emit(DeliveryUpdatedState());
    }catch(e){
      emit(DeliveryErrorState(e.toString()));
    }
  }
}