import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageReferences{
  final _storageRef = FirebaseStorage.instance.ref();

  Reference get avatarRef{
    return _storageRef.child("users/avatars");
  }

  Reference get inventoryImageRef{
    return _storageRef.child("inventories/itemImages");
  }
}