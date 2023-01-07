import 'package:flowerbasket/client/client.dart';
import 'package:flowerbasket/colors/colorsconf.dart';
import 'package:flowerbasket/helper/ontapimage.dart';
import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flowerbasket/models/product.dart';
import 'package:flowerbasket/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/smalldesc.dart';
import 'userpage.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int count = 1;
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    ProductElement product = Get.arguments;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: Get.width,
          height: Get.height * 0.1,
          color: MyColors.secondary,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            // +1 button
            SizedBox(
              width: Get.width * 0.1,
              height: Get.height * 0.1,
              child: IconButton(
                onPressed: () {
                  if (count < product.stock) {
                    setState(() {
                      count++;
                    });
                  }
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            // count
            SizedBox(
              width: Get.width * 0.1,
              height: Get.height * 0.1,
              child: Center(
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            // -1 button
            SizedBox(
              width: Get.width * 0.1,
              height: Get.height * 0.1,
              child: IconButton(
                onPressed: () {
                  if (count > 1) {
                    setState(() {
                      count--;
                    });
                  }
                },
                icon: const Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
              ),
            ),
            //price
            SizedBox(
              width: Get.width * 0.2,
              height: Get.height * 0.2,
              child: Center(
                child: Text(
                  "${product.price * count} TL",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            // add to cart button
            SizedBox(
              width: Get.width * 0.4,
              height: Get.height * 0.1,
              child: ElevatedButton(
                onPressed: () async {
                  var result = await sendGet(
                      "/user/addtocart?id=${product.productId}&count=$count");
                  var message = parseMess(result.bodyBytes);
                  Get.back();
                  Get.back();
                  if (result.statusCode == 200) {
                    SnackMess(
                      "Success",
                      message.message,
                      Colors.green,
                      SnackPosition.TOP,
                      Icons.check,
                    );
                  } else {
                    SnackMess(
                      "Error",
                      message.message,
                      MyColors.red,
                      SnackPosition.TOP,
                      Icons.error,
                    );
                  }
                },
                child: const Text(
                  "Add to Cart",
                ),
              ),
            ),
          ]),
        ),
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                onTapImage(product.link);
              },
              child: Container(
                width: Get.width,
                height: Get.height * 0.6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product.link),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Get.height * 0.5,
                width: Get.width,
                decoration: BoxDecoration(
                  color: MyColors.back,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 7,
                      offset: const Offset(0, -1), // changes position of shadow
                    ),
                  ],
                ),
                child: ListView(
                  //centered
                  padding: EdgeInsets.only(
                    left: Get.width * 0.05,
                    right: Get.width * 0.05,
                  ),
                  children: [
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    ListTile(
                      title: Text(
                        product.productName,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          maximumSize: Size(Get.width * 0.2, Get.height * 0.09),
                        ),
                        onPressed: () {
                          Get.toNamed(
                            "/sellerdetail",
                            arguments: [product.company, product.sellerId],
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.storefront,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product.company,
                                style: TextStyle(
                                  fontSize: Get.height * 0.03,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: MyColors.back,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 7,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: starBuilder(product.point),
                              subtitle: Text(
                                //get double first 3 number
                                "Point: ${product.point.toStringAsFixed(3)}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            )),
                      ),
                    ),
                    // product category
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: Get.height * 0.1,
                            width: Get.width * 0.3,
                            decoration: BoxDecoration(
                              color: MyColors.secondary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 7,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: const Text(
                                "Category",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                product.categoryName,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              onTap: () {
                                Get.offAll(const Home(), arguments: 1);
                              },
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.05,
                          ),
                          Container(
                            height: Get.height * 0.1,
                            width: Get.width * 0.3,
                            decoration: BoxDecoration(
                              color: MyColors.back,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 7,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: const Text(
                                "Stock",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                product.stock.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    //description
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: Get.width * 0.9,
                        decoration: BoxDecoration(
                          color: MyColors.back,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 7,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            smallDescription(product.description),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            Get.defaultDialog(
                              title: "Description",
                              content: Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    product.description,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              textConfirm: "Close",
                              confirmTextColor: Colors.white,
                              onConfirm: () {
                                Get.back();
                              },
                              buttonColor: MyColors.secondary,
                            );
                          },
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                    //comments
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: Get.width * 0.9,
                        decoration: BoxDecoration(
                          color: MyColors.back,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 7,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.comment,
                            size: 30,
                          ),
                          title: const Text(
                            "Comments",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            "See all comments",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                          ),
                          onTap: () {
                            Get.toNamed("/comments", arguments: product);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
