import 'package:flowerbasket/client/client.dart';
import 'package:flowerbasket/colors/colorsconf.dart';
import 'package:flowerbasket/pages/usermainpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/widgets.dart';

class SellerDetail extends StatefulWidget {
  const SellerDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<SellerDetail> createState() => _SellerDetailState();
}

class _SellerDetailState extends State<SellerDetail> {
  @override
  Widget build(BuildContext context) {
    var data = Get.arguments;
    // ignore: no_leading_underscores_for_local_identifiers
    Widget _buildList() {
      return FutureBuilder(
          future: sendGet("/all/sellerstatics?c=${data[1]}"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.statusCode == 200) {
                var statics = parseStatics(snapshot.data!.bodyBytes);
                return ListTile(
                  leading: const Icon(Icons.storefront,
                      size: 30, color: Colors.black),
                  title: Text(Get.arguments[0],
                      style: const TextStyle(fontSize: 25)),
                  subtitle: starBuilder(statics.maxPoint),
                  trailing: Column(
                    children: [
                      const Icon(
                        Icons.data_saver_on_rounded,
                      ),
                      Text("${statics.count} product",
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                );
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
          });
    }

    return Scaffold(
        appBar: AppBar(
          title: _buildList(),
          backgroundColor: MyColors.tertiary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: Get.height * 0.1,
        ),
        // ignore: prefer_interpolation_to_compose_strings
        body: UserMainPage(path: "/all/company?c=" + data[0]));
  }
}
