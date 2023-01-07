import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    required this.id,
    required this.username,
    required this.email,
  });

  int id;
  String username;
  String email;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["ID"],
        username: json["username"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "username": username,
        "email": email,
      };
}
