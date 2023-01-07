// To parse this JSON data, do
//
//     final comments = commentsFromJson(jsonString);

import 'dart:convert';

Comments commentsFromJson(String str) => Comments.fromJson(json.decode(str));

String commentsToJson(Comments data) => json.encode(data.toJson());

class Comments {
  Comments({
    required this.comments,
  });

  List<Comment> comments;

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
      };
}

class Comment {
  Comment({
    required this.username,
    required this.comment,
    required this.point,
  });

  String username;
  String comment;
  int point;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        username: json["username"],
        comment: json["comment"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "comment": comment,
        "point": point,
      };
}
