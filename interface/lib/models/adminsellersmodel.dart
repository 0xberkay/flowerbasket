// To parse this JSON data, do
//
//     final adminSellersModel = adminSellersModelFromJson(jsonString);

import 'dart:convert';

AdminSellersModel adminSellersModelFromJson(String str) =>
    AdminSellersModel.fromJson(json.decode(str));

String adminSellersModelToJson(AdminSellersModel data) =>
    json.encode(data.toJson());

class AdminSellersModel {
  AdminSellersModel({
    required this.sellers,
  });

  List<Seller> sellers;

  factory AdminSellersModel.fromJson(Map<String, dynamic> json) =>
      AdminSellersModel(
        sellers:
            List<Seller>.from(json["sellers"].map((x) => Seller.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sellers": List<dynamic>.from(sellers.map((x) => x.toJson())),
      };
}

class Seller {
  Seller({
    required this.sellerId,
    required this.company,
    required this.password,
    required this.email,
    required this.point,
    required this.phone,
    required this.trust,
    required this.code,
  });

  int sellerId;
  String company;
  String password;
  String email;
  double point;
  String phone;
  bool trust;
  Code code;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        sellerId: json["sellerId"],
        company: json["company"],
        password: json["password"],
        email: json["email"],
        point: json["point"].toDouble(),
        phone: json["phone"],
        trust: json["trust"],
        code: Code.fromJson(json["code"]),
      );

  Map<String, dynamic> toJson() => {
        "sellerId": sellerId,
        "company": company,
        "password": password,
        "email": email,
        "point": point,
        "phone": phone,
        "trust": trust,
        "code": code.toJson(),
      };
}

class Code {
  Code({
    required this.string,
    required this.valid,
  });

  String string;
  bool valid;

  factory Code.fromJson(Map<String, dynamic> json) => Code(
        string: json["String"],
        valid: json["Valid"],
      );

  Map<String, dynamic> toJson() => {
        "String": string,
        "Valid": valid,
      };
}
