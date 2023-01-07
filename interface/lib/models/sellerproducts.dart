// To parse this JSON data, do
//
//     final sellerProducts = sellerProductsFromJson(jsonString);

import 'dart:convert';

SellerProducts sellerProductsFromJson(String str) =>
    SellerProducts.fromJson(json.decode(str));

String sellerProductsToJson(SellerProducts data) => json.encode(data.toJson());

class SellerProducts {
  SellerProducts({
    required this.sellerProducts,
  });

  List<SellerProduct> sellerProducts;

  factory SellerProducts.fromJson(Map<String, dynamic> json) => SellerProducts(
        sellerProducts: List<SellerProduct>.from(
            json["seller_products"].map((x) => SellerProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "seller_products":
            List<dynamic>.from(sellerProducts.map((x) => x.toJson())),
      };
}

class SellerProduct {
  SellerProduct({
    required this.id,
    required this.productName,
    required this.sellerId,
    required this.description,
    required this.imageId,
    required this.imageLink,
    required this.price,
    required this.stock,
    required this.productPoint,
    required this.categoryId,
    required this.createdAt,
    required this.categoryName,
  });

  int id;
  String productName;
  int sellerId;
  String description;
  int imageId;
  String imageLink;
  dynamic price;
  int stock;
  int productPoint;
  int categoryId;
  DateTime createdAt;
  String categoryName;

  factory SellerProduct.fromJson(Map<String, dynamic> json) => SellerProduct(
        id: json["ID"],
        productName: json["product_name"],
        sellerId: json["seller_id"],
        description: json["description"],
        imageId: json["image_id"],
        imageLink: json["image_link"],
        price: json["price"],
        stock: json["stock"],
        productPoint: json["product_point"],
        categoryId: json["category_id"],
        createdAt: DateTime.parse(json["created_at"]),
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "product_name": productName,
        "seller_id": sellerId,
        "description": description,
        "image_id": imageId,
        "image_link": imageLink,
        "price": price,
        "stock": stock,
        "product_point": productPoint,
        "category_id": categoryId,
        "created_at": createdAt.toIso8601String(),
        "category_name": categoryName,
      };
}
