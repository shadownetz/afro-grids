import 'package:afro_grids/blocs/review/review_event.dart';
import 'package:afro_grids/blocs/review/review_state.dart';
import 'package:afro_grids/models/local/local_review_model.dart';
import 'package:afro_grids/repositories/review_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState>{

  ReviewBloc(): super(ReviewInitialState()){
    on<AddReviewEvent>(_mapAddReviewEventToEvent);
    on<FetchReviewsEvent>(_mapFetchReviewsEventToState);
  }

  void _mapAddReviewEventToEvent(AddReviewEvent event, Emitter<ReviewState> emit)async{
    emit(ReviewLoadingState());
    try{
      await ReviewRepo(review: event.review).addReview();
      emit(ReviewLoadedState());
    }catch(e){
      emit(ReviewErrorState(e.toString()));
    }
  }

  void _mapFetchReviewsEventToState(FetchReviewsEvent event, Emitter<ReviewState> emit)async{
    emit(ReviewLoadingState());
    try{
      List<LocalReviewModel> reviews;
      if(event.withMetaInfo){
        reviews = await ReviewRepo().fetchProviderReviewsWithMeta(event.provider.id);
      }else{
        reviews = await ReviewRepo().fetchProviderReviews(event.provider.id);
      }
      emit(ReviewLoadedState(reviews: reviews));
    }catch(e){
      emit(ReviewErrorState(e.toString()));
    }
  }

}