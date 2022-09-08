import 'package:afro_grids/models/ads_model.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class AdsEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class FetchAdsEvent extends AdsEvent{}

class AddAdsEvent extends AdsEvent{
  final AdsModel ads;
  final XFile file;
  AddAdsEvent({required this.ads, required this.file});
}

class RemoveAdsEvent extends AdsEvent{
  final AdsModel ads;
  RemoveAdsEvent({required this.ads});
}
