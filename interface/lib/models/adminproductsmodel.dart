// To parse this JSON data, do
//
//     final adminProductsModel = adminProductsModelFromJson(jsonString);

import 'dart:convert';

AdminProductsModel adminProductsModelFromJson(String str) =>
    AdminProductsModel.fromJson(json.decode(str));

String adminProductsModelToJson(AdminProductsModel data) =>
    json.encode(data.toJson());

class AdminProductsModel {
  AdminProductsModel({
    required this.products,
  });

  List<Product> products;

  factory AdminProductsModel.fromJson(Map<String, dynamic> json) =>
      AdminProductsModel(
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    required this.productId,
    required this.productName,
    required this.sellerId,
    required this.description,
    required this.imageId,
    required this.price,
    required this.stock,
    required this.createdAt,
    required this.categoryId,
    required this.point,
  });

  int productId;
  String productName;
  int sellerId;
  String description;
  int imageId;
  double price;
  int stock;
  DateTime createdAt;
  int categoryId;
  int point;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productId"],
        productName: json["productName"],
        sellerId: json["sellerId"],
        description: json["description"],
        imageId: json["imageId"],
        price: json["price"].toDouble(),
        stock: json["stock"],
        createdAt: DateTime.parse(json["createdAt"]),
        categoryId: json["categoryId"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "sellerId": sellerId,
        "description": description,
        "imageId": imageId,
        "price": price,
        "stock": stock,
        "createdAt": createdAt.toIso8601String(),
        "categoryId": categoryId,
        "point": point,
      };
}
