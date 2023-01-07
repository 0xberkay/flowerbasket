// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    required this.products,
  });

  List<ProductElement> products;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        products: List<ProductElement>.from(
            json["products"].map((x) => ProductElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class ProductElement {
  ProductElement({
    required this.productId,
    required this.company,
    required this.sellerId,
    required this.productName,
    required this.description,
    required this.price,
    required this.stock,
    required this.categoryName,
    required this.link,
    required this.point,
  });

  int productId;
  String company;
  int sellerId;
  String productName;
  String description;
  dynamic price;
  int stock;
  String categoryName;
  String link;
  double point;

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
        productId: json["product_id"],
        company: json["company"],
        sellerId: json["seller_id"],
        productName: json["product_name"],
        description: json["description"],
        price: json["price"],
        stock: json["stock"],
        categoryName: json["category_name"],
        link: json["link"],
        point: json["point"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "company": company,
        "seller_id": sellerId,
        "product_name": productName,
        "description": description,
        "price": price,
        "stock": stock,
        "category_name": categoryName,
        "link": link,
        "point": point,
      };
}
