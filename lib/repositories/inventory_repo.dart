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

  Future<InventoryModel?> getInventory(String inventoryId)async{
    var snapshot = await _inventoryRef.doc(inventoryId).get();
    if(snapshot.exists){
      return InventoryModel.fromFirestore(snapshot as DocumentSnapshot<Map<String, dynamic>>);
    }
    return null;
  }

  Future<InventoryModel> addInventory()async{
    var ref = await _inventoryRef.add(_inventory?.toMap());
    _inventory!.id = ref.id;
    return _inventory!;
  }

  Future<void> updateInventory()async{
    assert(_inventory!=null, "An inventory object must be provided before making update action");
    if(_inventory!.id.isEmpty){
      await addInventory();
    }else{
      return _inventoryRef.doc(_inventory!.id).update(_inventory!.toMap());
    }
  }

  Future<void> softDeleteInventory()async{
    _inventory!.visible = false;
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
    if(_inventory != null){
      if(_inventory!.images.isNotEmpty){
        _inventory!.images.addAll(uploadURLS);
      }else{
        _inventory!.images = uploadURLS;
      }
    }
    return uploadURLS;
  }

  Future<void> deleteImages(List<String> images)async{
    var promises = images.map((image){
      return FirebaseStorageReferences().storageInstance.refFromURL(image).delete();
    });
    await Future.wait(promises);
    if(_inventory != null){
      _inventory!.images = _inventory!.images.where((image) => !images.contains(image)).toList();
    }
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