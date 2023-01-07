import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flowerbasket/client/client.dart';
import 'package:flowerbasket/models/adminstatusmodel.dart';
import 'package:http/http.dart' as http;

import '../models/admincartsmodel.dart';
import '../models/admincatagoriesmodel.dart';
import '../models/admincommentsmodel.dart';
import '../models/adminimagesmodel.dart';
import '../models/adminmessagesmodel.dart';
import '../models/adminordersmodel.dart';
import '../models/adminproductsmodel.dart';
import '../models/adminsellersmodel.dart';
import '../models/adminusersmodel.dart';

Future<http.Response> sendGetAdmin(String path, String basic) async {
  var url = Uri.parse("http://${Client().Url}$path");

  var headers = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: basic,
  };

  try {
    var response = await http.get(url, headers: headers);
    return response;
  } catch (e) {
    return http.Response("Something went wrong", 503);
  }
}

AdminUsersModel parseAdminUsers(Uint8List bodyBytes) {
  try {
    return AdminUsersModel.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return AdminUsersModel(
      users: [],
    );
  }
}

AdminCartsModel parseAdminCarts(Uint8List bodyBytes) {
  try {
    return AdminCartsModel.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return AdminCartsModel(
      carts: [],
    );
  }
}

AdminCatagoriesModel parseAdminCatagories(Uint8List bodyBytes) {
  try {
    return AdminCatagoriesModel.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return AdminCatagoriesModel(
      categories: [],
    );
  }
}

AdminOrdersModel parseAdminOrders(Uint8List bodyBytes) {
  try {
    return AdminOrdersModel.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return AdminOrdersModel(
      orders: [],
    );
  }
}

AdminProductsModel parseAdminProducts(Uint8List bodyBytes) {
  try {
    return AdminProductsModel.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return AdminProductsModel(
      products: [],
    );
  }
}

AdminSellersModel parseAdminSellers(Uint8List bodyBytes) {
  try {
    return AdminSellersModel.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return AdminSellersModel(
      sellers: [],
    );
  }
}

AdminMessagesModel parseAdminMessages(Uint8List bodyBytes) {
  try {
    return AdminMessagesModel.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return AdminMessagesModel(
      cartMessages: [],
    );
  }
}

AdminImagesModel parseAdminImages(Uint8List bodyBytes) {
  try {
    return AdminImagesModel.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return AdminImagesModel(
      images: [],
    );
  }
}

AdminCommentsModel parseAdminComments(Uint8List bodyBytes) {
  try {
    return AdminCommentsModel.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return AdminCommentsModel(
      comments: [],
    );
  }
}

AdminStatusModel parseAdminStatus(Uint8List bodyBytes) {
  try {
    return AdminStatusModel.fromJson(json.decode(utf8.decode(bodyBytes)));
  } catch (e) {
    return AdminStatusModel(
      status: [],
    );
  }
}
