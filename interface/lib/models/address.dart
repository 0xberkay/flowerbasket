// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  Address({
    required this.addresses,
  });

  List<AddressElement> addresses;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        addresses: List<AddressElement>.from(
            json["addresses"].map((x) => AddressElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
      };
}

class AddressElement {
  AddressElement({
    required this.addressId,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.detail,
    required this.latitude,
    required this.longitude,
  });

  int addressId;
  String street;
  String city;
  String state;
  String zipCode;
  String detail;
  double latitude;
  double longitude;

  factory AddressElement.fromJson(Map<String, dynamic> json) => AddressElement(
        addressId: json["AddressID"],
        street: json["street"],
        city: json["city"],
        state: json["state"],
        zipCode: json["zip_code"],
        detail: json["detail"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "city": city,
        "state": state,
        "zip_code": zipCode,
        "detail": detail,
        "latitude": latitude,
        "longitude": longitude,
      };
}
