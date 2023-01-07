import 'package:flowerbasket/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../client/client.dart';
import '../colors/colorsconf.dart';
import '../helper/snackmess.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({
    Key? key,
    required this.type,
  }) : super(key: key);

  final String type;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _passwordAgain = TextEditingController();
  final _password = TextEditingController();
  bool ispassword = true;
  @override
  void dispose() {
    _password.dispose();
    _passwordAgain.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change password"),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight: Get.height * 0.1,
        backgroundColor: MyColors.tertiary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    myField(
                        'Password', Icons.lock, _password, ispassword, false),
                    myField('Password Again', Icons.lock_reset_sharp,
                        _passwordAgain, ispassword, false),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  ispassword ? Icons.visibility_off : Icons.visibility,
                  color: MyColors.secondary,
                ),
                onPressed: () {
                  setState(() {
                    ispassword = !ispassword;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              if (_password.text.isEmpty || _passwordAgain.text.isEmpty) {
                SnackMess(
                  "Error",
                  "Please fill all fields",
                  MyColors.red,
                  SnackPosition.TOP,
                  Icons.error,
                );
              } else if (_password.text != _passwordAgain.text) {
                SnackMess(
                  "Error",
                  "Passwords are not same",
                  MyColors.red,
                  SnackPosition.TOP,
                  Icons.error,
                );
              } else {
                var response =
                    await sendPostWithB("/${widget.type}/changepass", {
                  "password": _password.text,
                  "confirm": _passwordAgain.text,
                });
                if (response.statusCode == 200) {
                  Get.back();
                  SnackMess(
                    "Success",
                    "Password changed",
                    Colors.green,
                    SnackPosition.TOP,
                    Icons.check,
                  );
                } else {
                  var message = parseMess(response.bodyBytes);
                  SnackMess(
                    "Error",
                    message.message,
                    MyColors.red,
                    SnackPosition.TOP,
                    Icons.error,
                  );
                }
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}
