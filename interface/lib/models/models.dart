import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

// String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    required this.message,
  });

  String message;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

Type typeFromJson(String str) => Type.fromJson(json.decode(str));

class Type {
  Type({
    required this.id,
    required this.username,
    required this.isSeller,
  });

  int id;
  String username;
  bool isSeller;

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"],
        username: json["username"],
        isSeller: json["is_seller"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "is_seller": isSeller,
      };
}
