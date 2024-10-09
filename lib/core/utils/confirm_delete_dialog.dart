import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> confirmDeleteWidget() async {
  var a = await Get.defaultDialog(
    title: "هل أنت متأكد من الحذف",
    middleText: "سيتم الحذف بشكل نهائي",
    actions: [
      ElevatedButton(onPressed: (){
        Get.back(result: true);
      }, child: Text("نعم")),
      ElevatedButton(onPressed: (){
        Get.back(result: false);
      }, child: Text("تراجع"))
    ]
  );
  return a;
}