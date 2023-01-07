import 'package:flowerbasket/pages/usermainpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = "";
  Widget? child;
  @override
  void dispose() {
    super.dispose();
    child = null;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: TextField(
            onSubmitted: (value) {
              setState(() {
                child = UserMainPage(path: "/all/search?q=$value");
              });
            },
            decoration: const InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: Get.height * 0.67, child: child
            // UserMainPage(path: "/all/search?q=$searchQuery"),
            ),
      ],
    );
  }
}
