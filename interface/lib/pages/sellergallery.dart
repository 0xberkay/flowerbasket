import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flowerbasket/pages/sellerhome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../client/client.dart';
import '../colors/colorsconf.dart';
import '../helper/ontapimage.dart';
import '../models/gallery.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isWeb = GetPlatform.isWeb;
    return FutureBuilder(
      future: sendGet("/seller/gallery"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = parseGallery(snapshot.data!.bodyBytes);
          //add data first item
          data.gallery.insert(0, GalleryElement(link: "", id: 0));
          return GridView.builder(
            itemCount: data.gallery.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      if (isWeb) {
                        SnackMess("Error", "Not supported on web", MyColors.red,
                            SnackPosition.TOP, Icons.error_outline);
                        return;
                      }
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        dialogTitle: 'Select an image',
                        type: FileType.image,
                      );

                      if (result != null) {
                        var reqresult = await sendMultiPart(
                            "/seller/upload", result.files.single.path);
                        //get response body
                        var mess = parseMess(await reqresult.stream.toBytes());
                        if (reqresult.statusCode == 200) {
                          Get.offAll(const SellerHome(), arguments: 1);
                          SnackMess("Success", mess.message, Colors.green,
                              SnackPosition.TOP, Icons.check_circle_outline);
                        } else {
                          SnackMess("Error", mess.message, MyColors.red,
                              SnackPosition.TOP, Icons.error_outline);
                        }
                      } else {
                        SnackMess("Error", "No file selected", MyColors.red,
                            SnackPosition.TOP, Icons.error_outline);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        //gradien color
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            MyColors.secondary,
                            MyColors.primary,
                            MyColors.secondary,
                            MyColors.tertiary
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    onTapImage(data.gallery[index].link);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(data.gallery[index].link),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: "Delete",
                              middleText: "Are you sure to delete?",
                              textConfirm: "Yes",
                              textCancel: "No",
                              confirmTextColor: Colors.white,
                              cancelTextColor: Colors.black,
                              buttonColor: MyColors.red,
                              onConfirm: () async {
                                var result = await sendGet(
                                    "/seller/delete?id=${data.gallery[index].id}");
                                var mess = parseMess(snapshot.data!.bodyBytes);
                                if (result.statusCode == 200) {
                                  Get.offAll(const SellerHome(), arguments: 1);
                                  SnackMess(
                                      "Success",
                                      "Delete success",
                                      Colors.green,
                                      SnackPosition.TOP,
                                      Icons.check_circle_outline);
                                } else {
                                  SnackMess("Error", mess.message, MyColors.red,
                                      SnackPosition.TOP, Icons.error_outline);
                                }
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: MyColors.red,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
