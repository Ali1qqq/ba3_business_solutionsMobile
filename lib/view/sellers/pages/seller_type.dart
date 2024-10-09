import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/view/sellers/pages/add_seller.dart';
import 'package:ba3_business_solutions/view/sellers/pages/all_sellers_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';

class SellerType extends StatefulWidget {
  const SellerType({super.key});

  @override
  State<SellerType> createState() => _SellerTypeState();
}

class _SellerTypeState extends State<SellerType> {
  PatternViewModel patternController = Get.find<PatternViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("البائعون"),
      ),
      body: Column(
        children: [
          Item("إضافة بائع", () {
            Get.to(() => AddSeller());
          }),
          Item("معاينة البائعون", () {
            checkPermissionForOperation(
                AppConstants.roleUserRead, AppConstants.roleViewSeller)
                .then((value) {
              if (value) Get.to(() => AllSellers());
            });
          }),
        ],
      ),

    );
  }

  Widget Item(text, onTap) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ))),
      ),
    );
  }
}
