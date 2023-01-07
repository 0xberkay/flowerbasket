// To parse this JSON data, do
//
//     final sellerOrders = sellerOrdersFromJson(jsonString);

import 'dart:convert';

SellerOrders sellerOrdersFromJson(String str) =>
    SellerOrders.fromJson(json.decode(str));

String sellerOrdersToJson(SellerOrders data) => json.encode(data.toJson());

class SellerOrders {
  SellerOrders({
    required this.sellerOrders,
  });

  List<SellerOrder> sellerOrders;

  factory SellerOrders.fromJson(Map<String, dynamic> json) => SellerOrders(
        sellerOrders: List<SellerOrder>.from(
            json["seller_orders"].map((x) => SellerOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "seller_orders":
            List<dynamic>.from(sellerOrders.map((x) => x.toJson())),
      };
}

class SellerOrder {
  SellerOrder({
    required this.orderId,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.productCount,
    required this.statuId,
    required this.addressId,
    required this.statuName,
    required this.createdAt,
    required this.messageId,
    required this.cartId,
    required this.message,
    required this.nameInMessage,
    required this.sellerId,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.detail,
    required this.latitude,
    required this.longitude,
  });

  int orderId;
  int userId;
  int productId;
  String productName;
  dynamic price;
  int productCount;
  int statuId;
  int addressId;
  String statuName;
  DateTime createdAt;
  int messageId;
  int cartId;
  String message;
  String nameInMessage;
  int sellerId;
  String street;
  String city;
  String state;
  String zipCode;
  String detail;
  double latitude;
  double longitude;

  factory SellerOrder.fromJson(Map<String, dynamic> json) => SellerOrder(
        orderId: json["order_id"],
        userId: json["user_id"],
        productId: json["product_id"],
        productName: json["product_name"],
        price: json["price"],
        productCount: json["product_count"],
        statuId: json["statu_id"],
        addressId: json["address_id"],
        statuName: json["statu_name"],
        createdAt: DateTime.parse(json["created_at"]),
        messageId: json["message_id"],
        cartId: json["cart_id"],
        message: json["message"],
        nameInMessage: json["name_in_message"],
        sellerId: json["seller_id"],
        street: json["street"],
        city: json["city"],
        state: json["state"],
        zipCode: json["zip_code"],
        detail: json["detail"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "user_id": userId,
        "product_id": productId,
        "product_name": productName,
        "price": price,
        "product_count": productCount,
        "statu_id": statuId,
        "address_id": addressId,
        "statu_name": statuName,
        "created_at": createdAt.toIso8601String(),
        "message_id": messageId,
        "cart_id": cartId,
        "message": message,
        "name_in_message": nameInMessage,
        "seller_id": sellerId,
        "street": street,
        "city": city,
        "state": state,
        "zip_code": zipCode,
        "detail": detail,
        "latitude": latitude,
        "longitude": longitude,
      };
}
