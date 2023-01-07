import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import '../client/admincli.dart';
import '../colors/colorsconf.dart';

class AdminStatus extends StatefulWidget {
  const AdminStatus({super.key});

  @override
  State<AdminStatus> createState() => _AdminStatusState();
}

class _AdminStatusState extends State<AdminStatus> {
  String basic = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Status'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: Get.height * 0.1,
          backgroundColor: MyColors.tertiary,
        ),
        body: FutureBuilder(
          future: sendGetAdmin("/admin/status", basic),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.statusCode == 200) {
                var snapData = parseAdminStatus(snapshot.data!.bodyBytes);
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    elevation: 10,
                    child: ScrollableTableView(
                      headerHeight: 50,
                      columns: const [
                        //Status table
                        TableViewColumn(label: "StatusId"),
                        TableViewColumn(label: "StatusName"),
                      ],
                      rows: List.generate(
                        snapData.status.length,
                        (index) => TableViewRow(
                          cells: [
                            TableViewCell(
                              child: Text(
                                snapData.status[index].statuId.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.status[index].statuName,
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
