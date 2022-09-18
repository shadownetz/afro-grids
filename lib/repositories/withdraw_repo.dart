import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/withdraw_model.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawRepo{
  WithdrawModel? withdrawModel;
  late final CollectionReference _withdrawRef;

  WithdrawRepo({this.withdrawModel}): _withdrawRef = FirestoreRef().withdrawalRef;

  Future<List<WithdrawModel>> fetchWithdrawalsByUser(String userId) async {
    var querySnaps = await _withdrawRef.where('createdBy', isEqualTo: userId).get();
    return querySnaps.docs.map((doc) =>
        WithdrawModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  Future<void> addWithdrawal() async {
    var queries = await _withdrawRef
        .where('createdBy', isEqualTo: withdrawModel!.createdBy)
        .where('status', isEqualTo: WithdrawalStatus.pending)
        .limit(1)
        .get();
    if(queries.docs.isNotEmpty){
      return Future.error("You already have a pending withdrawal request");
    }
    await _withdrawRef.add(withdrawModel!.toMap());
  }

}