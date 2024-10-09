import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/view/cheques/pages/add_cheque.dart';
import 'package:ba3_business_solutions/view/cheques/pages/all_cheques_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';

class ChequeType extends StatefulWidget {
  const ChequeType({super.key});

  @override
  State<ChequeType> createState() => _ChequeTypeState();
}

class _ChequeTypeState extends State<ChequeType> {
  PatternViewModel patternController = Get.find<PatternViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الشيكات"),
      ),
      body: Column(
        children: [
          Item("إضافة شيك", () {
            Get.to(() => const AddCheque());
          }),
          Item("معاينة الشيكات", () {
            checkPermissionForOperation(
                    AppConstants.roleUserRead, AppConstants.roleViewCheques)
                .then((value) {
              if (value) Get.to(() => AllCheques());
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ))),
      ),
    );
  }
}
