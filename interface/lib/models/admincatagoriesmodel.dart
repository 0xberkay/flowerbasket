// To parse this JSON data, do
//
//     final adminCatagoriesModel = adminCatagoriesModelFromJson(jsonString);

import 'dart:convert';

AdminCatagoriesModel adminCatagoriesModelFromJson(String str) =>
    AdminCatagoriesModel.fromJson(json.decode(str));

String adminCatagoriesModelToJson(AdminCatagoriesModel data) =>
    json.encode(data.toJson());

class AdminCatagoriesModel {
  AdminCatagoriesModel({
    required this.categories,
  });

  List<Category> categories;

  factory AdminCatagoriesModel.fromJson(Map<String, dynamic> json) =>
      AdminCatagoriesModel(
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    required this.categoryId,
    required this.categoryName,
  });

  int categoryId;
  String categoryName;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
      };
}
