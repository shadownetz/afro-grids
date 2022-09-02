import 'package:afro_grids/models/report_model.dart';
import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class AddReportEvent extends ReportEvent{
  final ReportModel report;
  AddReportEvent({required this.report});
}