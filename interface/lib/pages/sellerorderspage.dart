import 'package:flowerbasket/client/client.dart';
import 'package:flowerbasket/colors/colorsconf.dart';
import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flowerbasket/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

import 'sellerhome.dart';

class SellerOrdersPage extends StatefulWidget {
  const SellerOrdersPage({super.key});

  @override
  State<SellerOrdersPage> createState() => _SellerOrdersPageState();
}

class _SellerOrdersPageState extends State<SellerOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sendGet("/seller/orders"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.statusCode == 200) {
            var data = parseSellerOrders(snapshot.data!.bodyBytes);

            return ListView.builder(
              itemCount: data.sellerOrders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.shopping_cart),
                            title: Text(data.sellerOrders[index].productName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Price : ${data.sellerOrders[index].price}"),
                                Text(
                                    "Product Count : ${data.sellerOrders[index].productCount}"),
                                Text(data.sellerOrders[index].createdAt
                                    .toString()),
                              ],
                            ),
                            trailing: data.sellerOrders[index].messageId != 0
                                ? TextButton(
                                    onPressed: () {
                                      String name =
                                          "Name : ${data.sellerOrders[index].nameInMessage}";
                                      String message =
                                          "Message : ${data.sellerOrders[index].message}";
                                      Get.defaultDialog(
                                        title: "Message",
                                        content: Column(
                                          children: [
                                            Text(name),
                                            Text(message),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Click for message",
                                      style: TextStyle(color: MyColors.bold),
                                    ))
                                : null,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                statuContainer(
                                  data.sellerOrders[index].statuName,
                                  data.sellerOrders[index].statuId,
                                ),
                                IconButton(
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "Click for change statu",
                                        content: SizedBox(
                                          height: 300,
                                          width: 300,
                                          child: FutureBuilder(
                                            future: sendGet("/all/statuscodes"),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                if (snapshot.data!.statusCode ==
                                                    200) {
                                                  var dataStatu =
                                                      parseStatuCodes(snapshot
                                                          .data!.bodyBytes);

                                                  return ListView.builder(
                                                    itemCount: dataStatu
                                                        .statusCodes.length,
                                                    itemBuilder:
                                                        (context, indexS) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: dataStatu
                                                                        .statusCodes[
                                                                            indexS]
                                                                        .statuId ==
                                                                    data
                                                                        .sellerOrders[
                                                                            index]
                                                                        .statuId
                                                                ? Border.all(
                                                                    color:
                                                                        MyColors
                                                                            .bold,
                                                                    width: 4)
                                                                : null,
                                                          ),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              var result =
                                                                  await sendGet(
                                                                      "/seller/updateorder?statuId=${dataStatu.statusCodes[indexS].statuId}&orderId=${data.sellerOrders[index].orderId}");
                                                              var mess =
                                                                  parseMess(result
                                                                      .bodyBytes);

                                                              if (result
                                                                      .statusCode ==
                                                                  200) {
                                                                SnackMess(
                                                                    "Succsess",
                                                                    mess
                                                                        .message,
                                                                    Colors
                                                                        .green,
                                                                    SnackPosition
                                                                        .TOP,
                                                                    Icons
                                                                        .check_circle_outline);
                                                                Get.offAll(
                                                                    const SellerHome(),
                                                                    arguments:
                                                                        2);
                                                              } else {
                                                                SnackMess(
                                                                    "Error",
                                                                    mess
                                                                        .message,
                                                                    MyColors
                                                                        .red,
                                                                    SnackPosition
                                                                        .TOP,
                                                                    Icons
                                                                        .error_outline);
                                                              }
                                                            },
                                                            child: statuContainer(
                                                                dataStatu
                                                                    .statusCodes[
                                                                        indexS]
                                                                    .statuName,
                                                                dataStatu
                                                                    .statusCodes[
                                                                        indexS]
                                                                    .statuId),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  return const Text(
                                                      "Something went wrong");
                                                }
                                              } else {
                                                return const CircularProgressIndicator();
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit)),
                              ]),
                          TextButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title:
                                      "User Address ID : ${data.sellerOrders[index].addressId}",
                                  content: Column(
                                    children: [
                                      ListTile(
                                        leading:
                                            const Icon(Icons.location_city),
                                        title:
                                            Text(data.sellerOrders[index].city),
                                        subtitle: const Text("city"),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.location_on),
                                        title: Text(
                                            data.sellerOrders[index].state),
                                        subtitle: const Text("state"),
                                      ),
                                      ListTile(
                                        leading:
                                            const Icon(Icons.roundabout_left),
                                        title: Text(
                                            data.sellerOrders[index].street),
                                        subtitle: const Text("street"),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.numbers),
                                        title: Text(
                                            data.sellerOrders[index].zipCode),
                                        subtitle: const Text("zip code"),
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            Icons.difference_outlined),
                                        title: Text(
                                            data.sellerOrders[index].detail),
                                        subtitle: const Text("detail"),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.to(Scaffold(
                                            extendBodyBehindAppBar: true,
                                            appBar: AppBar(
                                              title:
                                                  const Text('Order Address'),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  bottom: Radius.circular(30),
                                                ),
                                              ),
                                              toolbarHeight: Get.height * 0.1,
                                              backgroundColor:
                                                  MyColors.tertiary,
                                            ),
                                            body: FlutterMap(
                                              options: MapOptions(
                                                center: LatLng(
                                                    data.sellerOrders[index]
                                                        .latitude,
                                                    data.sellerOrders[index]
                                                        .longitude),
                                                zoom: 18.0,
                                              ),
                                              children: [
                                                TileLayer(
                                                  urlTemplate:
                                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                  userAgentPackageName:
                                                      'com.example.app',
                                                ),
                                                MarkerLayer(
                                                  markers: [
                                                    Marker(
                                                      width: Get.width / 5,
                                                      height: Get.height / 5,
                                                      point: LatLng(
                                                          data
                                                              .sellerOrders[
                                                                  index]
                                                              .latitude,
                                                          data
                                                              .sellerOrders[
                                                                  index]
                                                              .longitude),
                                                      builder: (ctx) =>
                                                          const Icon(
                                                        Icons.location_on,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ));
                                        },
                                        child: const Text("Show in map")),
                                  ],
                                );
                              },
                              child: const Text(
                                "Show Address",
                                style: TextStyle(color: MyColors.bold),
                              ))
                        ],
                      )),
                );
              },
            );
          } else {
            return const Center(child: Text("Error"));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
