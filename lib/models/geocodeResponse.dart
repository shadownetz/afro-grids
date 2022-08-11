class GeocodeResponse{
  late List<AddressComponent> addressComponents;
  late String formattedAddress;
  late Geometry geometry;
  late String placeId;
  late Map<String, String>? plusCode;
  late List<String> types;

  GeocodeResponse(this.addressComponents, this.formattedAddress, this.geometry,
      this.placeId, this.plusCode, this.types);


  GeocodeResponse.fromJSON(Map<String, dynamic> json){
    addressComponents = (json['address_components'] as List).map<AddressComponent>((addrComp)=>AddressComponent(
        addrComp['long_name'], addrComp['short_name'], List<String>.from(addrComp['types'] )
    )).toList();
    formattedAddress = json['formatted_address'];
    geometry = Geometry(
        LatLng(json['geometry']['location']['lat'], json['geometry']['location']['lng']),
        json['geometry']['location_type'],
        ViewPort(
            LatLng(json['geometry']['viewport']['northeast']['lat'], json['geometry']['viewport']['northeast']['lng']),
            LatLng(json['geometry']['viewport']['northeast']['lat'], json['geometry']['viewport']['northeast']['lng'])
        )
    );
    placeId = json['place_id'];
    plusCode = json['plus_code'];
    types = List<String>.from(json['types']);
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
  ViewPort viewport;

  Geometry(this.location, this.locationType, this.viewport);

}

class LatLng{
  double lat;
  double lng;
  LatLng(this.lat, this.lng);
}

class ViewPort{
  LatLng northeast;
  LatLng southwest;

  ViewPort(this.northeast, this.southwest);

}