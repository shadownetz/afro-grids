import 'dart:io';

import 'package:afro_grids/configs/firestorage_references.dart';
import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../utilities/services/device_service.dart';

class UserRepo{
  final UserModel? _user;

  UserRepo({UserModel? user}): _user=user;

  Future<UserModel> addUser()async{
    await FirestoreRef().usersRef.doc(_user!.id).set(_user!.toMap());
    return _user!;
  }

  /// Uploads user profile image.
  /// Returns the image url and sets the user profile image if user model is
  /// contained in the repository's instance
  Future<String> uploadAvatar(XFile avatar)async{
    var uploadTask = await FirebaseStorageReferences()
        .avatarRef
        .child("${_user!.id}/${DateTime.now().millisecondsSinceEpoch}.${avatar.name.split(".").removeLast()}")
        .putFile(File(avatar.path));
    var uploadURL = await uploadTask.ref.getDownloadURL();
    if(_user != null){
      _user!.avatar = uploadURL;
    }
    return uploadURL;
  }

  Future<UserModel> getUser(String uid) async{
    var docSnapshot = await FirestoreRef().usersRef.doc(uid).get();
    return UserModel.fromFirestore(docSnapshot as DocumentSnapshot<Map<String, dynamic>>);
  }

  Future<UserModel?> getUserByEmail(String email) async{
    var querySnapshot = await FirestoreRef().usersRef.where("email", isEqualTo: email).get();
    if(querySnapshot.docs.isNotEmpty){
      return UserModel.fromFirestore(querySnapshot.docs[0] as DocumentSnapshot<Map<String, dynamic>>);
    }
    return null;
  }

  Future<void> updateUser() async{
    _user!.updatedAt = DateTime.now();
    return await FirestoreRef().usersRef.doc(_user!.id).update(_user!.toMap());
  }

  Future<void> updatePhone(String phone) async{
    _user!.updatedAt = DateTime.now();
    _user!.setPhone(phone);
    return await FirestoreRef().usersRef.doc(_user!.id).update(_user!.toMap());
  }

  Future<void> trySetLocation()async{
    try{
      final devicePosition = await DeviceService().determinePosition();
      _user!.setLocation(devicePosition.latitude, devicePosition.longitude);
    }catch(e){
      //
    }
  }

  Future<List<UserModel>> fetchUsersByServiceID(String serviceID) async {
    var querySnapshot = await FirestoreRef().usersRef
        .where("serviceId", isEqualTo: serviceID)
        .where("accessStatus", isEqualTo: AccessStatus.approved)
        .get();
    return querySnapshot.docs.map((doc){
      return UserModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    }).toList();
  }






}