import 'dart:convert';

import 'package:flowerbasket/client/client.dart';
import 'package:flowerbasket/colors/colorsconf.dart';
import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flowerbasket/pages/sellerhome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/widgets.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _productName = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _stock = TextEditingController();
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
          title: const Text('Seller Product Add'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: Get.height * 0.1,
          backgroundColor: MyColors.tertiary,
        ),
        body: ListView(
          children: [
            myField(
                "Product Name", Icons.apps_sharp, _productName, false, false),
            myField(
                "Description", Icons.description, _description, false, false),
            myFieldNumber("Price", Icons.attach_money, _price, false, false),
            myFieldNumber("Stock", Icons.inventory, _stock, false, false),

            //pick category dropdown
            PickCategory(
              callback: (int val) {
                _catergoryId = val;
              },
            ),
            //image
            _link != null
                ? SizedBox(
                    height: Get.height * 0.2,
                    width: Get.width * 0.2,
                    child: Image.network(_link!))
                : Container(),
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

            Padding(
              padding: EdgeInsets.only(
                  left: Get.width * 0.04,
                  right: Get.width * 0.04,
                  top: Get.height * 0.02,
                  bottom: Get.height * 0.02),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(Get.width, Get.height * 0.1),
                    backgroundColor: MyColors.bold,
                  ),
                  onPressed: () async {
                    if (_productName.text.isNotEmpty &&
                        _description.text.isNotEmpty &&
                        _price.text.isNotEmpty &&
                        _stock.text.isNotEmpty &&
                        _catergoryId != null &&
                        _imageId != null) {
                      var sendProduct = {
                        "product_name": _productName.text,
                        "description": _description.text,
                        "price": double.parse(_price.text),
                        "stock": int.parse(_stock.text),
                        "category_id": _catergoryId!,
                        "image_id": _imageId!
                      };
                      var result = await sendPostWithJ(
                          "/seller/addproduct", jsonEncode(sendProduct));
                      var mess = parseMess(result.bodyBytes);
                      if (result.statusCode == 200) {
                        Get.offAll(const SellerHome(), arguments: 0);

                        SnackMess("Success", mess.message, Colors.green,
                            SnackPosition.TOP, Icons.check_circle_outline);
                      } else {
                        SnackMess("Error", mess.message, MyColors.red,
                            SnackPosition.TOP, Icons.error_outline);
                      }
                    }
                  },
                  child: const Text('Add Product')),
            )

            //pick image
          ],
        ));
  }
}
