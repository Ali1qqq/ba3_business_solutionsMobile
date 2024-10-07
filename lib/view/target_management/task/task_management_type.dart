import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Const/const.dart';
import '../../../controller/user_management_model.dart';
import 'add_task.dart';
import 'all_task_view.dart';

class TaskManagementType extends StatefulWidget {
  const TaskManagementType({super.key});

  @override
  State<TaskManagementType> createState() => _TaskManagementTypeState();
}

class _TaskManagementTypeState extends State<TaskManagementType> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إدارة التارجيت"),
        ),
        body: Column(
          children: [
            Item("إضافة مهام بالمواد",(){
               Get.to(()=>AddTaskView());
            }),
            // Item("إضافة مهام بالجرد",(){
            //   Get.to(()=>AddInventoryTaskView());
            // }),
            Item("معاينة التاسكات",(){
              checkPermissionForOperation(Const.roleUserRead , Const.roleViewTask).then((value) {
                if(value) Get.to(()=>AllTaskView());
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
