import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import '../client/admincli.dart';
import '../colors/colorsconf.dart';

class AdminCatagories extends StatefulWidget {
  const AdminCatagories({super.key});

  @override
  State<AdminCatagories> createState() => _AdminCatagoriesState();
}

class _AdminCatagoriesState extends State<AdminCatagories> {
  String basic = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Catagories'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: Get.height * 0.1,
          backgroundColor: MyColors.tertiary,
        ),
        body: FutureBuilder(
          future: sendGetAdmin("/admin/categories", basic),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.statusCode == 200) {
                var snapData = parseAdminCatagories(snapshot.data!.bodyBytes);
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    elevation: 10,
                    child: ScrollableTableView(
                      headerHeight: 50,
                      columns: const [
                        //Catagories table
                        TableViewColumn(label: "CatagoryId"),
                        TableViewColumn(label: "CatagoryName"),
                      ],
                      rows: List.generate(
                        snapData.categories.length,
                        (index) => TableViewRow(
                          cells: [
                            TableViewCell(
                              child: Text(
                                snapData.categories[index].categoryId
                                    .toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.categories[index].categoryName,
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
