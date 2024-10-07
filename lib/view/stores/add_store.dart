import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Const/const.dart';
import '../../controller/user_management_model.dart';
import '../invoices/widget/custom_TextField.dart';

class AddStore extends StatefulWidget {
  final String? oldKey;
  AddStore({super.key, this.oldKey});

  @override
  State<AddStore> createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  var nameController = TextEditingController();
  var codeController = TextEditingController();
  StoreViewModel storeController = Get.find<StoreViewModel>();

  @override
  void initState() {
    if (widget.oldKey == null) {
      storeController.editStoreModel = StoreModel();
    } else {
      storeController.editStoreModel = StoreModel.fromJson(storeController.storeMap[widget.oldKey]!.toFullJson());
      nameController.text = storeController.editStoreModel?.stName ?? "";
      codeController.text = storeController.editStoreModel?.stCode ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إضافة مستودع"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: GetBuilder<StoreViewModel>(builder: (storeController) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 75,
                ),
                // Container(
                //   width: Get.width * 0.5,
                //   margin: const EdgeInsets.symmetric(horizontal: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [const Flexible(flex: 2, child: Text("رمز المستودع :")), Text(storeController.editStoreModel?.stId ?? "new Store")],
                //   ),
                // ),
                // SizedBox(
                //   height: 75,
                // ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Flexible(flex: 2, child: Text("اسم المستودع :")),
                          Flexible(
                              flex: 3,
                              child: CustomTextFieldWithoutIcon(controller:  nameController, onChanged: (_) {
                                storeController.editStoreModel?.stName = _;
                              })),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Flexible(flex: 2, child: Text("رمز المستودع :")),
                          Flexible(
                              flex: 3,
                              child: CustomTextFieldWithoutIcon(controller:  codeController, onChanged: (_) {
                                storeController.editStoreModel?.stCode = _;
                              })),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {
                          nameController.clear();
                          codeController.clear();
                          storeController.clearController();
                        },
                        child: const Text("إفراغ")),
                    if (storeController.editStoreModel?.stId != null)
                      ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          onPressed: () {
                            if(nameController.text.isNotEmpty&&codeController.text.isNotEmpty) {
                            checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewStore).then((value) {
                              if(value){
                                storeController.editStore();
                              }
                            }); }else{
                            Get.snackbar("خطأ", "يرجى ملئ البيانات");
                            }


                          },
                          child: const Text("تعديل"))
                    else
                      ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          onPressed: () {
                            if(nameController.text.isNotEmpty&&codeController.text.isNotEmpty) {
                              checkPermissionForOperation(Const.roleUserWrite,Const.roleViewStore).then((value) {
                              if(value)storeController.addNewStore();
                            });
                            }else{
                              Get.snackbar("خطأ", "يرجى ملئ البيانات");
                            }


                            // storeController.clearController();
                            // storeController.getNewCode();
                          },
                          child: const Text("إنشاء")),
                    // if (storeController.editStoreModel?.stId != null)

                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
