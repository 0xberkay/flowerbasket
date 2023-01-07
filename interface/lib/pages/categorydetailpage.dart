import 'package:flowerbasket/pages/usermainpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../colors/colorsconf.dart';
import '../models/catagories.dart';

class CategoryDetail extends StatelessWidget {
  const CategoryDetail({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(category.categoryName),
          toolbarHeight: Get.height * 0.1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          backgroundColor: MyColors.tertiary,
        ),
        body: UserMainPage(
          path: "/all/selected?c=${category.categoryId}",
        ));
  }
}
