import 'package:flowerbasket/client/client.dart';
import 'package:flowerbasket/colors/colorsconf.dart';
import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flowerbasket/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';

class UserOrders extends StatelessWidget {
  const UserOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: MyColors.tertiary,
        toolbarHeight: Get.height * 0.1,
      ),
      body: FutureBuilder(
        future: sendGet("/user/orders"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.statusCode == 200) {
              var orders = parseOrders(snapshot.data!.bodyBytes);
              if (orders.orders.isEmpty) {
                return const Center(
                  child: Text("No orders found"),
                );
              } else {
                return ListView.builder(
                  itemCount: orders.orders.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Image.network(
                                orders.orders[index].link,
                              ),
                              title: Text(orders.orders[index].productName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  orders.orders[index].createdAt.toString()),
                              trailing: Text(
                                "${orders.orders[index].price} TL",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: MyColors.bold,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Count: ${orders.orders[index].productCount}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.01,
                            ),
                            statuContainer(orders.orders[index].statuName,
                                orders.orders[index].statuId),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            //message
                            Container(
                              decoration: BoxDecoration(
                                color: MyColors.bold,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Message: ${orders.orders[index].message}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            //add comment
                            ElevatedButton(
                              onPressed: orders.orders[index].statuId == 4
                                  ? () {
                                      int ratingInt = 0;
                                      TextEditingController commentController =
                                          TextEditingController();
                                      Get.defaultDialog(
                                        title: "Add Comment",
                                        content: Column(
                                          children: [
                                            RatingBar.builder(
                                              minRating: 1,
                                              maxRating: 5,
                                              direction: Axis.horizontal,
                                              itemCount: 5,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                ratingInt = rating.toInt();
                                              },
                                            ),
                                            TextField(
                                              controller: commentController,
                                              decoration: const InputDecoration(
                                                hintText: "Comment",
                                              ),
                                            ),
                                          ],
                                        ),
                                        textConfirm: "Add",
                                        confirmTextColor: Colors.white,
                                        onConfirm: () async {
                                          var result = await sendPostWithB(
                                              "/user/addcomment?orderId=${orders.orders[index].orderId}&point=$ratingInt",
                                              {
                                                "comment":
                                                    commentController.text
                                              });
                                          var message =
                                              parseMess(result.bodyBytes);
                                          if (result.statusCode == 200) {
                                            Get.back();
                                            Get.offAndToNamed("/userorders");

                                            SnackMess(
                                                "Success",
                                                message.message,
                                                Colors.green,
                                                SnackPosition.TOP,
                                                Icons.check_circle);
                                          } else {
                                            SnackMess(
                                                "Error",
                                                message.message,
                                                Colors.red,
                                                SnackPosition.TOP,
                                                Icons.error);
                                          }
                                        },
                                      );
                                    }
                                  : null,
                              child: const Text("Add Comment"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              return const Center(
                child: Text("No orders found"),
              );
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
