import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import '../client/admincli.dart';
import '../colors/colorsconf.dart';

class AdminSellers extends StatefulWidget {
  const AdminSellers({super.key});

  @override
  State<AdminSellers> createState() => _AdminSellersState();
}

class _AdminSellersState extends State<AdminSellers> {
  String basic = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Sellers'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: Get.height * 0.1,
          backgroundColor: MyColors.tertiary,
        ),
        body: FutureBuilder(
          future: sendGetAdmin("/admin/sellers", basic),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.statusCode == 200) {
                var snapData = parseAdminSellers(snapshot.data!.bodyBytes);
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    elevation: 10,
                    child: ScrollableTableView(
                      headerHeight: 50,
                      columns: const [
                        //sellers table
                        TableViewColumn(label: "SellerId"),
                        TableViewColumn(label: "Company"),
                        TableViewColumn(label: "Email"),
                        TableViewColumn(label: "Password"),
                        TableViewColumn(label: "Code"),
                        TableViewColumn(label: "Phone"),
                        TableViewColumn(label: "Point"),
                        TableViewColumn(label: "Trust"),
                      ],
                      rows: List.generate(
                        snapData.sellers.length,
                        (index) => TableViewRow(
                          onTap: () {
                            //chose seller trust
                            Get.defaultDialog(
                              title: "Update Seller Trust",
                              content: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      //update seller trust
                                      var result = await sendGetAdmin(
                                          "/admin/updateseller?sellerId=${snapData.sellers[index].sellerId}&trust=1",
                                          basic);
                                      if (result.statusCode == 200) {
                                        Get.back();
                                        Get.back();
                                        Get.toNamed("/adminsellers",
                                            arguments: basic);
                                        SnackMess(
                                            "Success",
                                            "Seller trust updated to true",
                                            Colors.green,
                                            SnackPosition.TOP,
                                            Icons.check_circle);
                                      } else {
                                        SnackMess(
                                            "Error",
                                            "Seller trust not updated",
                                            MyColors.red,
                                            SnackPosition.TOP,
                                            Icons.error);
                                      }
                                    },
                                    child: const Text("True"),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      var result = await sendGetAdmin(
                                          "/admin/updateseller?sellerId=${snapData.sellers[index].sellerId}&trust=0",
                                          basic);
                                      if (result.statusCode == 200) {
                                        Get.back();
                                        Get.back();
                                        Get.toNamed("/adminsellers",
                                            arguments: basic);
                                        SnackMess(
                                            "Success",
                                            "Seller trust updated to false",
                                            Colors.green,
                                            SnackPosition.TOP,
                                            Icons.check_circle);
                                      } else {
                                        SnackMess(
                                            "Error",
                                            "Seller trust not updated",
                                            MyColors.red,
                                            SnackPosition.TOP,
                                            Icons.error);
                                      }
                                    },
                                    child: const Text("False"),
                                  ),
                                ],
                              ),
                            );
                          },
                          cells: [
                            TableViewCell(
                              child: Text(
                                snapData.sellers[index].sellerId.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.sellers[index].company,
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.sellers[index].email,
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.sellers[index].password,
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.sellers[index].code.string,
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.sellers[index].phone,
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.sellers[index].point.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.sellers[index].trust.toString(),
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
