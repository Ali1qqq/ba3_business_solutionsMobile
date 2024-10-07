import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/view/invoices/New_Invoice_View.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:ba3_business_solutions/view/widget/CustomWindowTitleBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:get/get.dart';
import '../../controller/user_management_model.dart';

class PatternDetails extends StatefulWidget {
  final String? oldKey;

  const PatternDetails({super.key, this.oldKey});

  @override
  State<PatternDetails> createState() => _PatternDetailsState();
}

class _PatternDetailsState extends State<PatternDetails> {
  PatternViewModel patternController = Get.find<PatternViewModel>();

  @override
  void initState() {
    if (widget.oldKey == null) {
      patternController.clearController();
    } else {
      patternController.initPage(widget.oldKey!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(patternController.editPatternModel!.patId != null ? patternController.editPatternModel!.patName! : "إنشاء نمط"),
        ),
        body: GetBuilder<PatternViewModel>(
          builder: (patternController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(spacing: 20, alignment: WrapAlignment.spaceBetween, runSpacing: 10, children: [
                    SizedBox(
                      width: Get.width * 0.45,
                      child: Row(
                        children: [
                          const SizedBox(width: 100, child: Text("الاختصار :")),
                          Expanded(
                            child: CustomTextFieldWithoutIcon(
                              controller: patternController.nameController,
                              onChanged: (_) {
                                patternController.editPatternModel?.patName = _;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.45,
                      child: Row(
                        children: [
                          const SizedBox(width: 100, child: Text("الاسم :")),
                          Expanded(
                            child: CustomTextFieldWithoutIcon(
                              controller: patternController.fullNameController,
                              onChanged: (_) {
                                patternController.editPatternModel?.patFullName = _;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.45,
                      child: Row(
                        children: [
                          const SizedBox(width: 100, child: Text("الرمز :")),
                          Expanded(
                            child: CustomTextFieldWithoutIcon(
                              controller: patternController.codeController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: (_) {
                                patternController.editPatternModel?.patCode = _;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (patternController.editPatternModel?.patType != Const.invoiceTypeChange) ...[
                      SizedBox(
                        width: Get.width * 0.45,
                        child: IgnorePointer(
                          ignoring: patternController.typeController.text == Const.invoiceTypeAdd,
                          child: Row(
                            children: [
                              const SizedBox(width: 100, child: Text("الدائن")),
                              Expanded(
                                child: Container(
                                  foregroundDecoration: patternController.typeController.text == Const.invoiceTypeAdd ? BoxDecoration(color: Colors.grey.withOpacity(0.5)) : null,
                                  child: CustomTextFieldWithIcon(
                                    controller: patternController.primaryController,
                                    onSubmitted: (text) async {
                                      var a = await getAccountComplete(text);
                                      patternController.update();
                                      if (a.isNotEmpty) {
                                        patternController.editPatternModel?.patPrimary = a;
                                        patternController.primaryController.text = a;
                                        setState(() {});
                                      }
                                    },
                                    onChanged: (_) {
                                      // patternController.editPatternModel?.patPrimary = _;
                                    },
                                  ),
                                ),
                              ),
                              // if (patternController.editPatternModel?.patPrimary != null) Icon(Icons.check),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.45,
                        child: Row(
                          children: [
                            const SizedBox(width: 100, child: Text("المدين")),
                            Expanded(
                              child: CustomTextFieldWithIcon(
                                controller: patternController.secondaryController,
                                onSubmitted: (text) async {
                                  var a = await getAccountComplete(text);
                                  patternController.update();
                                  if (a.isNotEmpty) {
                                    patternController.editPatternModel?.patSecondary = a;
                                    patternController.secondaryController.text = a;
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                            // if (patternController.editPatternModel?.patSecondary != null) Icon(Icons.check),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(
                      width: Get.width * 0.45,
                      child: Row(
                        children: [
                          const SizedBox(width: 100, child: Text("النوع :")),
                          Container(
                            width: (Get.width * 0.45) - 100,
                            height: Const.constHeightTextField,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: DropdownButton(
                                dropdownColor: Colors.white,
                                focusColor: Colors.white,
                                alignment: Alignment.center,
                                underline: const SizedBox(),
                                isExpanded: true,
                                value: patternController.typeController.text.isEmpty ? Const.invoiceTypeSales : patternController.typeController.text,
                                items: const [
                                  DropdownMenuItem(
                                    value: Const.invoiceTypeSales,
                                    child: Center(
                                      child: Text(
                                        "مبيع",
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: Const.invoiceTypeBuy,
                                    child: Center(child: Text("شراء", textDirection: TextDirection.rtl)),
                                  ),
                                  DropdownMenuItem(
                                    value: Const.invoiceTypeAdd,
                                    child: Center(child: Text("إدخال", textDirection: TextDirection.rtl)),
                                  ),
                                  DropdownMenuItem(
                                    value: Const.invoiceTypeChange,
                                    child: Center(child: Text("تبديل مستودعي", textDirection: TextDirection.rtl)),
                                  ),
                                  DropdownMenuItem(
                                    value: Const.invoiceTypeSalesWithPartner,
                                    child: Center(child: Text("مبيعات مع شريك", textDirection: TextDirection.rtl)),
                                  ),
                                ],
                                onChanged: (_) {
                                  patternController.typeController.text = _!;
                                  patternController.editPatternModel?.patType = _;
                                  if (patternController.typeController.text == Const.invoiceTypeAdd) {
                                    patternController.editPatternModel?.patPrimary = null;
                                    patternController.primaryController.clear();
                                  }
                                  setState(() {});
                                }),
                          ),
                        ],
                      ),
                    ),
                    if (patternController.editPatternModel?.patType == Const.invoiceTypeChange)
                      SizedBox(
                        width: Get.width * 0.45,
                        child: Row(
                          children: [
                            const SizedBox(width: 100, child: Text("المستودع الجديد:")),
                            Expanded(
                              child: CustomTextFieldWithIcon(
                                controller: patternController.storeNewController,
                                onSubmitted: (text) async {
                                  var a = await patternController.getStoreComplete(text);
                                  if (a.isNotEmpty) {
                                    patternController.editPatternModel?.patNewStore = a;
                                    patternController.storeNewController.text = a;
                                    setState(() {});
                                  }
                                },
                                onChanged: (_) {
                                  // patternController.editPatternModel?.patStore = _;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (patternController.editPatternModel?.patType != Const.invoiceTypeChange) ...[
                      SizedBox(
                        width: Get.width * 0.45,
                        child: Row(
                          children: [
                            const SizedBox(width: 100, child: Text("حساب الهدايا ")),
                            Expanded(
                              child: CustomTextFieldWithIcon(
                                controller: patternController.giftAccountController,
                                onSubmitted: (text) async {
                                  var a = await getAccountComplete(text);
                                  patternController.update();
                                  if (a.isNotEmpty) {
                                    patternController.editPatternModel?.patGiftAccount = a;
                                    patternController.giftAccountController.text = a;
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                            // if (patternController.editPatternModel?.patGiftAccount != null) Icon(Icons.check)
                          ],
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.45,
                        child: Row(
                          children: [
                            const SizedBox(width: 100, child: Text("حساب  المقابل الهدايا ")),
                            Expanded(
                              child: CustomTextFieldWithIcon(
                                controller: patternController.secgiftAccountController,
                                onSubmitted: (text) async {
                                  var a = await getAccountComplete(text);
                                  patternController.update();
                                  if (a.isNotEmpty) {
                                    patternController.editPatternModel?.patSecGiftAccount = a;
                                    patternController.secgiftAccountController.text = a;
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                            // if (patternController.editPatternModel?.patSecGiftAccount != null) Icon(Icons.check)
                          ],
                        ),
                      ),
                    ],
                    SizedBox(
                      width: Get.width * 0.45,
                      child: Row(
                        children: [
                          const SizedBox(width: 100, child: Text("المستودع :")),
                          Expanded(
                            child: CustomTextFieldWithIcon(
                              controller: patternController.storeEditController,
                              onSubmitted: (text) async {
                                var a = await patternController.getStoreComplete(text);
                                if (a.isNotEmpty) {
                                  patternController.editPatternModel?.patStore = a;
                                  patternController.storeEditController.text = a;
                                  setState(() {});
                                }
                              },
                              onChanged: (_) {
                                // patternController.editPatternModel?.patStore = _;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (patternController.editPatternModel?.patType == Const.invoiceTypeSalesWithPartner) ...[
                      SizedBox(
                        width: (Get.width * 0.45),
                        child: Row(
                          children: [
                            const SizedBox(width: 100, child: Text("حساب مرابح الشريك :")),
                            Expanded(
                              child: CustomTextFieldWithIcon(
                                controller: patternController.patPartnerAccountFee,
                                onSubmitted: (text) async {
                                  var a = await getAccountComplete(text);

                                  patternController.update();
                                  if (a.isNotEmpty) {
                                    patternController.editPatternModel?.patPartnerFeeAccount = a;
                                    patternController.patPartnerAccountFee.text = a;
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: ((Get.width * 0.45) / 2)-5,
                            child: Row(
                              children: [
                                const SizedBox(width: 100, child: Text("نسبة الشريك :")),
                                Expanded(
                                  child: CustomTextFieldWithoutIcon(
                                    controller: patternController.patPartnerRatio,
                                    onSubmitted: (text) async {},
                                    onChanged: (_) {
                                      patternController.editPatternModel?.patPartnerRatio = double.tryParse(_) ?? 0.0;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10,),
                          SizedBox(
                            width: ((Get.width * 0.45) / 2)-5,
                            child: Row(
                              children: [
                                const SizedBox(width: 100, child: Text("عمولة التحويل :")),
                                Expanded(
                                  child: CustomTextFieldWithoutIcon(
                                    controller: patternController.patPartnerCommission,
                                    onSubmitted: (text) async {},
                                    onChanged: (_) {
                                      patternController.editPatternModel?.patPartnerCommission = double.tryParse(_) ?? 0.0;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ]),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: MaterialColorPicker(
                        allowShades: false, // default true

                        onMainColorChange: (ColorSwatch? color) {
                          patternController.editPatternModel?.patColor = color?.value;
                          // Handle main color changes
                        },
                        // colors: listColor(),
                        selectedColor: Color(patternController.editPatternModel?.patColor ?? 4294198070)),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AppButton(
                          title: "جديد",
                          onPressed: () {
                            patternController.clearController();
                          },
                          iconData: Icons.open_in_new_outlined),
                      AppButton(
                        title: patternController.editPatternModel?.patId != null ? "تعديل" : "اضافة",
                        onPressed: () {
                          if (patternController.editPatternModel?.patName?.isEmpty ?? true) {
                            Get.snackbar("خطأ", "يرجى كتابة الاسم");
                          } else if (patternController.editPatternModel?.patCode?.isEmpty ?? true) {
                            Get.snackbar("خطأ", "يرجى كتابة الرمز");
                          } else if ((patternController.editPatternModel?.patPrimary?.isEmpty ?? true) && patternController.editPatternModel?.patType != Const.invoiceTypeAdd && patternController.editPatternModel?.patType != Const.invoiceTypeChange) {
                            Get.snackbar("خطأ", "يرجى كتابة الحساب الاساسي");
                          } else if ((patternController.editPatternModel?.patSecondary?.isEmpty ?? true) && patternController.editPatternModel?.patType != Const.invoiceTypeChange) {
                            Get.snackbar("خطأ", "يرجى كتابة الحساب الثانوي");
                          }  else if (patternController.editPatternModel?.patType?.isEmpty ?? true) {
                            Get.snackbar("خطأ", "يرجى كتابة نوع النمط");
                          } else if (patternController.editPatternModel?.patStore?.isEmpty ?? true) {
                            Get.snackbar("خطأ", "يرجى كتابة المستودع");
                          } else {
                            if (patternController.editPatternModel?.patId != null) {
                              checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewPattern).then((value) {
                                if (value) patternController.editPattern();
                              });
                            } else {
                              checkPermissionForOperation(Const.roleUserWrite, Const.roleViewPattern).then((value) {
                                if (value) patternController.addPattern();
                              });
                            }
                          }
                        },
                        iconData: patternController.editPatternModel?.patId != null ? Icons.edit : Icons.add,
                        color: patternController.editPatternModel?.patId != null ? Colors.green : null,
                      ),
                      if (patternController.editPatternModel?.patId != null)
                        AppButton(
                          title: "حذف",
                          onPressed: () {
                            checkPermissionForOperation(Const.roleUserDelete, Const.roleViewPattern).then((value) {
                              if (value) patternController.deletePattern();
                            });
                          },
                          iconData: Icons.delete,
                          color: Colors.red,
                        )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
