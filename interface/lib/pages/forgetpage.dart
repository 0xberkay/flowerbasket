import 'package:flowerbasket/client/client.dart';
import 'package:flowerbasket/colors/colorsconf.dart';
import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/widgets.dart';

class ForgetPage extends StatelessWidget {
  const ForgetPage({
    Key? key,
    required this.type,
  }) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: Get.height * 0.2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
            ),
          ),
          title: const Text(
            'Forgot Password?\n don\'t worry',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              SizedBox(height: Get.height * 0.02),
              const Icon(
                Icons.lock,
                size: 100,
                color: MyColors.bold,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Enter your email address. You will receive a link to create a new password via email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: MyColors.bold,
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              myField("Email", Icons.email, email, false, false),
              SizedBox(height: Get.height * 0.02),
              Padding(
                padding: EdgeInsets.only(
                  left: Get.width * 0.05,
                  right: Get.width * 0.05,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.secondary,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    minimumSize: Size(Get.width * 0.8, Get.height * 0.07),
                    maximumSize: Size(Get.width * 0.8, Get.height * 0.07),
                  ),
                  onPressed: () async {
                    var result =
                        await sendPost("/$type/forget", {"email": email.text});
                    var message = parseMess(result.bodyBytes);

                    if (result.statusCode == 200) {
                      Get.back();
                      SnackMess("Success", message.message, Colors.green,
                          SnackPosition.TOP, Icons.cloud_done_rounded);
                    } else {
                      SnackMess("Error", message.message, MyColors.red,
                          SnackPosition.TOP, Icons.error);
                    }
                  },
                  child: const Text(
                    "Send",
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
