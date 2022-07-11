import 'package:cloud_firestore/cloud_firestore.dart';

import '../utilities/class_constants.dart';
import '../utilities/custom_types.dart';

class UserModel{
  late String id;
  late String firstName;
  late String lastName;
  late String middleName;
  late String email;
  late String phone;
  late AuthType authType;
  late AccessLevel accessLevel;
  late Currency currency;
  late GeoPoint location;
  late DateTime createdAt;
  late DateTime updatedAt;
  late String serviceId;
  late ServiceType serviceType;
  late Ratings ratings;
  late AccessStatus accessStatus;
  late Reviews reviews;
  late List<String> favorites;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.phone,
    required this.authType,
    required this.accessLevel,
    required this.currency,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceId,
    required this.serviceType,
    required this.ratings,
    required this.accessStatus,
    required this.reviews,
    required this.favorites
  });

  UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> user):
        id = user.id,
        firstName = user.data()!['firstName'],
        lastName = user.data()!['lastName'],
        middleName = user.data()!['middleName'],
        email = user.data()!['email'],
        phone = user.data()!['phone'],
        authType = user.data()!['authType'],
        accessLevel = user.data()!['accessLevel'],
        currency = user.data()!['currency'],
        location = user.data()!['location'],
        createdAt = user.data()!['createdAt'].toDate(),
        updatedAt = user.data()!['updatedAt'].toDate(),
        serviceId = user.data()!['serviceId'],
        serviceType = user.data()!['serviceType'],
        ratings = user.data()!['ratings'],
        accessStatus = user.data()!['accessStatus'],
        reviews = user.data()!['reviews'],
        favorites = user.data()!['favorites'];

  Map<String, dynamic> toMap(){
    return {
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'email': email,
      'phone': phone,
      'authType': authType,
      'accessLevel': accessLevel,
      'currency': currency,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'serviceId': serviceId,
      'serviceType': serviceType,
      'ratings': ratings,
      'accessStatus': accessStatus,
      'reviews': reviews,
      'favorites': favorites
    };
  }
}
