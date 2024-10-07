import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/model/seller_model.dart';
import 'package:ba3_business_solutions/utils/confirm_delete_dialog.dart';
import 'package:ba3_business_solutions/view/invoices/New_Invoice_View.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../controller/user_management_model.dart';

class AddSeller extends StatefulWidget {
  const AddSeller({super.key, this.oldKey});

  final String? oldKey;

  @override
  State<AddSeller> createState() => _AddSellerState();
}

class _AddSellerState extends State<AddSeller> {
  var sellerController = Get.find<SellersViewModel>();
  var nameController = TextEditingController();
  var codeController = TextEditingController();
  late SellerModel model;

  @override
  void initState() {
    super.initState();
    if (widget.oldKey == null) {
      model = SellerModel();
      int code = sellerController.allSellers.isEmpty ? 0 : int.parse(sellerController.allSellers.values.last.sellerCode ?? "0") + 1;
      codeController.text = code.toString();
      model.sellerCode = code.toString();
    } else {
      model = sellerController.allSellers[widget.oldKey] ?? SellerModel();
      nameController.text = model.sellerName ?? "";
      codeController.text = model.sellerCode ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<SellersViewModel>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(model.sellerName ?? "جديد"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width * 0.44,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text("الاسم"),
                          ),
                          Expanded(
                            child: CustomTextFieldWithoutIcon(
                              controller: nameController,
                              onChanged: (_) {
                                model.sellerName = _;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.44,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text("الرمز"),
                          ),
                          Expanded(
                            child: CustomTextFieldWithoutIcon(
                              controller: TextEditingController()..text=model.sellerCode??'',
                              onChanged: (_) {
                                model.sellerCode = _;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: Get.width,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 20,
                    spacing: 20,
                    children: [
                      SizedBox(
                        width: Get.width * 0.37,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 120,
                              child: Text("وقت اول دخول"),
                            ),
                            Expanded(
                              child: CustomTextFieldWithoutIcon(
                                controller: TextEditingController()..text= model.sellerTime!.firstTimeEnter??'',
                                onChanged: (_) {
                                  model.sellerTime!.firstTimeEnter = _;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.27,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 120,
                              child: Text("وقت اول خروج"),
                            ),
                            Expanded(
                              child: CustomTextFieldWithoutIcon(
                                // decoration: const InputDecoration(filled: true,fillColor: Colors.white),

                                controller: TextEditingController()..text= model.sellerTime!.firstTimeOut??'',
                                onChanged: (_) {
                                  model.sellerTime!.firstTimeOut = _;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.27,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 120,
                              child: Text("وقت ثاني دخول"),
                            ),
                            Expanded(
                              child: CustomTextFieldWithoutIcon(
                                // decoration: const InputDecoration(filled: true,fillColor: Colors.white),

                                controller: TextEditingController()..text= model.sellerTime!.secondTimeEnter??'',
                                onChanged: (_) {
                                  model.sellerTime!.secondTimeEnter = _;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.27,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 120,
                              child: Text("وقت ثاني خروج"),
                            ),
                            Expanded(
                              child: CustomTextFieldWithoutIcon(
                                // decoration: const InputDecoration(filled: true,fillColor: Colors.white),

                                controller: TextEditingController()..text= model.sellerTime!.secondTimeOut??'',
                                onChanged: (_) {
                                  model.sellerTime!.secondTimeOut = _;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
            /*          SizedBox(
                        width: Get.width * 0.27,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 120,
                              child: Text("بدأ البريك"),
                            ),
                            Expanded(
                              child: CustomTextFieldWithoutIcon(
                                // decoration: const InputDecoration(filled: true,fillColor: Colors.white),

                                controller: TextEditingController()..text= model.sellerTime!.breakTimeEnter??'',
                                onChanged: (_) {
                                  model.sellerTime!.breakTimeEnter = _;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.27,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 120,
                              child: Text("انتهاء البريك"),
                            ),
                            Expanded(
                              child: CustomTextFieldWithoutIcon(
                                // decoration: const InputDecoration(filled: true,fillColor: Colors.white),

                                controller: TextEditingController()..text= model.sellerTime!.breakTimeOut??'',
                                onChanged: (_) {
                                  model.sellerTime!.breakTimeOut = _;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),*/
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (model.sellerDayOff?.firstOrNull != null)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      model.sellerDayOff?.length ?? 0,
                      (index) => Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                        width: Get.width / 6.4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 2.0, color: Colors.green),
                        ),
                        child: Row(
                          // mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              model.sellerDayOff![index].toString().split(" ")[0],
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            IconButton(
                              onPressed: () {
                                model.sellerDayOff!.removeAt(index);
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 2.0, color: Colors.red),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: const Text("لا يوجد ايام عطل"),
                  ),
                const SizedBox(
                  height: 5,
                ),
                IconButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2100),
                      ).then((date) {
                        if (date != null) {
                          model.sellerDayOff!.add(date.toString().split(" ")[0]);
                          setState(() {});
                        }
                      });
                    },
                    icon: const Row(
                      children: [Icon(Icons.add), Text("اضافة يوم عطلة")],
                    )),
                const SizedBox(
                  height: 20,
                ),
                AppButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && codeController.text.isNotEmpty) {
                      if (model.sellerId == null) {
                        checkPermissionForOperation(Const.roleUserWrite, Const.roleViewSeller).then((value) {
                          if (value) sellerController.addSeller(model);
                        });
                      } else {
                        checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewSeller).then((value) {
                          if (value) sellerController.addSeller(model);
                        });
                      }
                    }
                  },
                  title: (model.sellerId == null ? "إنشاء" : "تعديل"),
                  iconData: model.sellerId == null ? Icons.add : Icons.edit,
                  color: model.sellerId == null ? null : Colors.green,
                ),
                const SizedBox(
                  height: 20,
                ),
                if (model.sellerId != null && (model.sellerRecord ?? []).isEmpty)
                  ElevatedButton(
                      onPressed: () {
                        confirmDeleteWidget().then((value) {
                          if (value) {
                            checkPermissionForOperation(Const.roleUserDelete, Const.roleViewSeller).then((value) {
                              if (value) {
                                sellerController.deleteSeller(model);
                                Get.back();
                                Get.back();
                              }
                            });
                          }
                        });
                      },
                      child: Text("حذف")),
              ],
            ),
          ),
        );
      }),
    );
  }
}
