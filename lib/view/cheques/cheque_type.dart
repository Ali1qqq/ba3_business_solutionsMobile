import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/view/cheques/add_cheque.dart';
import 'package:ba3_business_solutions/view/cheques/all_cheques_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';

class ChequeType extends StatefulWidget {
  const ChequeType({super.key});

  @override
  State<ChequeType> createState() => _ChequeTypeState();
}

class _ChequeTypeState extends State<ChequeType> {
  PatternViewModel patternController=Get.find<PatternViewModel>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الشيكات"),
        ),
        body: Column(
          children: [
            Item("إضافة شيك",(){
              Get.to(() => const AddCheque());
            }),
            Item("معاينة الشيكات",(){
              checkPermissionForOperation(Const.roleUserRead , Const.roleViewCheques).then((value) {
                if(value) Get.to(()=>AllCheques());
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
