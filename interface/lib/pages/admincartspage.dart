import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import '../client/admincli.dart';
import '../colors/colorsconf.dart';

class AdminCarts extends StatefulWidget {
  const AdminCarts({super.key});

  @override
  State<AdminCarts> createState() => _AdminCartsState();
}

class _AdminCartsState extends State<AdminCarts> {
  String basic = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Carts'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: Get.height * 0.1,
          backgroundColor: MyColors.tertiary,
        ),
        body: FutureBuilder(
          future: sendGetAdmin("/admin/carts", basic),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.statusCode == 200) {
                var snapData = parseAdminCarts(snapshot.data!.bodyBytes);
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    elevation: 10,
                    child: ScrollableTableView(
                      headerHeight: 50,
                      columns: const [
                        //Carts table
                        TableViewColumn(label: "CartId"),
                        TableViewColumn(label: "UserId"),
                        TableViewColumn(label: "ProductId"),
                        TableViewColumn(label: "Count"),
                        TableViewColumn(label: "Price"),
                        TableViewColumn(label: "MessageId"),
                      ],
                      rows: List.generate(
                        snapData.carts.length,
                        (index) => TableViewRow(
                          cells: [
                            TableViewCell(
                              child: Text(
                                snapData.carts[index].cartId.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.carts[index].userId.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.carts[index].productId.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.carts[index].count.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.carts[index].price.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.carts[index].messageId.toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
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
