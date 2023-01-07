import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

void onTapImage(String link) {
  Get.dialog(
    Dialog(
      child: PhotoView(
        tightMode: true,
        imageProvider: NetworkImage(link),
      ),
    ),
  );
}
