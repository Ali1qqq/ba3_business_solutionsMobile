import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart'; // Import your app strings
import '../../../core/helper/functions/functions.dart';

class UserTimeView extends StatelessWidget {
  const UserTimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.workRegistration.tr),
      ),
      body: GetBuilder<UserManagementViewModel>(builder: (logic) {
        return ListView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          children: [
            item(
              AppStrings.attendanceRegistration.tr,
              () async {
                Position? position = await getCurrentLocation();
                if (checkLogin(position)) {
                  logic.logInTime();
                  logic.update();
                } else {
                  Get.snackbar(AppStrings.geoErrorTitle.tr,
                      AppStrings.geoErrorMessage.tr);
                }
              },
            ),
            item(
              AppStrings.departureRegistration.tr,
              color: Colors.red,
              () async {
                Position? position = await getCurrentLocation();
                if (checkLogin(position)) {
                  logic.logOutTime();
                  logic.update();
                } else {
                  Get.snackbar(AppStrings.geoErrorTitle.tr,
                      AppStrings.geoErrorMessage.tr);
                }
              },
            ),
            if (logic.allUserList[logic.myUserModel!.userId!]?.logInDateList
                    ?.lastOrNull !=
                null) ...[
              Text(
                AppStrings.lastLogin.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              item(
                formatDateTimeFromString(logic
                    .allUserList[logic.myUserModel?.userId ?? '']!
                    .logInDateList!
                    .last
                    .toString()),
                () {},
                color: Colors.green,
              )
            ],
            if (logic.allUserList[logic.myUserModel?.userId ?? '']
                    ?.logOutDateList?.lastOrNull !=
                null) ...[
              Text(
                AppStrings.lastLogout.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              item(
                formatDateTimeFromString(logic
                    .allUserList[logic.myUserModel?.userId ?? '']!
                    .logOutDateList!
                    .last
                    .toString()),
                () {},
                color: Colors.black,
              )
            ]
          ],
        );
      }),
    );
  }
}

Widget item(text, onTap, {Color? color}) => Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color ?? Colors.white)),
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Text(
                text,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )),
      ),
    );
