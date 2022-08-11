import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepo{
  final UserModel? _user;

  UserRepo({UserModel? user}): _user=user;

  addUser()async{
    return await FirestoreRef().usersRef.doc(_user!.id).set(_user!.toMap());
  }

  Future<UserModel> getUser(String uid) async{
    var docSnapshot = await FirestoreRef().usersRef.doc(uid).get();
    return UserModel.fromFirestore(docSnapshot as DocumentSnapshot<Map<String, dynamic>>);
  }

  Future<void> updateUser() async{
    return await FirestoreRef().usersRef.doc(_user!.id).update(_user!.toMap());
  }




}