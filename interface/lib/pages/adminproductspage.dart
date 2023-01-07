import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import '../client/admincli.dart';
import '../client/client.dart';
import '../colors/colorsconf.dart';
import '../helper/snackmess.dart';

class AdminProducts extends StatefulWidget {
  const AdminProducts({super.key});

  @override
  State<AdminProducts> createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  String basic = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Products'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: Get.height * 0.1,
          backgroundColor: MyColors.tertiary,
        ),
        body: FutureBuilder(
          future: sendGetAdmin("/admin/products", basic),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.statusCode == 200) {
                var snapData = parseAdminProducts(snapshot.data!.bodyBytes);
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    elevation: 10,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              var result = await sendGetAdmin(
                                  "/admin/alterproducts", basic);
                              var mess = parseMess(result.bodyBytes);
                              if (result.statusCode == 200) {
                                Get.back();
                                Get.toNamed("/adminproducts", arguments: basic);
                                SnackMess(
                                    "Success",
                                    mess.message,
                                    Colors.green,
                                    SnackPosition.BOTTOM,
                                    Icons.check_circle_outline);
                              } else {
                                SnackMess("Error", mess.message, Colors.red,
                                    SnackPosition.BOTTOM, Icons.error_outline);
                              }
                            },
                            child: const Text("Alter Products")),
                        Expanded(
                          child: ScrollableTableView(
                            headerHeight: 50,
                            columns: const [
                              //Products table
                              TableViewColumn(label: "ProductId"),
                              TableViewColumn(label: "ProductName"),
                              TableViewColumn(label: "SellerId"),
                              TableViewColumn(label: "Price"),
                              TableViewColumn(label: "Description"),
                              TableViewColumn(label: "ImageId"),
                              TableViewColumn(label: "Price"),
                              TableViewColumn(label: "Stock"),
                              TableViewColumn(label: "CreatedAt"),
                              TableViewColumn(label: "CategoryId"),
                              TableViewColumn(label: "Point"),
                            ],
                            rows: List.generate(
                              snapData.products.length,
                              (index) => TableViewRow(
                                cells: [
                                  TableViewCell(
                                    child: Text(
                                      snapData.products[index].productId
                                          .toString(),
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.products[index].productName,
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.products[index].sellerId
                                          .toString(),
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.products[index].price.toString(),
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.products[index].description,
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.products[index].imageId
                                          .toString(),
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.products[index].price.toString(),
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.products[index].stock.toString(),
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.products[index].createdAt
                                          .toString(),
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.products[index].categoryId
                                          .toString(),
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.products[index].point.toString(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text("Error"),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
