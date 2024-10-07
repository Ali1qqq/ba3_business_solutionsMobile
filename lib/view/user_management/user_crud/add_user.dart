import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/model/user_model.dart';
import 'package:ba3_business_solutions/view/invoices/New_Invoice_View.dart';
import 'package:ba3_business_solutions/view/user_management/user_crud/time_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../widget/CustomWindowTitleBar.dart';

// Map<String, String> roleMap = {
//   "Read": Const.roleUserRead,
//   "Write": Const.roleUserWrite,
//   "Update": Const.roleUserUpdate,
//   "Delete": Const.roleUserDelete,
//   "Admin": Const.roleUserAdmin,
// };

class AddUserView extends StatefulWidget {
  final String? oldKey;

  const AddUserView({super.key, this.oldKey});

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
  SellersViewModel sellerViewController = Get.find<SellersViewModel>();
  TextEditingController nameController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.oldKey == null) {
      userManagementViewController.initAddUserModel = UserModel();
    } else {
      userManagementViewController.initAddUserModel = UserModel.fromJson(userManagementViewController.allUserList[widget.oldKey]!.toJson());
      nameController.text = userManagementViewController.initAddUserModel?.userName ?? "";
      pinController.text = userManagementViewController.initAddUserModel?.userPin ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserManagementViewModel>(builder: (controller) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(controller.initAddUserModel?.userName ?? "مستخدم جديد"),
            actions: [
              if (controller.initAddUserModel?.userId != null)
                ElevatedButton(
                    onPressed: () {
                      Get.to(() => TimeDetails(
                            oldKey: controller.initAddUserModel!.userId!,
                            name: controller.initAddUserModel!.userName!,
                          ));
                    },
                    child: const Text("البريك")),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          body: Center(
            child: Column(
              // shrinkWrap: true,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      const SizedBox(width: 70, child: Text("اسم الحساب")),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(filled: true, fillColor: Colors.white),
                          controller: nameController,
                          onChanged: (_) {
                            controller.initAddUserModel?.userName = _;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      const SizedBox(width: 70, child: Text("كلمة السر")),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(filled: true, fillColor: Colors.white),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6),
                          ],
                          controller: pinController,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          onChanged: (_) {
                            controller.initAddUserModel?.userPin = _;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      const SizedBox(width: 70, child: Text("الصلاحيات")),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: DropdownButton<String>(
                            icon: const SizedBox(),
                            value: controller.initAddUserModel?.userRole,
                            items: userManagementViewController.allRole.values.map((e) => DropdownMenuItem(value: e.roleId, child: Text(e.roleName!))).toList(),
                            onChanged: (_) {
                              controller.initAddUserModel?.userRole = _;
                              controller.update();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      const SizedBox(width: 70, child: Text("البائع")),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: DropdownButton<String>(
                            icon: const SizedBox(),
                            value: controller.initAddUserModel?.userSellerId,
                            items: sellerViewController.allSellers.keys.toList().map((e) => DropdownMenuItem(value: sellerViewController.allSellers[e]?.sellerId, child: Text(sellerViewController.allSellers[e]?.sellerName ?? "error"))).toList(),
                            onChanged: (_) {
                              controller.initAddUserModel?.userSellerId = _;
                              controller.update();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  title: controller.initAddUserModel?.userId == null ? "إضافة" : "تعديل",
                  onPressed: () {
                    if (nameController.text.isEmpty) {
                      Get.snackbar("خطأ", "يرجى كتابة الاسم");
                    } else if (pinController.text.length != 6) {
                      Get.snackbar("خطأ", "يرجى كتابة كلمة السر");
                    } else if (controller.initAddUserModel?.userSellerId == null) {
                      Get.snackbar("خطأ", "يرجى اختيار البائع");
                    } else if (controller.initAddUserModel?.userRole == null) {
                      Get.snackbar("خطأ", "يرجى اختيار الصلاحيات");
                    } else {
                      controller.addUser();
                      Get.snackbar("تمت العملية بنجاح", controller.initAddUserModel?.userId == null ? "تم اضافة الحساب" : "تم تعديل الحساب");
                    }
                  },
                  iconData: controller.initAddUserModel?.userId == null ? Icons.add : Icons.edit,
                  color:controller.initAddUserModel?.userId == null ?null:Colors.green ,
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
