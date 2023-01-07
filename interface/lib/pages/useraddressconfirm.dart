import 'package:flowerbasket/client/client.dart';
import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flowerbasket/models/address.dart';
import 'package:flowerbasket/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../colors/colorsconf.dart';

class AddressConfirm extends StatefulWidget {
  const AddressConfirm({
    Key? key,
  }) : super(key: key);

  @override
  State<AddressConfirm> createState() => _AddressConfirmState();
}

class _AddressConfirmState extends State<AddressConfirm> {
  final _street = TextEditingController();
  final _state = TextEditingController();
  final _zipCode = TextEditingController();
  final _detail = TextEditingController();
  final _city = TextEditingController();
  AddressElement data = Get.arguments;
  _setAddress() {
    _street.text = data.street;
    _state.text = data.state;
    _zipCode.text = data.zipCode;
    _detail.text = data.detail;
    _city.text = data.city;
  }

  @override
  void dispose() {
    _state.dispose();
    _detail.dispose();
    _zipCode.dispose();
    _street.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setAddress();
    return Scaffold(
      appBar: AppBar(
          title: const Text('Confirm Address'),
          toolbarHeight: Get.height * 0.1,
          backgroundColor: MyColors.tertiary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          )),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          myField("City", Icons.location_city, _city, false, false),
          myField("Street", Icons.location_on, _street, false, false),
          myField("State", Icons.location_on, _state, false, false),
          myFieldNumber("Zip Code", Icons.location_on, _zipCode, false, false),
          myField("Detail", Icons.location_on, _detail, false, false),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              onPressed: () async {
                var result = await sendPostWithB("/user/addaddress", {
                  "street": _street.text,
                  "city": _city.text,
                  "zipCode": _zipCode.text,
                  "state": _state.text,
                  "detail": _detail.text,
                  "latitude": data.latitude.toString(),
                  "longitude": data.longitude.toString(),
                });

                var message = parseMess(result.bodyBytes);
                if (result.statusCode == 200) {
                  Get.back();
                  Get.back();
                  Get.offAndToNamed("/useraddress");
                  SnackMess("Success", message.message, Colors.green,
                      SnackPosition.TOP, Icons.check_circle);
                } else {
                  SnackMess("Error", message.message, MyColors.red,
                      SnackPosition.TOP, Icons.error);
                }
              },
              child: const Text('Confirm'),
            ),
          ),
        ],
      ),
    );
  }
}
