// To parse this JSON data, do
//
//     final adminStatusModel = adminStatusModelFromJson(jsonString);

import 'dart:convert';

AdminStatusModel adminStatusModelFromJson(String str) =>
    AdminStatusModel.fromJson(json.decode(str));

String adminStatusModelToJson(AdminStatusModel data) =>
    json.encode(data.toJson());

class AdminStatusModel {
  AdminStatusModel({
    required this.status,
  });

  List<Status> status;

  factory AdminStatusModel.fromJson(Map<String, dynamic> json) =>
      AdminStatusModel(
        status:
            List<Status>.from(json["status"].map((x) => Status.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": List<dynamic>.from(status.map((x) => x.toJson())),
      };
}

class Status {
  Status({
    required this.statuId,
    required this.statuName,
  });

  int statuId;
  String statuName;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        statuId: json["statuId"],
        statuName: json["statuName"],
      );

  Map<String, dynamic> toJson() => {
        "statuId": statuId,
        "statuName": statuName,
      };
}
