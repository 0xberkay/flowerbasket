// To parse this JSON data, do
//
//     final adminOrdersModel = adminOrdersModelFromJson(jsonString);

import 'dart:convert';

AdminOrdersModel adminOrdersModelFromJson(String str) =>
    AdminOrdersModel.fromJson(json.decode(str));

String adminOrdersModelToJson(AdminOrdersModel data) =>
    json.encode(data.toJson());

class AdminOrdersModel {
  AdminOrdersModel({
    required this.orders,
  });

  List<Order> orders;

  factory AdminOrdersModel.fromJson(Map<String, dynamic> json) =>
      AdminOrdersModel(
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
    required this.addressId,
    required this.createdAt,
    required this.messageId,
  });

  int orderId;
  int userId;
  int productId;
  int productCount;
  int statuId;
  int addressId;
  DateTime createdAt;
  int messageId;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["orderId"],
        userId: json["userId"],
        productId: json["productId"],
        productCount: json["productCount"],
        statuId: json["statuId"],
        addressId: json["addressId"],
        createdAt: DateTime.parse(json["createdAt"]),
        messageId: json["messageId"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "userId": userId,
        "productId": productId,
        "productCount": productCount,
        "statuId": statuId,
        "addressId": addressId,
        "createdAt": createdAt.toIso8601String(),
        "messageId": messageId,
      };
}
