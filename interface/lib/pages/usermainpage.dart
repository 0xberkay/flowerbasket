import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../client/client.dart';
import '../widgets/widgets.dart';

class UserMainPage extends StatefulWidget {
  const UserMainPage({
    Key? key,
    required this.path,
  }) : super(key: key);
  final String path;

  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: sendGet(widget.path),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.statusCode == 200) {
              var products = parseProducts(snapshot.data!.bodyBytes);
              if (products.products.isEmpty) {
                return const Center(
                  child: Text("No Product"),
                );
              } else {
                return ListView.builder(
                  itemCount: products.products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 10,
                        child: Column(
                          children: [
                            ListTile(
                                title:
                                    Text(products.products[index].productName),
                                subtitle:
                                    Text(products.products[index].company),
                                leading: IconButton(
                                  onPressed: () {
                                    Get.toNamed(
                                      "/sellerdetail",
                                      arguments: [
                                        products.products[index].company,
                                        products.products[index].sellerId
                                      ],
                                    );
                                  },
                                  icon: const Icon(Icons.storefront),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  starBuilder(products.products[index].point),
                            ),
                            Image.network(
                              products.products[index].link,
                              height: 200,
                            ),
                            SizedBox(
                              height: Get.height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.green,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      "${products.products[index].price} TL",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.toNamed("/product",
                                        arguments: products.products[index]);
                                  },
                                  child: const Text("See More"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.01,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              var message = parseMess(snapshot.data!.bodyBytes);
              return Center(
                child: Text(message.message),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
