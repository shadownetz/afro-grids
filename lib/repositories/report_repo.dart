import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/report_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportRepo{
  late final CollectionReference _reportRef;
  ReportModel? report;

  ReportRepo({this.report}): _reportRef = FirestoreRef().reportRef;

  Future<void> addReport()async{
    await  _reportRef.add(report!.toMap());
  }

}