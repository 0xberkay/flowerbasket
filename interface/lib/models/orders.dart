// To parse this JSON data, do
//
//     final orders = ordersFromJson(jsonString);

import 'dart:convert';

Orders ordersFromJson(String str) => Orders.fromJson(json.decode(str));

String ordersToJson(Orders data) => json.encode(data.toJson());

class Orders {
  Orders({
    required this.orders,
  });

  List<Order> orders;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    required this.orderId,
    required this.userId,
    required this.productId,
    required this.productCount,
    required this.statuId,
    required this.statuName,
    required this.addressId,
    required this.createdAt,
    required this.sellerId,
    required this.messageId,
    required this.message,
    required this.productName,
    required this.price,
    required this.link,
  });

  int orderId;
  int userId;
  int productId;
  int productCount;
  int statuId;
  String statuName;
  int addressId;
  DateTime createdAt;
  int sellerId;
  int messageId;
  String message;
  String productName;
  dynamic price;
  String link;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["order_id"],
        userId: json["user_id"],
        productId: json["product_id"],
        productCount: json["product_count"],
        statuId: json["statu_id"],
        statuName: json["statu_name"],
        addressId: json["address_id"],
        createdAt: DateTime.parse(json["created_at"]),
        sellerId: json["seller_id"],
        messageId: json["message_id"],
        message: json["message"],
        productName: json["product_name"],
        price: json["price"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "user_id": userId,
        "product_id": productId,
        "product_count": productCount,
        "statu_id": statuId,
        "statu_name": statuName,
        "address_id": addressId,
        "created_at": createdAt.toIso8601String(),
        "seller_id": sellerId,
        "message_id": messageId,
        "message": message,
        "product_name": productName,
        "price": price,
        "link": link,
      };
}
