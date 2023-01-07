import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import '../client/admincli.dart';
import '../colors/colorsconf.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({super.key});

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  String basic = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Orders'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: Get.height * 0.1,
          backgroundColor: MyColors.tertiary,
        ),
        body: FutureBuilder(
          future: sendGetAdmin("/admin/orders", basic),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.statusCode == 200) {
                var snapData = parseAdminOrders(snapshot.data!.bodyBytes);
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    elevation: 10,
                    child: ScrollableTableView(
                      headerHeight: 50,
                      columns: const [
                        //Orders table
                        TableViewColumn(label: "OrderId"),
                        TableViewColumn(label: "UserId"),
                        TableViewColumn(label: "ProductId"),
                        TableViewColumn(label: "ProductCount"),
                        TableViewColumn(label: "StatuId"),
                        TableViewColumn(label: "AddressId"),
                        TableViewColumn(label: "CreatedAt"),
                        TableViewColumn(label: "MessageId"),
                      ],
                      rows: List.generate(
                        snapData.orders.length,
                        (index) => TableViewRow(
                          cells: [
                            TableViewCell(
                              child: Text(
                                snapData.orders[index].orderId.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.orders[index].userId.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.orders[index].productId.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.orders[index].productCount.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.orders[index].statuId.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.orders[index].addressId.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.orders[index].createdAt.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.orders[index].messageId.toString(),
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
