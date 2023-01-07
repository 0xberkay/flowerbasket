import 'package:flowerbasket/client/client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../colors/colorsconf.dart';
import '../helper/snackmess.dart';

class UserAddress extends StatefulWidget {
  const UserAddress({
    Key? key,
  }) : super(key: key);

  @override
  State<UserAddress> createState() => _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Addresses'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight: Get.height * 0.1,
        backgroundColor: MyColors.tertiary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var status = await Permission.location.request();
          if (status.isDenied) {
          } else if (status.isPermanentlyDenied) {
            SnackMess("Error", "Please allow location permission", MyColors.red,
                SnackPosition.TOP, Icons.error);
          } else if (status.isGranted) {
            Get.toNamed("/useraddaddress");
          }
        },
        backgroundColor: MyColors.tertiary,
        child: const Icon(Icons.add_home),
      ),
      body: FutureBuilder(
        future: sendGet("/user/getaddresses"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.statusCode == 200) {
              var addresses = parseAddressData(snapshot.data!.bodyBytes);
              if (addresses.addresses.isEmpty) {
                return const Center(
                  child: Text("No address", style: TextStyle(fontSize: 20)),
                );
              }
              return ListView.builder(
                itemCount: addresses.addresses.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                                subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading:
                                              const Icon(Icons.location_city),
                                          title: Text(
                                              addresses.addresses[index].city),
                                          subtitle: const Text("city"),
                                        ),
                                        ListTile(
                                          leading:
                                              const Icon(Icons.location_on),
                                          title: Text(
                                              addresses.addresses[index].state),
                                          subtitle: const Text("state"),
                                        ),
                                        ListTile(
                                          leading:
                                              const Icon(Icons.roundabout_left),
                                          title: Text(addresses
                                              .addresses[index].street),
                                          subtitle: const Text("street"),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.numbers),
                                          title: Text(addresses
                                              .addresses[index].zipCode),
                                          subtitle: const Text("zip code"),
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                              Icons.difference_outlined),
                                          title: Text(addresses
                                              .addresses[index].detail),
                                          subtitle: const Text("detail"),
                                        ),
                                      ],
                                    )),
                                //delete address
                                onTap: (() {}),
                                trailing: IconButton(
                                  tooltip: "Delete",
                                  onPressed: () async {
                                    var result = await sendGet(
                                        "/user/deleteaddress?id=${addresses.addresses[index].addressId}");
                                    var message = parseMess(result.bodyBytes);
                                    if (result.statusCode == 200) {
                                      Get.offAndToNamed("/useraddress");
                                      SnackMess(
                                        "Success",
                                        message.message,
                                        Colors.green,
                                        SnackPosition.TOP,
                                        Icons.check_circle,
                                      );
                                    } else {
                                      SnackMess(
                                        "Error",
                                        message.message,
                                        MyColors.red,
                                        SnackPosition.TOP,
                                        Icons.error,
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.delete,
                                      color: MyColors.red,
                                      size: Get.width * 0.1),
                                )),
                          )));
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
      ),
    );
  }
}
