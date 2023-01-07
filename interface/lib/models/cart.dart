// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
  Cart({
    required this.products,
    required this.total,
  });

  List<ProductCart> products;
  dynamic total;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        products: List<ProductCart>.from(
            json["products"].map((x) => ProductCart.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "total": total,
      };
}

class ProductCart {
  ProductCart({
    required this.cartId,
    required this.productId,
    required this.count,
    required this.price,
    required this.nameInMessage,
    required this.messageId,
    required this.message,
    required this.link,
    required this.productName,
  });

  int cartId;
  int productId;
  int count;
  dynamic price;
  String nameInMessage;
  int messageId;
  String message;
  String link;
  String productName;

  factory ProductCart.fromJson(Map<String, dynamic> json) => ProductCart(
        cartId: json["cart_id"],
        productId: json["product_id"],
        count: json["count"],
        price: json["price"],
        nameInMessage: json["name_in_message"],
        messageId: json["message_id"],
        message: json["message"],
        link: json["link"],
        productName: json["product_name"],
      );

  Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "product_id": productId,
        "count": count,
        "price": price,
        "name_in_message": nameInMessage,
        "message_id": messageId,
        "message": message,
        "link": link,
        "product_name": productName,
      };
}
