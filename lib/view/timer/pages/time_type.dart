import 'package:ba3_business_solutions/controller/user/user_management_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import 'all_time_view.dart';

class TimeType extends StatefulWidget {
  const TimeType({super.key});

  @override
  State<TimeType> createState() => _TimeTypeState();
}

class _TimeTypeState extends State<TimeType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إدارة الوقت"),
      ),
      body: Column(
        children: [
          Item("المؤقت", () {
            checkPermissionForOperation(
                    AppConstants.roleUserRead, AppConstants.roleViewTimer)
                .then((value) {
              if (value) Get.to(() => AllTimeView());
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
