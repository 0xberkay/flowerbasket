// To parse this JSON data, do
//
//     final adminCommentsModel = adminCommentsModelFromJson(jsonString);

import 'dart:convert';

AdminCommentsModel adminCommentsModelFromJson(String str) =>
    AdminCommentsModel.fromJson(json.decode(str));

String adminCommentsModelToJson(AdminCommentsModel data) =>
    json.encode(data.toJson());

class AdminCommentsModel {
  AdminCommentsModel({
    required this.comments,
  });

  List<Comment> comments;

  factory AdminCommentsModel.fromJson(Map<String, dynamic> json) =>
      AdminCommentsModel(
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
      };
}

class Comment {
  Comment({
    required this.commentId,
    required this.productId,
    required this.userId,
    required this.point,
    required this.comment,
    required this.orderId,
  });

  int commentId;
  int productId;
  int userId;
  int point;
  String comment;
  int orderId;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        commentId: json["commentId"],
        productId: json["productId"],
        userId: json["userId"],
        point: json["point"],
        comment: json["comment"],
        orderId: json["orderId"],
      );

  Map<String, dynamic> toJson() => {
        "commentId": commentId,
        "productId": productId,
        "userId": userId,
        "point": point,
        "comment": comment,
        "orderId": orderId,
      };
}
