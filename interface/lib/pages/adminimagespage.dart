import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../client/admincli.dart';
import '../colors/colorsconf.dart';
import '../helper/ontapimage.dart';

class AdminImages extends StatefulWidget {
  const AdminImages({super.key});

  @override
  State<AdminImages> createState() => _AdminImagesState();
}

class _AdminImagesState extends State<AdminImages> {
  String basic = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Images'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: Get.height * 0.1,
          backgroundColor: MyColors.tertiary,
        ),
        body: FutureBuilder(
          future: sendGetAdmin("/admin/images", basic),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.statusCode == 200) {
                var snapData = parseAdminImages(snapshot.data!.bodyBytes);
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemCount: snapData.images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  onTapImage(snapData.images[index].link);
                                },
                                child: Container(
                                  height: Get.height * 0.2,
                                  width: Get.width * 0.2,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          snapData.images[index].link),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Card(
                                  color: MyColors.tertiary,
                                  elevation: 30,
                                  child: Column(
                                    children: [
                                      Text(
                                          "ImageId : ${snapData.images[index].imageId}"),
                                      Text(
                                          "Link : ${snapData.images[index].link}"),
                                      Text(
                                          "SellerId : ${snapData.images[index].sellerId}"),
                                    ],
                                  )),
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
          },
        ));
  }
}
