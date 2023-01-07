// To parse this JSON data, do
//
//     final adminMessagesModel = adminMessagesModelFromJson(jsonString);

import 'dart:convert';

AdminMessagesModel adminMessagesModelFromJson(String str) =>
    AdminMessagesModel.fromJson(json.decode(str));

String adminMessagesModelToJson(AdminMessagesModel data) =>
    json.encode(data.toJson());

class AdminMessagesModel {
  AdminMessagesModel({
    required this.cartMessages,
  });

  List<CartMessage> cartMessages;

  factory AdminMessagesModel.fromJson(Map<String, dynamic> json) =>
      AdminMessagesModel(
        cartMessages: List<CartMessage>.from(
            json["cartMessages"].map((x) => CartMessage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cartMessages": List<dynamic>.from(cartMessages.map((x) => x.toJson())),
      };
}

class CartMessage {
  CartMessage({
    required this.messageId,
    required this.cartId,
    required this.message,
    required this.nameInMessage,
  });

  int messageId;
  int cartId;
  String message;
  String nameInMessage;

  factory CartMessage.fromJson(Map<String, dynamic> json) => CartMessage(
        messageId: json["messageId"],
        cartId: json["cartId"],
        message: json["message"],
        nameInMessage: json["nameInMessage"],
      );

  Map<String, dynamic> toJson() => {
        "messageId": messageId,
        "cartId": cartId,
        "message": message,
        "nameInMessage": nameInMessage,
      };
}
