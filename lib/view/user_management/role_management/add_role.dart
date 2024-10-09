import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/model/user/role_model.dart';
import 'package:ba3_business_solutions/view/invoices/pages/New_Invoice_View.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helper/functions/functions.dart';

class AddRoleView extends StatefulWidget {
  const AddRoleView({super.key, this.oldKey});

  final String? oldKey;

  @override
  State<AddRoleView> createState() => _AddRoleViewState();
}

class _AddRoleViewState extends State<AddRoleView> {
  Map<String, List<String>> allMap = {};
  var userManagementController = Get.find<UserManagementViewModel>();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    if (widget.oldKey == null) {
      userManagementController.roleModel = RoleModel(roles: {});
    } else {
      userManagementController.roleModel = RoleModel.fromJson(
          userManagementController.allRole[widget.oldKey]!.toJson());
      allMap = userManagementController.roleModel?.roles ?? {};
      nameController.text =
          userManagementController.allRole[widget.oldKey]?.roleName ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var all=["bond","account","product"];
    return GetBuilder<UserManagementViewModel>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(controller.roleModel?.roleName ?? "دور جديد"),
          actions: [
            AppButton(
                title:
                    controller.roleModel?.roleId == null ? "إضافة" : "تعديل",
                onPressed: () {
                  if (controller.roleModel?.roleName?.isNotEmpty ?? false) {
                    controller.addRole();
                  }
                },
                iconData: controller.roleModel?.roleId == null
                    ? Icons.add
                    : Icons.edit),
            const SizedBox(width: 10),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ListView(
            children: [
              const Text(
                "الاسم",
                style: TextStyle(fontSize: 16),
              ),
              Container(
                color: Colors.grey.shade200,
                child: TextFormField(
                  controller: nameController,
                  onChanged: (_) {
                    controller.roleModel?.roleName = _.toString();
                  },
                ),
              ),
              for (var i in AppConstants.allRolePage)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${getPageNameFromEnum(i.toString())}:",
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          children: [
                            checkBoxWidget(
                                i, AppConstants.roleUserRead, controller),
                            checkBoxWidget(
                                i, AppConstants.roleUserWrite, controller),
                            checkBoxWidget(
                                i, AppConstants.roleUserUpdate, controller),
                            checkBoxWidget(
                                i, AppConstants.roleUserDelete, controller),
                            checkBoxWidget(
                                i, AppConstants.roleUserAdmin, controller),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget checkBoxWidget(keys, text, UserManagementViewModel controller) {
    return Row(
      children: [
        StatefulBuilder(builder: (context, setstate) {
          return Checkbox(
              fillColor: WidgetStatePropertyAll(Colors.blue.shade800),
              checkColor: Colors.white,
              overlayColor: const WidgetStatePropertyAll(Colors.white),
              side: const BorderSide(color: Colors.black),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(color: Colors.white)),
              value: (allMap[keys]?.contains(text) ?? false),
              onChanged: (_) {
                if (_!) {
                  if (allMap[keys] == null) {
                    allMap[keys] = [text];
                  } else {
                    allMap[keys]?.add(text);
                  }
                } else {
                  allMap[keys]?.remove(text);
                }
                userManagementController.roleModel?.roles = allMap;
                setstate(() {});
              });
        }),
        Text(
          getNameOfRoleFromEnum(text),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        )
      ],
    );
  }
}
