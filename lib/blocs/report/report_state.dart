import 'package:equatable/equatable.dart';

abstract class ReportState extends Equatable{
  @override
  List<Object?> get props => [];
}

class ReportInitialState extends ReportState{}

class ReportLoadingState extends ReportState{}

class ReportLoadedState extends ReportState{}

class ReportErrorState extends ReportState{
  final String message;
  ReportErrorState(this.message);
}