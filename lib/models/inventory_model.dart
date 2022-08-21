import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryModel{
  late String id;
  late String createdBy;
  late DateTime createdAt;
  late String name;
  late num price;
  late String currency;
  late String description;
  late List<String> images;
  late bool visible;

  InventoryModel({
    required this.id,
    required this.createdBy,
    required this.createdAt,
    required this.name,
    required this.price,
    required this.currency,
    required this.description,
    required this.images,
    required this.visible
  });

  InventoryModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> inventory):
        id = inventory.id,
        createdBy = inventory.data()!['createdBy'],
        createdAt = inventory.data()!['createdAt'].toDate(),
        name = inventory.data()!['name'],
        price = inventory.data()!['price'],
        currency = inventory.data()!['currency'],
        description = inventory.data()!['description'],
        images = List<String>.from(inventory.data()!['images']),
        visible = inventory.data()!['visible'];

  Map<String, dynamic> toMap(){
    return {
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'name': name,
      'price': price,
      'currency': currency,
      'description': description,
      'images': images,
      'visible': visible
    };
  }
}