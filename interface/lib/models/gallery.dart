// To parse this JSON data, do
//
//     final gallery = galleryFromJson(jsonString);

import 'dart:convert';

Gallery galleryFromJson(String str) => Gallery.fromJson(json.decode(str));

String galleryToJson(Gallery data) => json.encode(data.toJson());

class Gallery {
  Gallery({
    required this.gallery,
  });

  List<GalleryElement> gallery;

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
        gallery: List<GalleryElement>.from(
            json["gallery"].map((x) => GalleryElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "gallery": List<dynamic>.from(gallery.map((x) => x.toJson())),
      };
}

class GalleryElement {
  GalleryElement({
    required this.id,
    required this.link,
  });

  int id;
  String link;

  factory GalleryElement.fromJson(Map<String, dynamic> json) => GalleryElement(
        id: json["id"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "link": link,
      };
}
