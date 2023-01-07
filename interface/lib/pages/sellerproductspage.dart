import 'package:flowerbasket/client/client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/sellerproducts.dart';

class SellerProductsPage extends StatefulWidget {
  const SellerProductsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SellerProductsPage> createState() => _SellerProductsPageState();
}

class _SellerProductsPageState extends State<SellerProductsPage> {
  late Future<SellerProducts> sellerProducts;

  @override
  void initState() {
    super.initState();
    sellerProducts = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed("/sellerproductadd");
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<SellerProducts>(
          future: sellerProducts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.sellerProducts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        child: ListTile(
                          leading: Image.network(
                            snapshot.data!.sellerProducts[index].imageLink,
                            width: Get.width * 0.3,
                            height: Get.width * 0.3,
                          ),
                          title: Text(
                              snapshot.data!.sellerProducts[index].productName),
                          subtitle: Text(
                            "Stock: ${snapshot.data!.sellerProducts[index].stock}",
                          ),
                          trailing: const Icon(Icons.edit),
                          onTap: () {
                            Get.toNamed("/sellerproductedit",
                                arguments:
                                    snapshot.data!.sellerProducts[index]);
                          },
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
