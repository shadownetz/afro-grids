import 'dart:io';

import 'package:afro_grids/configs/firestore_references.dart';
import 'package:afro_grids/models/inventory_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../configs/firestorage_references.dart';

class InventoryRepo{
  final InventoryModel? _inventory;
  final CollectionReference _inventoryRef;
  InventoryRepo({InventoryModel? inventory}):
        _inventory = inventory,
        _inventoryRef = FirestoreRef().inventoryRef;

  Future<InventoryModel> addInventory()async{
    var ref = await _inventoryRef.add(_inventory?.toMap());
    _inventory!.id = ref.id;
    return _inventory!;
  }

  Future<void> updateInventory()async{
    return _inventoryRef.doc(_inventory!.id).update(_inventory!.toMap());
  }

  Future<List<String>> uploadImages(List<XFile> images)async{
    var uploadTasksPromises = images.map((imageFile){
      return FirebaseStorageReferences()
          .inventoryImageRef
          .child("${_inventory!.id.isNotEmpty?_inventory!.id: 'new'}/${DateTime.now().millisecondsSinceEpoch}.${imageFile.name.split(".").removeLast()}")
          .putFile(File(imageFile.path));
    });
    var uploadTaskSnapshots = await Future.wait(
      uploadTasksPromises,
      eagerError: true,
      cleanUp: (TaskSnapshot taskSnapshot)async{
        await taskSnapshot.ref.delete();
      }
    );
    var uploadURLS = await Future.wait(uploadTaskSnapshots.map((taskSnapshot){
      return taskSnapshot.ref.getDownloadURL();
    }));
    _inventory!.images = uploadURLS;
    return uploadURLS;
  }

  Future<List<InventoryModel>> fetchProviderItems(String providerId)async{
    var querySnapshot = await _inventoryRef
        .where("createdBy", isEqualTo: providerId)
        .where("visible", isEqualTo: true)
        .get();
    return querySnapshot.docs.map((doc){
      return InventoryModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    }).toList();
  }
}