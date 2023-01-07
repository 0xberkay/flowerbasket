import 'package:flowerbasket/client/client.dart';
import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flowerbasket/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../colors/colorsconf.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class SellerProfilePage extends StatefulWidget {
  const SellerProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<SellerProfilePage> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfilePage> {
  final _email = TextEditingController();
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Profile'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight: Get.height * 0.1,
        backgroundColor: MyColors.tertiary,
      ),
      body: FutureBuilder(
        future: sendGet("/seller/profile"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.statusCode == 200) {
              var user = parseUserData(snapshot.data!.bodyBytes);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    myFieldNoEdit(user.username, Icons.business,
                        TextEditingController(), false, true),
                    myField(user.email, Icons.email, _email, false, true),
                    ElevatedButton(
                      onPressed: () {
                        if (_email.text.isEmpty) {
                          SnackMess(
                            "Error",
                            "Field is empty",
                            MyColors.red,
                            SnackPosition.TOP,
                            Icons.error,
                          );
                          return;
                        }

                        //are you sure?
                        Get.defaultDialog(
                          title: "Are you sure?",
                          middleText: "Do you want to update your profile?",
                          textConfirm: "Yes",
                          textCancel: "No",
                          confirmTextColor: Colors.black,
                          cancelTextColor: Colors.black,
                          onConfirm: () async {
                            //update
                            var result = await sendPostWithB("/seller/update", {
                              "email": _email.text,
                            });
                            Message message;
                            message = parseMess(result.bodyBytes);

                            if (result.statusCode == 200) {
                              BoxData.write("token", message.message);
                              Get.back();
                              Get.back();
                              SnackMess(
                                "Success",
                                "Profile updated",
                                Colors.green,
                                SnackPosition.TOP,
                                Icons.check,
                              );
                              //refresh page
                            } else {
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
                      child: const Text("Update"),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text("Error"),
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
