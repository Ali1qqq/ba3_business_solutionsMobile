import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import 'due_view.dart';

class DueType extends StatefulWidget {
  const DueType({super.key});

  @override
  State<DueType> createState() => _DueTypeState();
}

class _DueTypeState extends State<DueType> {
  PatternViewModel patternController = Get.find<PatternViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الاستحقاق"),
      ),
      body: Column(
        children: [
          Item("معاينة الاستحقاق", () {
            checkPermissionForOperation(
                AppConstants.roleUserRead, AppConstants.roleViewDue)
                .then((value) {
              if (value) Get.to(() => AllDueView());
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
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Text(
              text,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),

            )),
      ),
    );
  }
}
