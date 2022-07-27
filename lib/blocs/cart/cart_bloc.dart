import 'package:afro_grids/blocs/cart/cart_event.dart';
import 'package:afro_grids/blocs/cart/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState>{

  CartBloc(): super(CartInitialState()){
    on<AddCheckoutEvent>(_mapCheckOutStateToEvent);
  }

  void _mapCheckOutStateToEvent(CartEvent event, Emitter<CartState> emit){
    emit(CartCheckedOutState());
  }


}