import 'package:afro_grids/utilities/class_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'model_types.dart';

class UserModel{
  late String id;
  late String firstName;
  late String lastName;
  late String middleName;
  late String email;
  late String phone;
  late String authType; // AuthType values
  late String accessLevel; // AccessLevel values
  late String currency; // Currency values
  late GeoFirePoint location;
  late DateTime createdAt;
  late DateTime updatedAt;
  late String serviceId;
  late String serviceType; // ServiceType values
  late Ratings ratings;
  late String accessStatus; // AccessStatus values
  late Reviews reviews;
  late List<String> favorites;
  late String avatar;
  late bool phoneVerified;
  late bool emailVerified;

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
    required this.favorites,
    required this.avatar,
    this.phoneVerified=false,
    this.emailVerified=false,
  });

  UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> user):
        id = user.id,
        firstName = user.data()!['firstName'],
        lastName = user.data()!['lastName'],
        middleName = user.data()!['middleName'],
        avatar = user.data()!['avatar'],
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
        favorites = user.data()!['favorites'],
        emailVerified = user.data()!['emailVerified'],
        phoneVerified = user.data()!['phoneVerified'];

  Map<String, dynamic> toMap(){
    return {
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'avatar': avatar,
      'email': email,
      'phone': phone,
      'authType': authType,
      'accessLevel': accessLevel,
      'currency': currency,
      'location': location.data,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'serviceId': serviceId,
      'serviceType': serviceType,
      'ratings': ratings.toMap(),
      'accessStatus': accessStatus,
      'reviews': reviews.toMap(),
      'favorites': favorites,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
    };
  }

  bool get isProvider{
    return accessLevel == AccessLevel.provider;
  }
}
