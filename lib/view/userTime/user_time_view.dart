import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../Const/const.dart';

class UserTimeView extends StatelessWidget {
  const UserTimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تسجيل الدوام"),
      ),
      body: GetBuilder<UserManagementViewModel>(builder: (logic) {
        return ListView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Item(
              "تسجيل الحضور",
              () async {
                Position? position = await getCurrentLocation();
                if(checkLogin(position)) {
                  logic.logInTime();
                  logic.update();
                }else{
                  Get.snackbar("خطأ المنطقة الجغرافية", "يرجى الدخول الى المحل او مراجعة المسؤول");
                }

              },
            ),
            Item(
              "تسجيل المغادرة",
              color: Colors.red,
              () async{
                Position? position = await getCurrentLocation();
                if(checkLogin(position)) {
                  logic.logOutTime();
                  logic.update();
                }else{
                  Get.snackbar("خطأ المنطقة الجغرافية", "يرجى الدخول الى المحل او مراجعة المسؤول");
                }


              },
            ),
            if (logic.allUserList[logic.myUserModel!.userId!]?.logInDateList?.lastOrNull != null) ...[
              const Text(
                "اخر تسحيل دخول",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Item(
                formatDateTimeFromString(logic.allUserList[logic.myUserModel?.userId ?? '']!.logInDateList!.last.toString()),
                () {},
                color: Colors.green,
              )
            ],
            if (logic.allUserList[logic.myUserModel?.userId ?? '']?.logOutDateList?.lastOrNull != null) ...[
              const Text(
                "اخر تسحيل خروج",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Item(
                formatDateTimeFromString(logic.allUserList[logic.myUserModel?.userId ?? '']!.logOutDateList!.last.toString()),
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

Widget Item(text, onTap, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: InkWell(
      onTap: onTap,
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: color ?? Colors.white)),
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
          )),
    ),
  );
}
