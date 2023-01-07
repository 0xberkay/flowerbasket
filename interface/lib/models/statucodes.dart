// To parse this JSON data, do
//
//     final statuCodes = statuCodesFromJson(jsonString);

import 'dart:convert';

StatuCodes statuCodesFromJson(String str) =>
    StatuCodes.fromJson(json.decode(str));

String statuCodesToJson(StatuCodes data) => json.encode(data.toJson());

class StatuCodes {
  StatuCodes({
    required this.statusCodes,
  });

  List<StatusCode> statusCodes;

  factory StatuCodes.fromJson(Map<String, dynamic> json) => StatuCodes(
        statusCodes: List<StatusCode>.from(
            json["status_codes"].map((x) => StatusCode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_codes": List<dynamic>.from(statusCodes.map((x) => x.toJson())),
      };
}

class StatusCode {
  StatusCode({
    required this.statuId,
    required this.statuName,
  });

  int statuId;
  String statuName;

  factory StatusCode.fromJson(Map<String, dynamic> json) => StatusCode(
        statuId: json["statu_id"],
        statuName: json["statu_name"],
      );

  Map<String, dynamic> toJson() => {
        "statu_id": statuId,
        "statu_name": statuName,
      };
}
