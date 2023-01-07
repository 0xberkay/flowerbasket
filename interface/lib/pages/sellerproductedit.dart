import 'dart:convert';

import 'package:flowerbasket/colors/colorsconf.dart';
import 'package:flowerbasket/models/sellerproducts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../client/client.dart';
import '../helper/snackmess.dart';
import '../widgets/widgets.dart';
import 'sellerhome.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _productName = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _stock = TextEditingController();
  final SellerProduct product = Get.arguments;

  int? _catergoryId;
  int? _imageId;
  String? _link;

  @override
  void dispose() {
    _productName.dispose();
    _description.dispose();
    _price.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Product Edit'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight: Get.height * 0.1,
        backgroundColor: MyColors.tertiary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.save,
                size: 30,
              ),
              onPressed: () async {
                if (_productName.text == "" &&
                    _description.text == "" &&
                    _price.text.toString() == "" &&
                    _stock.text.toString() == "" &&
                    _catergoryId == null &&
                    _imageId == null) {
                  SnackMess("Error", "There is no changes", MyColors.red,
                      SnackPosition.TOP, Icons.error_outline);
                  return;
                }
                var sendProduct = {
                  "product_name":
                      _productName.text == "" ? "" : _productName.text,
                  "description":
                      _description.text == "" ? "" : _description.text,
                  "price": _price.text == "" ? 0 : double.parse(_price.text),
                  "stock": _stock.text == "" ? 0 : int.parse(_stock.text),
                  "category_id": _catergoryId ?? 0,
                  "image_id": _imageId ?? 0,
                };
                var result = await sendPostWithJ(
                    "/seller/updateproduct?id=${product.id}",
                    jsonEncode(sendProduct));
                var mess = parseMess(result.bodyBytes);
                if (result.statusCode == 200) {
                  Get.offAll(const SellerHome(), arguments: 0);

                  SnackMess("Success", mess.message, Colors.green,
                      SnackPosition.TOP, Icons.check_circle_outline);
                } else {
                  SnackMess("Error", mess.message, MyColors.red,
                      SnackPosition.TOP, Icons.error_outline);
                }
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          myField(
              product.productName, Icons.apps_sharp, _productName, false, true),
          myField(product.description, Icons.description, _description, false,
              true),
          myFieldNumber(product.price.toString(), Icons.attach_money, _price,
              false, true),
          myFieldNumber(
              product.stock.toString(), Icons.inventory, _stock, false, true),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 15.0,
              right: 15.0,
            ),
            child: Container(
              height: Get.height * 0.05,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: MyColors.quaternary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  "Old Category: ${product.categoryName}",
                  style: const TextStyle(
                      color: MyColors.secondary, fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ),
          PickCategory(
            callback: (int val) {
              _catergoryId = val;
            },
          ),
          SizedBox(
              height: Get.height * 0.2,
              width: Get.width * 0.2,
              child: Image.network(_link ?? product.imageLink)),
          //pick image
          Padding(
            padding: EdgeInsets.only(
                left: Get.width * 0.1,
                right: Get.width * 0.1,
                top: Get.height * 0.02,
                bottom: Get.height * 0.02),
            child: ElevatedButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: "Click for pick image",
                    content: SellerGalleryPicker(
                      callback: (int val) {
                        _imageId = val;
                      },
                      callbacklink: (val) {
                        setState(() {
                          _link = val;
                        });
                      },
                    ),
                    textConfirm: "Confirm",
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      Get.back();
                    },
                  );
                },
                child: const Text("Pick Image")),
          ),
        ],
      ),
    );
  }
}
