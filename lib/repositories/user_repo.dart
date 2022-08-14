import 'dart:io';

import 'package:afro_grids/configs/firestorage_references.dart';
import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UserRepo{
  final UserModel? _user;

  UserRepo({UserModel? user}): _user=user;

  addUser({XFile? avatar})async{
    if(avatar != null){
      var uploadTask = await FirebaseStorageReferences()
          .avatarRef
          .child("${_user!.id}/${DateTime.now().millisecondsSinceEpoch}${avatar.name.split(".").removeLast()}")
          .putFile(File(avatar.path));
      _user!.avatar = await uploadTask.ref.getDownloadURL();
    }
    return await FirestoreRef().usersRef.doc(_user!.id).set(_user!.toMap());
  }

  Future<UserModel> getUser(String uid) async{
    var docSnapshot = await FirestoreRef().usersRef.doc(uid).get();
    return UserModel.fromFirestore(docSnapshot as DocumentSnapshot<Map<String, dynamic>>);
  }

  Future<void> updateUser() async{
    _user!.updatedAt = DateTime.now();
    return await FirestoreRef().usersRef.doc(_user!.id).update(_user!.toMap());
  }




}