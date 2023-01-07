import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import '../client/admincli.dart';
import '../colors/colorsconf.dart';

class AdminMessages extends StatefulWidget {
  const AdminMessages({super.key});

  @override
  State<AdminMessages> createState() => _AdminMessagesState();
}

class _AdminMessagesState extends State<AdminMessages> {
  String basic = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Messages'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: Get.height * 0.1,
          backgroundColor: MyColors.tertiary,
        ),
        body: FutureBuilder(
          future: sendGetAdmin("/admin/messages", basic),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.statusCode == 200) {
                var snapData = parseAdminMessages(snapshot.data!.bodyBytes);
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    elevation: 10,
                    child: ScrollableTableView(
                      headerHeight: 50,
                      columns: const [
                        //Messages table
                        TableViewColumn(label: "MessageId"),
                        TableViewColumn(label: "CartId"),
                        TableViewColumn(label: "Message"),
                        TableViewColumn(label: "NameInMessage"),
                      ],
                      rows: List.generate(
                        snapData.cartMessages.length,
                        (index) => TableViewRow(
                          cells: [
                            TableViewCell(
                              child: Text(
                                snapData.cartMessages[index].messageId
                                    .toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.cartMessages[index].cartId.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.cartMessages[index].message,
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.cartMessages[index].nameInMessage,
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
