import 'package:afro_grids/blocs/report/report_event.dart';
import 'package:afro_grids/blocs/report/report_state.dart';
import 'package:afro_grids/repositories/report_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState>{

  ReportBloc(): super(ReportInitialState()){
    on<AddReportEvent>(_onAddReportEvent);
  }

  void _onAddReportEvent(AddReportEvent event, Emitter<ReportState> emit)async{
    emit(ReportLoadingState());
    try{
      await ReportRepo(report: event.report).addReport();
      emit(ReportLoadedState());
    }catch(e){
      emit(ReportErrorState(e.toString()));
    }
  }
}