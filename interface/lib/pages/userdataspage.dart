import 'package:flowerbasket/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDatasPage extends StatelessWidget {
  const UserDatasPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      //center the list
      children: [
        ListTile(
            title: const Text('Profile'),
            subtitle: const Text('Update your profile'),
            leading: const Icon(Icons.person),
            onTap: () {
              Get.toNamed("/userprofile");
            }),
        //change password
        ListTile(
          title: const Text('Change Password'),
          subtitle: const Text('Change your password'),
          leading: const Icon(Icons.lock),
          onTap: () {
            Get.toNamed("/userchange");
          },
        ),
        //address
        ListTile(
          title: const Text('Address'),
          subtitle: const Text('Update your address'),
          leading: const Icon(Icons.location_on),
          onTap: () {
            Get.toNamed("/useraddress");
          },
        ),
        //orders
        ListTile(
          title: const Text('Orders'),
          subtitle: const Text('See your orders'),
          leading: const Icon(Icons.shopping_cart),
          onTap: () {
            Get.toNamed("/userorders");
          },
        ),
        //logout
        ListTile(
          title: const Text('Logout'),
          subtitle: const Text('Logout from your account'),
          leading: const Icon(Icons.logout),
          onTap: () {
            BoxData.erase();
            Get.offAllNamed("/main");
          },
        ),
      ],
    );
  }
}
