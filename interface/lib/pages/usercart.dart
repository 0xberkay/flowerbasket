import 'package:flowerbasket/client/client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../colors/colorsconf.dart';
import '../helper/snackmess.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: sendGet("/user/getcart"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.statusCode == 200) {
              var data = parseCart(snapshot.data!.bodyBytes);

              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: data.products.length,
                        itemBuilder: (context, index) {
                          int count = data.products[index].count;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 10,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Image.network(
                                        data.products[index].link),
                                    title:
                                        Text(data.products[index].productName),
                                    trailing: Text(
                                        "${data.products[index].price} TL"),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          var result = await sendGet(
                                              "/user/updatecart?id=${data.products[index].productId}&count=-1");
                                          if (result.statusCode == 200) {
                                            setState(() {
                                              count =
                                                  data.products[index].count--;
                                            });
                                          } else {
                                            var message =
                                                parseMess(result.bodyBytes);
                                            SnackMess(
                                              "Error",
                                              message.message,
                                              MyColors.red,
                                              SnackPosition.TOP,
                                              Icons.error,
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                      Text(count.toString()),
                                      IconButton(
                                        onPressed: () async {
                                          var result = await sendGet(
                                              "/user/updatecart?id=${data.products[index].productId}&count=1");
                                          if (result.statusCode == 200) {
                                            setState(() {
                                              count =
                                                  data.products[index].count++;
                                            });
                                          } else {
                                            var message =
                                                parseMess(result.bodyBytes);
                                            SnackMess(
                                              "Error",
                                              message.message,
                                              MyColors.red,
                                              SnackPosition.TOP,
                                              Icons.error,
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          var result = await sendGet(
                                              "/user/deletefromcart?id=${data.products[index].productId}");
                                          if (result.statusCode == 200) {
                                            setState(() {
                                              data.products.removeAt(index);
                                            });
                                          } else {
                                            var message =
                                                parseMess(result.bodyBytes);
                                            SnackMess(
                                              "Error",
                                              message.message,
                                              MyColors.red,
                                              SnackPosition.TOP,
                                              Icons.error,
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.delete,
                                            color: MyColors.red),
                                      ),
                                    ],
                                  ),
                                  //add message
                                  SizedBox(
                                    height: Get.height * 0.01,
                                  ),
                                  ListTile(
                                    title: const Text("Message :"),
                                    subtitle: Card(
                                        elevation: 20,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                data.products[index]
                                                    .nameInMessage,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  data.products[index].message),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    final message =
                                                        TextEditingController();
                                                    final nameInMessage =
                                                        TextEditingController();

                                                    Get.defaultDialog(
                                                      title: "Add Message",
                                                      content: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            TextField(
                                                              controller:
                                                                  nameInMessage,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    "Name",
                                                              ),
                                                            ),
                                                            TextField(
                                                              controller:
                                                                  message,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    "Message",
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      textConfirm: "Add",
                                                      confirmTextColor:
                                                          Colors.white,
                                                      onConfirm: () async {
                                                        var result =
                                                            await sendPostWithB(
                                                                "/user/addmessage?c=${data.products[index].cartId}",
                                                                {
                                                              "message":
                                                                  message.text,
                                                              "name":
                                                                  nameInMessage
                                                                      .text,
                                                            });
                                                        if (result.statusCode ==
                                                            200) {
                                                          setState(() {
                                                            data.products[index]
                                                                    .message =
                                                                message.text;
                                                            data.products[index]
                                                                    .nameInMessage =
                                                                nameInMessage
                                                                    .text;
                                                          });
                                                          Get.back();
                                                          SnackMess(
                                                            "Success",
                                                            "Message Added",
                                                            Colors.green,
                                                            SnackPosition.TOP,
                                                            Icons.check,
                                                          );
                                                        } else {
                                                          var message =
                                                              parseMess(result
                                                                  .bodyBytes);
                                                          SnackMess(
                                                            "Error",
                                                            message.message,
                                                            MyColors.red,
                                                            SnackPosition.TOP,
                                                            Icons.error,
                                                          );
                                                        }
                                                      },
                                                    );
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                ),
                                                //delete message
                                                TextButton(
                                                  onPressed: () async {
                                                    var result = await sendGet(
                                                        "/user/deletemessage?c=${data.products[index].cartId}");
                                                    if (result.statusCode ==
                                                        200) {
                                                      setState(() {
                                                        data.products[index]
                                                            .message = "";
                                                      });
                                                    } else {
                                                      var message = parseMess(
                                                          result.bodyBytes);
                                                      SnackMess(
                                                        "Error",
                                                        message.message,
                                                        MyColors.red,
                                                        SnackPosition.TOP,
                                                        Icons.error,
                                                      );
                                                    }
                                                  },
                                                  child: const Text(
                                                    "Delete Message",
                                                    style: TextStyle(
                                                        color: MyColors.red,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: Get.height * 0.01,
                        top: 10,
                        left: Get.width * 0.08,
                        right: Get.width * 0.08),
                    child: Card(
                      elevation: 15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Total", style: TextStyle(fontSize: 20)),
                          Text("${data.total} TL",
                              style: const TextStyle(fontSize: 20)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: data.total <= 0
                                ? null
                                : () {
                                    printError(info: "total: ${data.total}");
                                    Get.toNamed("/userpayment");
                                  },
                            child: Row(
                              children: [
                                const Icon(Icons.payments_outlined),
                                SizedBox(
                                  width: Get.width * 0.02,
                                ),
                                const Text("Pay"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text("No data"),
              );
            }
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
