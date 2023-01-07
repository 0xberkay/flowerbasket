import 'package:flowerbasket/colors/colorsconf.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../client/client.dart';
import 'categorydetailpage.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: sendGet("/all/categories"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.statusCode == 200) {
                var categories = parseCategories(snapshot.data!.bodyBytes);
                return GridView.builder(
                    itemCount: categories.categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(CategoryDetail(
                            category: categories.categories[index],
                          ));
                        },
                        child: Card(
                          color: randomColor(),
                          elevation: 10,
                          child: Column(
                            children: [
                              Icon(
                                Icons.data_object_outlined,
                                size: Get.width * 0.2,
                              ),
                              SizedBox(
                                height: Get.height * 0.02,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: MyColors.back,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      categories.categories[index].categoryName,
                                      style: TextStyle(
                                          fontSize: Get.width * 0.05)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: Text("Error"),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
