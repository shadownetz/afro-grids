import 'dart:io';

import 'package:afro_grids/configs/firestorage_references.dart';
import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/main.dart';
import 'package:afro_grids/models/user_model.dart';
import 'package:afro_grids/repositories/auth_repo.dart';
import 'package:afro_grids/utilities/class_constants.dart';
import 'package:afro_grids/utilities/services/geofire_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image_picker/image_picker.dart';

import '../utilities/services/device_service.dart';

class UserRepo{
  final UserModel? _user;
  final CollectionReference _userRef;

  UserRepo({UserModel? user}):
        _user=user,
        _userRef = FirestoreRef().usersRef;

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
    var docSnapshot = await _userRef.doc(uid).get();
    return UserModel.fromFirestore(docSnapshot as DocumentSnapshot<Map<String, dynamic>>);
  }
  Future<UserModel?> getUserIfExist(String uid) async{
    UserModel? user;
    try{
      var docSnapshot = await _userRef.doc(uid).get();
      user = UserModel.fromFirestore(docSnapshot as DocumentSnapshot<Map<String, dynamic>>);
    }catch(e){
      debugPrint(e.toString());
    }
    return user;
  }

  void persistUser(){
    if(_user != null){
      localStorage.userListener = _userRef.doc(_user!.id).snapshots().listen((doc) {
        localStorage.user = UserModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      });
    }
  }

  Future<UserModel?> getUserByEmail(String email) async{
    var querySnapshot = await _userRef.where("email", isEqualTo: email).get();
    if(querySnapshot.docs.isNotEmpty){
      return UserModel.fromFirestore(querySnapshot.docs[0] as DocumentSnapshot<Map<String, dynamic>>);
    }
    return null;
  }

  Future<void> updateUser() async{
    _user!.updatedAt = DateTime.now();
    return await _userRef.doc(_user!.id).update(_user!.toMap());
  }

  Future<void> updatePassword(String newPassword) async{
    _user!.updatedAt = DateTime.now();
    return await AuthRepo().updatePassword(newPassword);
  }

  Future<void> updatePhone(String phone) async{
    _user!.updatedAt = DateTime.now();
    _user!.setPhone(phone);
    return await _userRef.doc(_user!.id).update(_user!.toMap());
  }

  Future<void> trySetLocation()async{
    try{
      final devicePosition = await DeviceService().determinePosition();
      _user!.setLocation(devicePosition.latitude, devicePosition.longitude);
    }catch(e){
      //
    }
  }

  setLocation(double lat, double lng){
    _user!.location = GeoFirePoint(lat, lng);
  }

  Future<List<UserModel>> fetchUsersByServiceID(String serviceID) async {
    var querySnapshot = await _userRef
        .where("serviceId", isEqualTo: serviceID)
        .where("accessStatus", isEqualTo: AccessStatus.approved)
        .get();
    return querySnapshot.docs.map((doc){
      return UserModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    }).toList();
  }

  Future<List<UserModel>> fetchNearbyProviders() async{
    GeoFirePoint userPos = localStorage.user!.location;
    try{
      var pos = await DeviceService().determinePosition();
      userPos = GeoFirePoint(pos.latitude, pos.longitude);
    }catch(e){
      debugPrint("Unable to determine user location: ${e.toString()}");
    }
    var users =  await GeoFireService().queryWithin(
        center: userPos,
        reference: _userRef,
        fieldName: "location",
        radius: 100000  // TODO: remove this line
    );
    return users
        .map((user) =>
        UserModel.fromFirestore(user as DocumentSnapshot<Map<String, dynamic>>))
        .where((user) => user.isProvider)
        .toList();

  }

}