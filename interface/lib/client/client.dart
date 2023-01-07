import 'dart:io';
import 'dart:typed_data';

import 'package:flowerbasket/main.dart';
import 'package:flowerbasket/models/cart.dart';
import 'package:flowerbasket/models/comments.dart';
import 'package:flowerbasket/models/gallery.dart';
import 'package:flowerbasket/models/models.dart';
import 'package:flowerbasket/models/orders.dart';
import 'package:flowerbasket/models/product.dart';
import 'package:flowerbasket/models/sellerorders.dart';
import 'package:flowerbasket/models/sellerproducts.dart';
import 'package:flowerbasket/models/statics.dart';
import 'package:flowerbasket/models/statucodes.dart';
import 'package:flowerbasket/models/userdata.dart';
import 'package:flowerbasket/models/catagories.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../colors/colorsconf.dart';
import '../helper/snackmess.dart';
import '../models/address.dart';

class Client {
  // ignore: non_constant_identifier_names
  String get Url => "192.168.0.10:3000";
}

Future<http.Response> sendPost(String path, Object? body) async {
  var url = Uri.parse("http://${Client().Url}$path");
  var response = await http.post(url, body: body);

  return response;
}

Future<http.Response> sendPostWithB(String path, Object? body) async {
  var url = Uri.parse("http://${Client().Url}$path");

  var headers = {
    HttpHeaders.authorizationHeader: "Bearer ${BoxData.read("token")}",
    HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
  };

  var response = await http.post(url, body: body, headers: headers);

  return response;
}

Future<http.Response> sendPostWithJ(String path, Object? body) async {
  var url = Uri.parse("http://${Client().Url}$path");
  var headers = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: "Bearer ${BoxData.read("token")}",
  };

  var response = await http.post(url, body: body, headers: headers);

  return response;
}

Future<http.Response> sendGet(String path) async {
  var url = Uri.parse("http://${Client().Url}$path");
  var headers = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: "Bearer ${BoxData.read("token")}"
  };

  try {
    var response = await http.get(url, headers: headers);
    return response;
  } catch (e) {
    return http.Response("Something went wrong", 503);
  }
}

Future<http.StreamedResponse> sendMultiPart(
    String path, String? filePath) async {
  var url = Uri.parse("http://${Client().Url}$path");
  var headers = {
    HttpHeaders.authorizationHeader: "Bearer ${BoxData.read("token")}",
  };

  var request = http.MultipartRequest('POST', url);
  request.headers.addAll(headers);
  request.files.add(await http.MultipartFile.fromPath('image', filePath!));
  var response = await request.send();
  return response;
}

//message parser
Message parseMess(Uint8List bodyBytes) {
  try {
    return Message.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return Message(message: "Something went wrong");
  }
}

//type parser
Type parseType(Uint8List bodyBytes) {
  return Type.fromJson(json.decode(utf8.decode(bodyBytes)));
}

Product parseProducts(Uint8List bodyBytes) {
  try {
    return Product.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return Product(
      products: [],
    );
  }
}

Statics parseStatics(Uint8List bodyBytes) {
  return Statics.fromJson(json.decode(utf8.decode(bodyBytes)));
}

UserData parseUserData(Uint8List bodyBytes) {
  return UserData.fromJson(json.decode(utf8.decode(bodyBytes)));
}

Address parseAddressData(Uint8List bodyBytes) {
  try {
    return Address.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return Address(
      addresses: [],
    );
  }
}

Comments parseComments(Uint8List bodyBytes) {
  try {
    return Comments.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return Comments(
      comments: [],
    );
  }
}

Categories parseCategories(Uint8List bodyBytes) {
  return Categories.fromJson(json.decode(utf8.decode(bodyBytes)));
}

Cart parseCart(Uint8List bodyBytes) {
  try {
    return Cart.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    print(e);
    return Cart(
      products: [],
      total: 0,
    );
  }
}

Orders parseOrders(Uint8List bodyBytes) {
  try {
    return Orders.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return Orders(
      orders: [],
    );
  }
}

SellerProducts parseSellerProducts(Uint8List bodyBytes) {
  try {
    return SellerProducts.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    SnackMess(
      "Error",
      "No products found",
      MyColors.red,
      SnackPosition.TOP,
      Icons.error,
    );
    return SellerProducts(
      sellerProducts: [],
    );
  }
}

Future<SellerProducts> fetchData() async {
  final response = await sendGet("/seller/getproduct");

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return parseSellerProducts(response.bodyBytes);
  } else {
    var error = parseMess(response.bodyBytes);
    SnackMess(
      "Error",
      error.message,
      MyColors.red,
      SnackPosition.TOP,
      Icons.error,
    );
    throw Exception('Failed to load products');
  }
}

Gallery parseGallery(Uint8List bodyBytes) {
  try {
    return Gallery.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return Gallery(
      gallery: [],
    );
  }
}

SellerOrders parseSellerOrders(Uint8List bodyBytes) {
  try {
    return SellerOrders.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return SellerOrders(
      sellerOrders: [],
    );
  }
}

StatuCodes parseStatuCodes(Uint8List bodyBytes) {
  return StatuCodes.fromJson(json.decode(utf8.decode(bodyBytes)));
}

createExcel(String path, String filename) async {
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

  if (selectedDirectory == null) {
    SnackMess(
      "Error",
      "No directory selected",
      MyColors.red,
      SnackPosition.TOP,
      Icons.error,
    );
    return;
  }
  final downloadDirectory = Directory(selectedDirectory);

  var result = await sendGet(path);
  final file = File("${downloadDirectory.path}/$filename");
  await file.writeAsBytes(result.bodyBytes.buffer.asUint8List());

  if (result.statusCode == 200) {
    SnackMess(
      "Success",
      "File downloaded successfully",
      Colors.green,
      SnackPosition.TOP,
      Icons.check,
    );
  } else {
    SnackMess(
      "Error",
      "Something went wrong",
      MyColors.red,
      SnackPosition.TOP,
      Icons.error,
    );
  }
}
