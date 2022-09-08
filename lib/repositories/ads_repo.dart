import 'dart:io';

import 'package:afro_grids/configs/firestore_references.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../configs/firestorage_references.dart';
import '../models/ads_model.dart';

class AdsRepo{
  late final CollectionReference _adsRef;
  late final Reference _adsStorageRef;
  AdsModel? ads;
  AdsRepo({this.ads}):
        _adsRef = FirestoreRef().adsRef,
        _adsStorageRef = FirebaseStorageReferences()
            .adsRef;
  
  Future<List<AdsModel>> fetchAds() async {
    var querySnapshot = await _adsRef.orderBy('createdAt', descending: true).get();
    return querySnapshot
        .docs
        .map((doc)=>AdsModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  Future<String> uploadAdsFile(XFile file)async{
    var uploadTask = await _adsStorageRef
        .child("${file.name}/${DateTime.now().millisecondsSinceEpoch}.${file.name.split(".").removeLast()}")
        .putFile(File(file.path));
    var uploadURL = await uploadTask.ref.getDownloadURL();
    return uploadURL;
  }

  Future<void> addAds({required XFile file})async{
    ads!.fileURL = await uploadAdsFile(file);
    await _adsRef.add(ads!.toMap());
  }

  Future<void> deleteAds()async{
    await _adsRef.doc(ads!.id).delete();
    await FirebaseStorageReferences()
        .storageInstance
        .refFromURL(ads!.fileURL)
        .delete();
  }
}