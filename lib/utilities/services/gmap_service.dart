import 'dart:convert';

import 'package:afro_grids/models/geocodeResponse.dart';
import 'package:afro_grids/utilities/credentials.dart';
import 'package:http/http.dart' as http;


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
      List<Map<String, dynamic>> decoded = json.decode(response.body)['results'];
      if(decoded.isNotEmpty){
        result = GeocodeResponse.fromJSON(decoded[0]);
      }
    }
    return result;
  }
}