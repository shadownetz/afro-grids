import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class GeoFireService{
  late Geoflutterfire geo;
  late FirebaseFirestore _firestore;
  GeoFireService():
        geo = Geoflutterfire(),
        _firestore = FirebaseFirestore.instance;
}