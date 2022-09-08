import 'package:equatable/equatable.dart';

import '../../models/ads_model.dart';

abstract class AdsState extends Equatable{
  @override
  List<Object?> get props => [];
}

class AdsInitialState extends AdsState{}

class AdsLoadingState extends AdsState{}

class AdsLoadedState extends AdsState{
  final List<AdsModel>? adsList;
  final AdsModel? ads;
  AdsLoadedState({this.adsList, this.ads});
}

class AdsUpdatedState extends AdsState{}


class AdsErrorState extends AdsState{
  final String message;
  AdsErrorState(this.message);
}