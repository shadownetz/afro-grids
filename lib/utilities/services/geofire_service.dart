import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class GeoFireService{
  late Geoflutterfire geo;
  GeoFireService():
        geo = Geoflutterfire();

  Future<List<DocumentSnapshot>> queryWithin({
    required GeoFirePoint center,
    required CollectionReference reference,
    required String fieldName,
    double radius=50
  }) async {
    return geo.collection(collectionRef: reference)
        .within(center: center, radius: radius, field: fieldName)
        .first;
  }
}