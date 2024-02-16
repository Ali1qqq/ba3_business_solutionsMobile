import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/view/user_management/role_management/add_role.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoleManagementView extends StatelessWidget {
  const RoleManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("إدارة الصلاحيات"),
          actions: [
            ElevatedButton(onPressed: (){
              Get.to(()=>AddRoleView());
            }, child: Text("إضافة دور",style: TextStyle(color: Colors.black),))
          ],
        ),
        body: GetBuilder<UserManagementViewModel>(
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  children: List.generate(
                    controller.allRole.values.length,
                        (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Get.to(()=>AddRoleView(oldKey:controller.allRole.keys.toList()[index]));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
                          height: 140,
                          width: 140,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                controller.allRole.values.toList()[index].roleName ?? "",
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
      //       return ListView.builder(
      //         itemCount: controller.allRole.length,
      //         itemBuilder: (context,index){
      //         return InkWell(onTap: (){
      //           Get.to(()=>AddRoleView(oldKey:controller.allRole.keys.toList()[index] ,));
      //         },child: Text(controller.allRole.values.toList()[index].roleName??"error"));
      // },
      // );
          }
        )),
    );
  }
}
