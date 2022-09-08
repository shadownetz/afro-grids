import 'package:afro_grids/blocs/ads/ads_event.dart';
import 'package:afro_grids/blocs/ads/ads_state.dart';
import 'package:afro_grids/repositories/ads_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState>{
  AdsBloc(): super(AdsInitialState()){
    on<FetchAdsEvent>(_onFetchAdsEvent);
    on<AddAdsEvent>(_onAddAdsEvent);
    on<RemoveAdsEvent>(_onRemoveAdsEvent);
  }

  void _onFetchAdsEvent(FetchAdsEvent event, Emitter<AdsState> emit)async{
    emit(AdsLoadingState());
    try{
      var ads = await AdsRepo().fetchAds();
      emit(AdsLoadedState(adsList: ads));
    }catch(e){
      emit(AdsErrorState(e.toString()));
    }
  }

  void _onAddAdsEvent(AddAdsEvent event, Emitter<AdsState> emit) async{
    emit(AdsLoadingState());
    try{
      await AdsRepo(ads: event.ads).addAds(file: event.file);
      emit(AdsLoadedState());
    }catch(e){
      emit(AdsErrorState(e.toString()));
    }
  }

  void _onRemoveAdsEvent(RemoveAdsEvent event, Emitter<AdsState> emit) async{
    emit(AdsLoadingState());
    try{
      await AdsRepo(ads: event.ads).deleteAds();
      emit(AdsUpdatedState());
    }catch(e){
      emit(AdsErrorState(e.toString()));
    }
  }
}