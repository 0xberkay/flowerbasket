// To parse this JSON data, do
//
//     final adminUsersModel = adminUsersModelFromJson(jsonString);

import 'dart:convert';

AdminUsersModel adminUsersModelFromJson(String str) =>
    AdminUsersModel.fromJson(json.decode(str));

String adminUsersModelToJson(AdminUsersModel data) =>
    json.encode(data.toJson());

class AdminUsersModel {
  AdminUsersModel({
    required this.users,
  });

  List<User> users;

  factory AdminUsersModel.fromJson(Map<String, dynamic> json) =>
      AdminUsersModel(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class User {
  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.password,
    required this.code,
  });

  int userId;
  String username;
  String email;
  String password;
  Code code;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        code: Code.fromJson(json["code"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "username": username,
        "email": email,
        "password": password,
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
