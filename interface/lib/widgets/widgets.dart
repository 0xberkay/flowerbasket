import 'package:flowerbasket/helper/snackmess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../client/client.dart';
import '../colors/colorsconf.dart';
import '../models/catagories.dart';

Widget myField(
  String? labelText,
  IconData? icon,
  TextEditingController? controller,
  bool? isPassword,
  bool? isUpdate,
) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 8.0,
      left: 15.0,
      right: 15.0,
    ),
    child: Container(
      height: Get.height * 0.1,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: MyColors.quaternary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          obscureText: isPassword!,
          controller: controller,
          decoration: InputDecoration(
            hintText: isUpdate! ? labelText : null,
            border: InputBorder.none,
            labelText: isUpdate ? null : labelText,
            icon: Icon(icon, color: MyColors.secondary),
            focusedErrorBorder: InputBorder.none,
          ),
        ),
      ),
    ),
  );
}

Widget myFieldNoEdit(
  String? labelText,
  IconData? icon,
  TextEditingController? controller,
  bool? isPassword,
  bool? isUpdate,
) {
  return GestureDetector(
    onTap: () {
      SnackMess("Error", "You can't edit this field", MyColors.red,
          SnackPosition.BOTTOM, Icons.error);
    },
    child: Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 15.0,
        right: 15.0,
      ),
      child: Container(
        height: Get.height * 0.1,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: MyColors.quaternary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            enabled: false,
            obscureText: isPassword!,
            controller: controller,
            decoration: InputDecoration(
              hintText: isUpdate! ? labelText : null,
              border: InputBorder.none,
              labelText: isUpdate ? null : labelText,
              icon: Icon(icon, color: MyColors.secondary),
              focusedErrorBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget myFieldNumber(
  String? labelText,
  IconData? icon,
  TextEditingController? controller,
  bool? isPassword,
  bool? isUpdate,
) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 8.0,
      left: 15.0,
      right: 15.0,
    ),
    child: Container(
      height: Get.height * 0.1,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: MyColors.quaternary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          obscureText: isPassword!,
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: isUpdate! ? labelText : null,
            border: InputBorder.none,
            labelText: isUpdate ? null : labelText,
            icon: Icon(icon, color: MyColors.secondary),
            focusedErrorBorder: InputBorder.none,
          ),
        ),
      ),
    ),
  );
}

//star builder
Widget starBuilder(double starCount) {
  List<Widget> stars = [];
  int starCountInt = starCount.toInt();
  //add 5 non-filled stars
  for (int i = 0; i < 5; i++) {
    stars.add(const Icon(
      Icons.star_border,
      color: Colors.black,
    ));
  }
  //add filled stars
  for (int i = 0; i < starCountInt; i++) {
    stars[i] = const Icon(
      Icons.star,
      color: Color.fromARGB(255, 248, 191, 4),
    );
  }
  return Row(
    children: stars,
  );
}

typedef IntCallBack = void Function(int val);

class PickCategory extends StatefulWidget {
  final IntCallBack callback;

  const PickCategory({super.key, required this.callback});

  @override
  State<PickCategory> createState() => _PickCategoryState();
}

class _PickCategoryState extends State<PickCategory> {
  int? valId;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: MyColors.tertiary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder(
              future: sendGet("/all/categories"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.statusCode != 200) {
                    return const Center(
                      child: Text("Error"),
                    );
                  }
                  var data = parseCategories(snapshot.data!.bodyBytes);
                  return DropdownButton<int>(
                    borderRadius: BorderRadius.circular(10),
                    underline: Container(
                      height: 2,
                      color: MyColors.primary,
                    ),
                    hint: const Text('Select Category'),
                    value: valId,
                    onChanged: (int? value) {
                      setState(() {
                        valId = value;
                      });
                      widget.callback(value!);
                    },
                    items: data.categories
                        .map<DropdownMenuItem<int>>((Category category) {
                      return DropdownMenuItem<int>(
                        value: category.categoryId,
                        child: Text(category.categoryName),
                      );
                    }).toList(),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}

typedef StringCallBack = void Function(String val);

class SellerGalleryPicker extends StatefulWidget {
  final IntCallBack callback;
  final StringCallBack callbacklink;

  const SellerGalleryPicker(
      {super.key, required this.callback, required this.callbacklink});

  @override
  State<SellerGalleryPicker> createState() => _SellerGalleryPickerState();
}

class _SellerGalleryPickerState extends State<SellerGalleryPicker> {
  int? pickedId;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: sendGet("/seller/gallery"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.statusCode != 200) {
              return const Center(
                child: Text("Error"),
              );
            }
            var data = parseGallery(snapshot.data!.bodyBytes);
            if (data.gallery.isEmpty) {
              return const Center(
                child: Text("No Images please add some"),
              );
            }
            return SizedBox(
              height: Get.height * 0.2,
              width: Get.width,
              child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: data.gallery.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          pickedId = data.gallery[index].id;
                        });
                        widget.callback(data.gallery[index].id);
                        widget.callbacklink(data.gallery[index].link);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: pickedId == data.gallery[index].id
                                ? MyColors.primary
                                : MyColors.tertiary,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(data.gallery[index].link),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: pickedId == data.gallery[index].id
                            ? const Icon(
                                Icons.check_circle,
                                color: MyColors.primary,
                              )
                            : null,
                      ),
                    );
                  }),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

Widget statuContainer(String statu, int statuId) {
  return Container(
      decoration: BoxDecoration(
        color: statuId == 1
            ? Colors.green
            : statuId == 2
                ? Colors.yellow
                : statuId == 5
                    ? MyColors.red
                    : Colors.greenAccent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Status: $statu"),
      ));
}
