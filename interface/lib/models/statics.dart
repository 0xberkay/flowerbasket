import 'dart:convert';

Statics staticsFromJson(String str) => Statics.fromJson(json.decode(str));

String staticsToJson(Statics data) => json.encode(data.toJson());

class Statics {
  Statics({
    required this.count,
    required this.maxPoint,
  });

  int count;
  double maxPoint;

  factory Statics.fromJson(Map<String, dynamic> json) => Statics(
        count: json["count"],
        maxPoint: json["maxPoint"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "maxPoint": maxPoint,
      };
}
