// To parse this JSON data, do
//
//     final adminImagesModel = adminImagesModelFromJson(jsonString);

import 'dart:convert';

AdminImagesModel adminImagesModelFromJson(String str) =>
    AdminImagesModel.fromJson(json.decode(str));

String adminImagesModelToJson(AdminImagesModel data) =>
    json.encode(data.toJson());

class AdminImagesModel {
  AdminImagesModel({
    required this.images,
  });

  List<Image> images;

  factory AdminImagesModel.fromJson(Map<String, dynamic> json) =>
      AdminImagesModel(
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class Image {
  Image({
    required this.imageId,
    required this.sellerId,
    required this.link,
  });

  int imageId;
  int sellerId;
  String link;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        imageId: json["imageId"],
        sellerId: json["sellerId"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "imageId": imageId,
        "sellerId": sellerId,
        "link": link,
      };
}
