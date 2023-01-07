import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../colors/colorsconf.dart';

class UserType extends StatefulWidget {
  const UserType({super.key});

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  @override
  Widget build(BuildContext context) {
    // Select user or seller

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Get.height * 0.3,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Hello\nhow do you \nwant to continue ?',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                selectButton(str: 'User'),
                const SizedBox(width: 20),
                selectButton(str: 'Seller'),
              ],
            ),
            const SizedBox(height: 20),
            selectButton(str: 'Admin')
          ],
        ),
      ),
    );
  }
}

Widget selectButton({required String str}) {
  return ElevatedButton(
      onPressed: () {
        Get.toNamed("/${str.toLowerCase()}login");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.secondary,
        //text color
        foregroundColor: Colors.white,
        enableFeedback: true,
        textStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        maximumSize: Size(Get.width * 0.4, Get.height * 0.2),
        minimumSize: Size(Get.width * 0.3, Get.height * 0.1),
      ),
      child: Text(
        str,
      ));
}
