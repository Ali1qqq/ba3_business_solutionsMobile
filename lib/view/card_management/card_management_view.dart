import 'package:ba3_business_solutions/controller/user_management_model.dart';

import 'package:ba3_business_solutions/view/card_management/read_card_view.dart';
import 'package:ba3_business_solutions/view/card_management/write_card_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CardManagementType extends StatefulWidget {
  const CardManagementType({super.key});

  @override
  State<CardManagementType> createState() => _CardManagementTypeState();
}

class _CardManagementTypeState extends State<CardManagementType> {
  bool isAdmin=false;
  UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
  @override
  void initState() {
    super.initState();
    // WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
    //   checkPermissionForOperation(Const.roleUserAdmin,Const.roleViewCard).then((value) {
    //     print(value);
    //     if (value) {
    //       isAdmin = true;
    //       setState(() {

    //       });
    //     }
    //   });
    // });

    // userManagementViewController.initAllUser();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("الإدارة"),
        ),
        body:Column(
          children: [
            Item("قراءة بطاقة",(){
              Get.to(() => ReadCardView());
            }),
            Item("تعديل بطاقة",(){
              Get.to(() => WriteCardView());
            }),
            Item("حذف صلاحيات بطاقة",(){
              Get.to(() => WriteCardView());
            }),
          ],
        ),
      ),
    );
  }
  Widget Item(text,onTap){
    return   Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Text(text,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,)),
      ),
    );
  }
}

