// To parse this JSON data, do
//
//     final adminCartsModel = adminCartsModelFromJson(jsonString);

import 'dart:convert';

AdminCartsModel adminCartsModelFromJson(String str) =>
    AdminCartsModel.fromJson(json.decode(str));

String adminCartsModelToJson(AdminCartsModel data) =>
    json.encode(data.toJson());

class AdminCartsModel {
  AdminCartsModel({
    required this.carts,
  });

  List<Cart> carts;

  factory AdminCartsModel.fromJson(Map<String, dynamic> json) =>
      AdminCartsModel(
        carts: List<Cart>.from(json["carts"].map((x) => Cart.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "carts": List<dynamic>.from(carts.map((x) => x.toJson())),
      };
}

class Cart {
  Cart({
    required this.cartId,
    required this.userId,
    required this.productId,
    required this.count,
    required this.price,
    required this.messageId,
  });

  int cartId;
  int userId;
  int productId;
  int count;
  dynamic price;
  int messageId;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        cartId: json["cartId"],
        userId: json["userId"],
        productId: json["productId"],
        count: json["count"],
        price: json["price"],
        messageId: json["messageId"],
      );

  Map<String, dynamic> toJson() => {
        "cartId": cartId,
        "userId": userId,
        "productId": productId,
        "count": count,
        "price": price,
        "messageId": messageId,
      };
}
