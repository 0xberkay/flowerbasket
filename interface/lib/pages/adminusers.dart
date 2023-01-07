import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import '../client/admincli.dart';
import '../colors/colorsconf.dart';

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  String basic = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Users'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: Get.height * 0.1,
          backgroundColor: MyColors.tertiary,
        ),
        body: FutureBuilder(
          future: sendGetAdmin("/admin/users", basic),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.statusCode == 200) {
                var snapData = parseAdminUsers(snapshot.data!.bodyBytes);
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    elevation: 10,
                    child: ScrollableTableView(
                      headerHeight: 50,
                      columns: const [
                        TableViewColumn(label: "Id"),
                        TableViewColumn(label: "Username"),
                        TableViewColumn(label: "Email"),
                        TableViewColumn(label: "Password"),
                        TableViewColumn(label: "Code"),
                      ],
                      rows: List.generate(
                        snapData.users.length,
                        (index) => TableViewRow(
                          cells: [
                            TableViewCell(
                              child: Text(
                                snapData.users[index].userId.toString(),
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.users[index].username,
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.users[index].email,
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.users[index].password,
                              ),
                            ),
                            TableViewCell(
                              child: Text(
                                snapData.users[index].code.string,
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
