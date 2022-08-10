class GeocodeResponse{
  late List<AddressComponent> addressComponents;
  late String formattedAddress;
  late Geometry geometry;
  late String placeId;
  late Map<String, String> plusCode;
  late List<String> types;

  GeocodeResponse(this.addressComponents, this.formattedAddress, this.geometry,
      this.placeId, this.plusCode, this.types);


  GeocodeResponse.fromJSON(Map<String, dynamic> json){
    addressComponents = json['address_components'].map((addrComp)=>AddressComponent(
        addrComp['long_name'], addrComp['short_name'], addrComp['types']
    ));
    formattedAddress = json['formatted_address'];
    geometry = Geometry(
        LatLng(json['geometry']['location']['lat'], json['geometry']['location']['lng']),
        json['geometry']['location_type'],
        json['geometry']['viewport']
    );
    placeId = json['place_id'];
    plusCode = json['plus_code'];
    types = json['types'];
  }

}

class AddressComponent{
  String longName;
  String shortName;
  List<String> types;

  AddressComponent(this.longName, this.shortName, this.types);

}

class Geometry{
  LatLng location;
  String locationType;
  Map<String, LatLng> viewport;

  Geometry(this.location, this.locationType, this.viewport);

}

class LatLng{
  double lat;
  double lng;
  LatLng(this.lat, this.lng);
}