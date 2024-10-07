import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';

import 'package:ba3_business_solutions/view/sellers/add_seller.dart';
import 'package:ba3_business_solutions/view/sellers/all_sellers_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';

class SellerType extends StatefulWidget {
  const SellerType({super.key});

  @override
  State<SellerType> createState() => _SellerTypeState();
}

class _SellerTypeState extends State<SellerType> {
  PatternViewModel patternController=Get.find<PatternViewModel>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("البائعون"),
        ),
        body: Column(
          children: [
            Item("إضافة بائع",(){
              Get.to(() => AddSeller());
            }),
            Item("معاينة البائعون",(){
              checkPermissionForOperation(Const.roleUserRead , Const.roleViewSeller).then((value) {
                if(value) Get.to(()=>AllSellers());
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
            child: Center(child: Text(text,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,))),
      ),
    );
  }
}
