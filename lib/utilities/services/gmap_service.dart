import 'dart:convert';
import 'dart:math' as math;

import 'package:afro_grids/models/geocodeResponse.dart';
import 'package:afro_grids/utilities/asset_resources.dart';
import 'package:afro_grids/utilities/credentials.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as g_map;
import 'package:http/http.dart' as http;

import '../../models/user/user_model.dart';


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

  static Future<Set<g_map.Marker>> getUsersMarker(List<UserModel> users, {void Function(UserModel user)? onTapAction})async{
    final mapIcon = await AssetResources().getGMapMarkerIcon();
    return users.map((user){
      return g_map.Marker(
          markerId: g_map.MarkerId(user.id),
          position: g_map.LatLng(
              user.location.latitude,
              user.location.longitude
          ),
        icon: g_map.BitmapDescriptor.fromBytes(mapIcon),
        onTap: (){
            if(onTapAction != null){
              onTapAction(user);
            }
        }
      );
    }).toSet();
  }

  static g_map.LatLngBounds boundsFromLatLngList(List<UserModel> users) {
    List<g_map.LatLng> list = users.map((user){
      return g_map.LatLng(
          user.location.latitude,
          user.location.longitude
      );
    }).toList();

    double? x0, x1, y0, y1;
    for (g_map.LatLng latLng in list) {
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
    return g_map.LatLngBounds(
        northeast: g_map.LatLng(x1!, y1!),
        southwest: g_map.LatLng(x0!, y0!)
    );
  }

  static double getDistanceInKM(double lat1, double lat2, double lng1, double lng2){
    const radius = 6367994.65; // for miles use 3956
    var radian = math.pi/180;
    lat1 = lat1 * radian;
    lat2 = lat2 * radian;
    lng1 = lng1 * radian;
    lng2 = lng2 * radian;
    var dLng = lng2 - lng1;
    var dLat = lat2 - lat1;
    var a = math.pow(math.sin(dLat/2), 2) + math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLng/2), 2);
    var c = 2 * math.asin(math.sqrt(a));
    return c * radius;
  }
}