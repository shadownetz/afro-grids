import 'package:afro_grids/blocs/inventory/inventory_event.dart';
import 'package:afro_grids/blocs/inventory/inventory_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState>{

  InventoryBloc(): super(InventoryInitialState()){
    //
  }


}