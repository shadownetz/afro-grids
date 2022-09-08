import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageReferences{
  final _storageRef = FirebaseStorage.instance.ref();

  FirebaseStorage get storageInstance{
    return FirebaseStorage.instance;
  }

  Reference get avatarRef{
    return _storageRef.child("users/avatars");
  }

  Reference get inventoryImageRef{
    return _storageRef.child("inventories/itemImages");
  }

  Reference get chatRef{
    return _storageRef.child("chats/files");
  }

  Reference get adsRef{
    return _storageRef.child("ads/files");
  }
}