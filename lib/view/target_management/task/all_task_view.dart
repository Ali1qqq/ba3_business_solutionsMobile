import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/target_view_model.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/view/target_management/task/add_task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/confirm_delete_dialog.dart';
import '../../../model/seller/task_model.dart';

class AllTaskView extends StatefulWidget {
  const AllTaskView({super.key});

  @override
  State<AllTaskView> createState() => _AllTaskViewState();
}

class _AllTaskViewState extends State<AllTaskView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("عرض المهام"),
      ),
      body: GetBuilder<TargetViewModel>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: controller.allTarget.length,
              itemBuilder: (context, index) {
                MapEntry<String, TaskModel> model =
                    controller.allTarget.entries.toList()[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "يجب بيع ",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        getProductNameFromId(
                            model.value.taskProductId.toString()),
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "بعدد",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        model.value.taskQuantity.toString(),
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "بتاريخ",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        model.value.taskDate.toString(),
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        model.value.isTaskAvailable.toString(),
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Get.defaultDialog(
                                title: "قائمة المشاركين",
                                content: Container(
                                  height: Get.width / 4,
                                  width: Get.width / 4,
                                  child: ListView.builder(
                                    itemCount:
                                        model.value.taskSellerListId.length,
                                    itemBuilder: (context, index) {
                                      String seller =
                                          model.value.taskSellerListId[index];
                                      return Text(getSellerNameFromId(seller)
                                          .toString());
                                    },
                                  ),
                                ));
                          },
                          child: const Text("قائمة المشاركين")),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () async {
                            checkPermissionForOperation(
                                    AppConstants.roleUserUpdate,
                                    AppConstants.roleViewTask)
                                .then((value) async {
                              if (value) {
                                Get.to(() => AddTaskView(
                                      oldKey: model.key,
                                    ));
                              }
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blueAccent.shade700,
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () async {
                            confirmDeleteWidget().then((value) {
                              if (value) {
                                checkPermissionForOperation(
                                        AppConstants.roleUserDelete,
                                        AppConstants.roleViewTask)
                                    .then((value) async {
                                  if (value) {
                                    controller.deleteTask(model.value);
                                  }
                                });
                              }
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ))
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
