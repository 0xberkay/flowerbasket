import 'package:flowerbasket/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../client/client.dart';
import '../models/product.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductElement data = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight: Get.height * 0.1,
      ),
      body: FutureBuilder(
        future: sendGet("/all/comments?p=${data.productId}"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.statusCode == 200) {
              var comments = parseComments(snapshot.data!.bodyBytes);
              if (comments.comments.isEmpty) {
                return const Center(
                  child: Text("No comments", style: TextStyle(fontSize: 20)),
                );
              }
              return ListView.builder(
                itemCount: comments.comments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.person, size: 40),
                            title: Text(comments.comments[index].username),
                            subtitle: Text(comments.comments[index].comment),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, bottom: 15.0),
                            child: starBuilder(
                                comments.comments[index].point.toDouble()),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("No comments"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
