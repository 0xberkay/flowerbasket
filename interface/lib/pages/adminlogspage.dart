import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../client/admincli.dart';
import '../colors/colorsconf.dart';

class AdminLogs extends StatefulWidget {
  final String path;
  const AdminLogs({super.key, required this.path});

  @override
  State<AdminLogs> createState() => _AdminLogsState();
}

class _AdminLogsState extends State<AdminLogs> {
  String basic = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Logs'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: Get.height * 0.1,
          backgroundColor: MyColors.tertiary,
        ),
        body: FutureBuilder(
          future: sendGetAdmin("/admin/readlog?query=${widget.path}", basic),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.statusCode == 200) {
                List<String> data = List<String>.from(
                    json.decode(snapshot.data!.body).map((x) => x));
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: Get.width * 0.05,
                          right: Get.width * 0.05,
                          top: Get.height * 0.01,
                          bottom: Get.height * 0.01),
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          leading: const Icon(Icons.list),
                          title: Text(data[index]),
                        ),
                      ),
                    );
                  },
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
          },
        ));
  }
}
