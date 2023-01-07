import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import '../client/admincli.dart';
import '../client/client.dart';
import '../colors/colorsconf.dart';

class AdminComments extends StatefulWidget {
  const AdminComments({super.key});

  @override
  State<AdminComments> createState() => _AdminCommentsState();
}

class _AdminCommentsState extends State<AdminComments> {
  String basic = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Comments'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: Get.height * 0.1,
          backgroundColor: MyColors.tertiary,
        ),
        body: FutureBuilder(
          future: sendGetAdmin("/admin/comments", basic),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.statusCode == 200) {
                var snapData = parseAdminComments(snapshot.data!.bodyBytes);
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
                                  "/admin/altercomments", basic);
                              var mess = parseMess(result.bodyBytes);
                              if (result.statusCode == 200) {
                                Get.back();
                                Get.toNamed("/admincomments", arguments: basic);
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
                            child: const Text("Alter Comments")),
                        Expanded(
                          child: ScrollableTableView(
                            headerHeight: 50,
                            columns: const [
                              //Comments table
                              TableViewColumn(label: "CommentId"),
                              TableViewColumn(label: "ProductId"),
                              TableViewColumn(label: "UserId"),
                              TableViewColumn(label: "Point"),
                              TableViewColumn(label: "Comment"),
                              TableViewColumn(label: "OrderId"),
                            ],
                            rows: List.generate(
                              snapData.comments.length,
                              (index) => TableViewRow(
                                cells: [
                                  TableViewCell(
                                    child: Text(
                                      snapData.comments[index].commentId
                                          .toString(),
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.comments[index].productId
                                          .toString(),
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.comments[index].userId
                                          .toString(),
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.comments[index].point.toString(),
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.comments[index].comment
                                          .toString(),
                                    ),
                                  ),
                                  TableViewCell(
                                    child: Text(
                                      snapData.comments[index].orderId
                                          .toString(),
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
