import 'package:afro_grids/blocs/cart/cart_event.dart';
import 'package:afro_grids/blocs/cart/cart_state.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/repositories/cart_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState>{

  CartBloc(): super(CartInitialState()){
    on<AddCheckoutEvent>(_mapCheckOutStateToEvent);
    on<AddToCartEvent>(_mapAddToCartEventToEvent);
    on<GetCartEvent>(_mapGetCartEventToEvent);
    on<RemoveFromCartEvent>(_mapRemoveFromCartEventToEvent);
    on<ReduceItemCountEvent>(_mapReduceItemCountEventToEvent);
  }

  void _mapCheckOutStateToEvent(CartEvent event, Emitter<CartState> emit){
    emit(CartCheckedOutState());
  }

  void _mapGetCartEventToEvent(GetCartEvent event, Emitter<CartState> emit)async{
    emit(CartLoadingState());
    try{
      var cart = await CartRepo().getCart(event.user.id);
      if(cart != null){
        localStorage.cart = cart;
      }else{
        localStorage.cart.id = localStorage.user!.id;
      }
      emit(CartLoadedState());
    }catch(e){
      emit(CartErrorState(e.toString()));
    }
  }

  void _mapAddToCartEventToEvent(AddToCartEvent event, Emitter<CartState> emit)async{
    emit(CartLoadingState());
    try{
      localStorage.addItemToCart(event.cartItem);
      await CartRepo().addToCart(localStorage.cart);
      emit(CartLoadedState());
    }catch(e){
      localStorage.removeItemFromCart(event.cartItem);
      emit(CartErrorState(e.toString()));
    }
  }

  void _mapRemoveFromCartEventToEvent(RemoveFromCartEvent event, Emitter<CartState> emit)async{
    emit(CartLoadingState());
    try{
      localStorage.removeItemFromCart(event.cartItem);
      await CartRepo().addToCart(localStorage.cart);
      emit(CartLoadedState());
    }catch(e){
      localStorage.addItemToCart(event.cartItem);
      emit(CartErrorState(e.toString()));
    }
  }

  void _mapReduceItemCountEventToEvent(ReduceItemCountEvent event, Emitter<CartState> emit)async{
    emit(CartLoadingState());
    try{
      localStorage.reduceItemFromCart(event.cartItem);
      await CartRepo().addToCart(localStorage.cart);
      emit(CartLoadedState());
    }catch(e){
      localStorage.addItemToCart(event.cartItem);
      emit(CartErrorState(e.toString()));
    }
  }


}