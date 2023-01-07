import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flowerbasket/client/client.dart';
import 'package:flowerbasket/pages/sellergallery.dart';
import 'package:flowerbasket/pages/sellerorderspage.dart';
import 'package:flowerbasket/pages/sellerproductspage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../colors/colorsconf.dart';
import '../main.dart';

class SellerHome extends StatefulWidget {
  const SellerHome({super.key});

  @override
  State<SellerHome> createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  int currentPageIndex = Get.arguments ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(children: [
          Image.asset(
            "assets/logo.png",
            height: Get.height * 0.08,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          const Text(
            "FlowerBasket",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ]),
        toolbarHeight: Get.height * 0.1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
          ),
        ),
      ),
      bottomNavigationBar: BottomBarBubble(
        bubbleSize: 15,
        color: MyColors.primary,
        onSelect: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        items: [
          BottomBarItem(iconData: Icons.data_saver_off_sharp),
          BottomBarItem(iconData: Icons.photo_library),
          BottomBarItem(iconData: Icons.local_shipping_rounded),
          BottomBarItem(iconData: Icons.business_center_rounded),
        ],
      ),
      body: <Widget>[
        const SellerProductsPage(),
        const GalleryPage(),
        const SellerOrdersPage(),
        const SellerDatas(),
      ][currentPageIndex],
    );
  }
}

class SellerDatas extends StatelessWidget {
  const SellerDatas({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 20,
        ),
        //change email
        ListTile(
          leading: const Icon(Icons.business_center_outlined),
          title: const Text('Profile'),
          subtitle: const Text('Update your profile'),
          onTap: () {
            Get.toNamed("/sellerprofile");
          },
        ),
        ListTile(
          leading: const Icon(Icons.download),
          title: const Text('Download'),
          subtitle: const Text('Download orders as Excel'),
          onTap: () async {
            await createExcel("/seller/ordersexcel", "ordersexcel.xlsx");
          },
        ),
        ListTile(
          leading: const Icon(Icons.currency_exchange_outlined),
          title: const Text('Download'),
          subtitle: const Text('Download orders status as Excel'),
          onTap: () async {
            await createExcel("/seller/orderscexcel", "ordersstatusexcel.xlsx");
          },
        ),
        //change password
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Change Password'),
          subtitle: const Text('Change your password'),
          onTap: () {
            Get.toNamed("/sellerchange");
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          subtitle: const Text('Logout from your account'),
          onTap: () {
            BoxData.erase();
            Get.offAllNamed("/main");
          },
        ),
      ],
    );
  }
}
