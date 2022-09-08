import 'package:cloud_firestore/cloud_firestore.dart';

class AdsModel{
  late String id;
  late String fileURL;
  late DateTime createdAt;
  late DateTime expireAt;
  late String name;
  late String createdBy;
  late String vendorName;
  late String vendorLink;

  AdsModel({
    required this.id,
    required this.fileURL,
    required this.createdAt,
    required this.expireAt,
    required this.name,
    required this.createdBy,
    required this.vendorName,
    required this.vendorLink
  });

  AdsModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> ads):
        id = ads.id,
        fileURL = ads.data()!['fileURL'],
        createdAt = ads.data()!['createdAt'].toDate(),
        expireAt = ads.data()!['expireAt'].toDate(),
        name = ads.data()!['name'],
        vendorName = ads.data()!['vendorName'],
        createdBy = ads.data()!['createdBy'],
        vendorLink = ads.data()!['vendorLink'];

  Map<String, dynamic> toMap(){
    return {
      'fileURL': fileURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'expireAt': Timestamp.fromDate(expireAt),
      'name': name,
      'createdBy': createdBy,
      'vendorName': vendorName,
      'vendorLink': vendorLink
    };
  }

}