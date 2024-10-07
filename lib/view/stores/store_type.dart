import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';

import 'package:ba3_business_solutions/view/stores/add_store.dart';
import 'package:ba3_business_solutions/view/stores/all_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';

class StoreType extends StatefulWidget {
  const StoreType({super.key});

  @override
  State<StoreType> createState() => _StoreTypeState();
}

class _StoreTypeState extends State<StoreType> {
  PatternViewModel patternController=Get.find<PatternViewModel>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("المستودعات"),
        ),
        body: Column(
          children: [
            Item("إضافة مستودع",(){
              Get.to(() => AddStore());
            }),
            Item("معاينة المستودعات",(){
              checkPermissionForOperation(Const.roleUserRead , Const.roleViewStore).then((value) {
                if(value) Get.to(()=>AllStore());
              });
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
            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Center(child: Text(text,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,))),
      ),
    );
  }
}
