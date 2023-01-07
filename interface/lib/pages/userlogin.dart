import 'package:flowerbasket/client/client.dart';
import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flowerbasket/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../colors/colorsconf.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({
    Key? key,
    required this.type,
  }) : super(key: key);

  final String type;
  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  bool _passwordVisible = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: Get.height * 0.2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
            ),
          ),
          title: Text(
            'Welcome Back ${widget.type}',
            style: const TextStyle(
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
              SizedBox(height: Get.height * 0.01),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: Get.height * 0.1,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: MyColors.quaternary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Email',
                        focusedErrorBorder: InputBorder.none,
                        icon: Icon(Icons.email, color: MyColors.secondary),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                ),
                child: Container(
                  height: Get.height * 0.1,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: MyColors.quaternary,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: Get.width * 0.05,
                      right: Get.width * 0.05,
                    ),
                    child: TextField(
                      controller: _password,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Password',
                        icon: const Icon(Icons.lock, color: MyColors.secondary),
                        suffix: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: MyColors.secondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Get.toNamed("/${widget.type}forgot");
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: MyColors.bold,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: Get.width * 0.05,
                  right: Get.width * 0.05,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    //if email is valid and password length is greater than 6

                    var result = await sendPost("/${widget.type}/login",
                        {"email": _email.text, "password": _password.text});

                    var message = parseMess(result.bodyBytes);
                    if (result.statusCode == 200) {
                      BoxData.write("token", message.message);
                      SnackMess("Success", "Login Successful", Colors.green,
                          SnackPosition.BOTTOM, Icons.cloud_done);
                      Get.offAllNamed("/${widget.type}home");
                    } else {
                      SnackMess("Error", message.message, MyColors.red,
                          SnackPosition.TOP, Icons.error);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(Get.width * 0.8, Get.height * 0.07),
                    maximumSize: Size(Get.width * 0.8, Get.height * 0.07),
                  ),
                  child: const Text('Login'),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.toNamed("/${widget.type}register");
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                            color: MyColors.secondary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ],
          ),
        ));
  }
}
