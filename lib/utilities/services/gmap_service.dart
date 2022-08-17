import 'dart:convert';

import 'package:afro_grids/models/geocodeResponse.dart';
import 'package:afro_grids/utilities/asset_resources.dart';
import 'package:afro_grids/utilities/credentials.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GMap;
import 'package:http/http.dart' as http;

import '../../models/user_model.dart';


class GMapService{
  late String geocodeAPIKey;
  GMapService():
      geocodeAPIKey = Credentials.gGeocodingKey;


  Future<GeocodeResponse?> getAddressFromPlaceId(String placeId) async {
    GeocodeResponse? result;
    final response = await http.get(
      Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=$geocodeAPIKey")
    );
    if(response.statusCode == 200){
      var decoded = json.decode(response.body)['results'];
      if(decoded.isNotEmpty){
        result = GeocodeResponse.fromJSON(decoded[0]);
      }
    }
    return result;
  }

  static Future<Set<GMap.Marker>> getUsersMarker(List<UserModel> users)async{
    final mapIcon = await AssetResources().gMapMarkerIcon();
    return users.map((user){
      return GMap.Marker(
          markerId: GMap.MarkerId(user.id),
          position: GMap.LatLng(
              user.location.latitude,
              user.location.longitude
          ),
        icon: GMap.BitmapDescriptor.fromBytes(mapIcon)
      );
    }).toSet();
  }

  static GMap.LatLngBounds boundsFromLatLngList(List<UserModel> users) {
    List<GMap.LatLng> list = users.map((user){
      return GMap.LatLng(
          user.location.latitude,
          user.location.longitude
      );
    }).toList();

    double? x0, x1, y0, y1;
    for (GMap.LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return GMap.LatLngBounds(
        northeast: GMap.LatLng(x1!, y1!),
        southwest: GMap.LatLng(x0!, y0!)
    );
  }

}