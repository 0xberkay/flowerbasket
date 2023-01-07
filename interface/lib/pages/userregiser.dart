import 'package:flowerbasket/client/client.dart';
import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flowerbasket/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../colors/colorsconf.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({
    Key? key,
  }) : super(key: key);

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  bool _ispassword = true;

  final _username = TextEditingController();
  final _email = TextEditingController();
  final _passwordAgain = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordAgain.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Get.height * 0.1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
          ),
        ),
        title: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      //get username , password and password again , email from user
      //check if the email is valid
      //check if the password is valid
      //check if the password and password again are same
      //check if the username is valid
      //if all of them are valid , send the data to the database
      //if not , show the error

      body: Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: Get.height * 0.02,
            ),
            myField('Username', Icons.person, _username, false, false),
            myField('Email', Icons.email, _email, false, false),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      myField('Password', Icons.lock, _password, _ispassword,
                          false),
                      myField('Password Again', Icons.lock_reset_sharp,
                          _passwordAgain, _ispassword, false),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _ispassword ? Icons.visibility_off : Icons.visibility,
                    color: MyColors.secondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _ispassword = !_ispassword;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 15.0,
                right: 15.0,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  //validate the email , password , password again , username
                  //send the data to the server
                  var result = await sendPost("/user/register", {
                    "username": _username.text,
                    "password": _password.text,
                    "confirm": _passwordAgain.text,
                    "email": _email.text
                  });

                  var message = parseMess(result.bodyBytes);

                  if (result.statusCode == 200) {
                    SnackMess("Success", message.message, Colors.green,
                        SnackPosition.TOP, Icons.cloud_done);
                    Get.offAllNamed("/userlogin");
                  } else {
                    SnackMess("Error", message.message, MyColors.red,
                        SnackPosition.TOP, Icons.error);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.secondary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  minimumSize: Size(Get.width * 0.8, Get.height * 0.07),
                  maximumSize: Size(Get.width * 0.8, Get.height * 0.07),
                ),
                child: const Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
