import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flowerbasket/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import '../client/admincli.dart';
import '../colors/colorsconf.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Login'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: Get.height * 0.1,
          backgroundColor: MyColors.tertiary,
        ),
        body: Column(
          children: [
            myField("Username", Icons.admin_panel_settings_sharp, _username,
                false, false),
            myField("Password", Icons.lock, _password, true, false),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: (() async {
                  var basic =
                      "Basic ${base64.encode(utf8.encode("${_username.text}:${_password.text}"))}";
                  var result = await sendGetAdmin("/admin/ok", basic);
                  if (result.statusCode == 200) {
                    Get.offAllNamed("/adminhome", arguments: basic);
                    SnackMess("Success", "Login Successful", Colors.green,
                        SnackPosition.TOP, Icons.check_circle_outline);
                  } else if (result.statusCode == 401) {
                    SnackMess("Error", "unauthorized", MyColors.red,
                        SnackPosition.TOP, Icons.error_outline);
                  } else if (result.statusCode == 503) {
                    SnackMess("Error", "Service Unavailable", MyColors.red,
                        SnackPosition.TOP, Icons.error_outline);
                  } else {
                    SnackMess("Error", "Something went wrong", MyColors.red,
                        SnackPosition.TOP, Icons.error_outline);
                  }
                }),
                child: const Text('Login')),
          ],
        ));
  }
}
