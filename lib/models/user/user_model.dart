import 'package:afro_grids/utilities/class_constants.dart';
import 'package:afro_grids/utilities/services/gmap_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import '../../utilities/currency.dart';
import '../model_types.dart';

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
  late String address;
  late GeoFirePoint location;
  late DateTime createdAt;
  late DateTime updatedAt;
  late String serviceId;
  late String serviceType; // ServiceType values
  late Reviews reviews;
  late String accessStatus; // AccessStatus values
  late Set<String> favorites;
  late String avatar;
  late bool phoneVerified;
  late bool emailVerified;
  late String deliveryAddress;
  late num outstandingBalance;
  late num availableBalance;


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
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceId,
    required this.serviceType,
    required this.reviews,
    required this.accessStatus,
    required this.favorites,
    required this.avatar,
    this.phoneVerified=false,
    this.emailVerified=false,
    this.deliveryAddress="",
    this.outstandingBalance=0,
    this.availableBalance=0
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
        address = user.data()!['address']?? "",
        location = GeoFirePoint(user.data()!['location']['geopoint'].latitude, user.data()!['location']['geopoint'].longitude),
        createdAt = user.data()!['createdAt'].toDate(),
        updatedAt = user.data()!['updatedAt'].toDate(),
        serviceId = user.data()!['serviceId'],
        serviceType = user.data()!['serviceType'],
        accessStatus = user.data()!['accessStatus'],
        reviews = Reviews(user.data()!['reviews']['total'], user.data()!['reviews']['count'], user.data()!['reviews']['average']),
        favorites = Set<String>.from(user.data()!['favorites']),
        emailVerified = user.data()!['emailVerified'],
        phoneVerified = user.data()!['phoneVerified'],
        deliveryAddress = user.data()!['deliveryAddress']??"",
        outstandingBalance = user.data()!['outstandingBalance']??0,
        availableBalance = user.data()!['availableBalance']??0;

  UserModel.providerInstance():
        id = "",
        firstName = "",
        lastName = "",
        middleName = "",
        avatar = "",
        email = "",
        phone = "",
        authType = AuthType.email,
        accessLevel = AccessLevel.provider,
        currency = CurrencyUtil().currencyName,
        address = "",
        location = GeoFirePoint(6.465422, 3.406448),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        serviceId = "",
        serviceType = ServiceType.multiple,
        reviews = Reviews(0, 0, 0),
        accessStatus = AccessStatus.pending,
        favorites = {},
        emailVerified = false,
        phoneVerified = false,
        deliveryAddress="",
        outstandingBalance = 0,
        availableBalance = 0;

  UserModel.userInstance():
        id = "",
        firstName = "",
        lastName = "",
        middleName = "",
        avatar = "",
        email = "",
        phone = "",
        authType = AuthType.email,
        accessLevel = AccessLevel.user,
        currency = CurrencyUtil().currencyName,
        address = "",
        location = GeoFirePoint(6.465422, 3.406448),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        serviceId = "",
        serviceType = ServiceType.single,
        reviews = Reviews(0, 0, 0),
        accessStatus = AccessStatus.approved,
        favorites = {},
        emailVerified = false,
        phoneVerified = false,
        deliveryAddress="",
        outstandingBalance = 0,
        availableBalance = 0;

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
    'address': address,
    'location': location.data,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
    'serviceId': serviceId,
    'serviceType': serviceType,
    'ratings': reviews.toMap(),
    'accessStatus': accessStatus,
    'reviews': reviews.toMap(),
    'favorites': favorites.toList(),
    'emailVerified': emailVerified,
    'phoneVerified': phoneVerified,
    'deliveryAddress': deliveryAddress,
    "outstandingBalance" : outstandingBalance,
    "availableBalance" : availableBalance
  };
  }

  UserModel.copyWith(UserModel user):
        id = user.id,
        firstName = user.firstName,
        lastName = user.lastName,
        middleName = user.middleName,
        email = user.email,
        phone = user.phone,
        authType = user.authType,
        accessLevel = user.accessLevel,
        currency = user.currency,
        location = user.location,
        address = user.address,
        createdAt = user.createdAt,
        updatedAt = user.updatedAt,
        serviceId = user.serviceId,
        serviceType = user.serviceType,
        reviews = user.reviews,
        accessStatus = user.accessStatus,
        favorites = user.favorites,
        avatar = user.avatar,
        phoneVerified = user.phoneVerified,
        emailVerified = user.emailVerified,
        deliveryAddress = user.deliveryAddress,
        outstandingBalance = user.outstandingBalance,
        availableBalance = user.availableBalance;

  String get name{
    return "$firstName $lastName";
  }

  bool get isProvider{
    return accessLevel == AccessLevel.provider;
  }
  bool get isApproved{
    return accessStatus == AccessStatus.approved;
  }

  setLocation(double lat, double lng){
    location = GeoFirePoint(lat, lng);
  }
  setAvatar(String? url){
    avatar = url ?? "";
  }
  setPhone(String? phoneNum){
    phone = phoneNum ?? "";
  }

  double distanceFrom(GeoFirePoint position, [String unit='KM']){
    return GMapService.getDistanceInKM(
        location.latitude,
        position.latitude,
        location.longitude,
        position.longitude
    );
  }

  bool isFavorite(String userId){
    return favorites.contains(userId);
  }
}
