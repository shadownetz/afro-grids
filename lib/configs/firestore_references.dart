import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRef{
  final _db = FirebaseFirestore.instance;

  CollectionReference get usersRef{
    return _db.collection("users");
  }
  CollectionReference get cartRef{
    return _db.collection("carts");
  }
  CollectionReference get inventoryRef{
    return _db.collection("inventories");
  }
  CollectionReference get chatRef{
    return _db.collection("chats");
  }
  CollectionReference get orderRef{
    return _db.collection("orders");
  }
  CollectionReference get reviewRef{
    return _db.collection("reviews");
  }
  CollectionReference get serviceCategoryRef{
    return _db.collection("serviceCategories");
  }
  CollectionReference get serviceRef{
    return _db.collection("services");
  }
  CollectionReference get usersMetaRef{
    return _db.collection("usersMeta");
  }
}