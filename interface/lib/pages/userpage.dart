import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flowerbasket/pages/categoriespage.dart';
import 'package:flowerbasket/pages/usercart.dart';
import 'package:flowerbasket/pages/usersearchpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../colors/colorsconf.dart';
import 'usermainpage.dart';
import 'userdataspage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          BottomBarItem(iconData: Icons.home),
          BottomBarItem(iconData: Icons.category),
          BottomBarItem(iconData: Icons.search, iconSize: 50),
          BottomBarItem(iconData: Icons.shopping_cart_rounded),
          BottomBarItem(iconData: Icons.person),
        ],
      ),
      body: <Widget>[
        const UserMainPage(path: "/all/products"),
        const CategoriesPage(),
        const SearchPage(),
        const CartPage(),
        const UserDatasPage(),
      ][currentPageIndex],
    );
  }
}
