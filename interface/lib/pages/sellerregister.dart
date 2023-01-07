import 'package:flowerbasket/client/client.dart';
import 'package:flowerbasket/colors/colorsconf.dart';
import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flowerbasket/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SellerRegister extends StatefulWidget {
  const SellerRegister({
    Key? key,
  }) : super(key: key);

  @override
  State<SellerRegister> createState() => _SellerRegisterState();
}

class _SellerRegisterState extends State<SellerRegister> {
  bool _ispassword = true;

  final _company = TextEditingController();
  final _email = TextEditingController();
  final _passwordAgain = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordAgain.dispose();
    _company.dispose();
    _phone.dispose();
    super.dispose();
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
          title: const Text(
            'Register as a Seller',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: Get.height * 0.02,
            ),
            myField("Company Name", Icons.business, _company, false, false),
            myField("Email", Icons.email, _email, false, false),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 15.0,
                right: 15.0,
              ),
              child: Container(
                height: Get.height * 0.1,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: MyColors.quaternary,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: IntlPhoneField(
                    controller: _phone,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counter: SizedBox.shrink(),
                      labelText: 'Phone Number',
                      focusedErrorBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                    ),
                    initialCountryCode: 'TR',
                  ),
                ),
              ),
            ),
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
                  //send the data to the server

                  var result = await sendPost("/seller/register", {
                    "company": _company.text,
                    "password": _password.text,
                    "confirm": _passwordAgain.text,
                    "phone": _phone.text,
                    "email": _email.text
                  });
                  var message = parseMess(result.bodyBytes);

                  if (result.statusCode == 200) {
                    SnackMess("Success", message.message, Colors.green,
                        SnackPosition.TOP, Icons.cloud_done);
                    Get.offAllNamed("/sellerlogin");
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
        ));
  }
}
