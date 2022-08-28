
import 'package:afro_grids/blocs/order/order_state.dart';
import 'package:afro_grids/repositories/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_event.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState>{

  OrderBloc(): super(OrderInitialState()){
    on<FetchUserOrders>(_onFetchUserOrders);
    on<FetchNextUserOrders>(_onFetchNextUserOrders);
  }

  void _onFetchUserOrders(FetchUserOrders event, Emitter<OrderState> emit)async{
    emit(OrderLoadingState());
    try{
      var orders = await OrderRepo().fetchOrdersByUser(userId: event.user.id, limit: 25);
      emit(OrderLoadedState(userOrders: orders));
    }catch(e){
      emit(OrderErrorState(e.toString()));
    }
  }

  void _onFetchNextUserOrders(FetchNextUserOrders event, Emitter<OrderState> emit) async{
    try{
      var orders = await OrderRepo().fetchOrdersByUser(
          userId: event.user.id,
          limit: 25,
          cursor: event.cursor.snapshot
      );
      emit(OrderLoadedState(userOrders: orders));
    }catch(e){
      emit(OrderErrorState(e.toString()));
    }
  }
}