import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/utils/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../controller/account_view_model.dart';
import '../../controller/global_view_model.dart';
import '../../controller/user_management_model.dart';
import '../../model/account_model.dart';

import '../../model/bond_record_model.dart';
import '../../utils/confirm_delete_dialog.dart';
import '../widget/CustomWindowTitleBar.dart';

class CustomBondDetailsView extends StatefulWidget {
  const CustomBondDetailsView({
    Key? key,
    this.oldBondModel,
    this.oldId,
    this.oldModelKey,
    required this.isDebit,
  }) : super(key: key);
  final GlobalModel? oldBondModel;
  final String? oldModelKey;
  final String? oldId;
  final bool isDebit;

  @override
  _CustomBondDetailsViewState createState() => _CustomBondDetailsViewState();
}

class _CustomBondDetailsViewState extends State<CustomBondDetailsView> {
  var bondController = Get.find<BondViewModel>();
  var i = 0;
  List<BondRecordModel> record = <BondRecordModel>[];
  var globalController = Get.find<GlobalViewModel>();

  bool isNew = false;
  var newCodeController = TextEditingController();
  // var controller.userAccountController = TextEditingController();
  String defualtCode = '';
  var accountController = Get.find<AccountViewModel>();

  //late GlobalModel bondModel;
  @override
  void initState() {
    super.initState();
    initPage();
  }

  late AccountModel primeryAccount;
  void initPage() {
    bondController.initCodeList(widget.isDebit ? Const.bondTypeDebit : Const.bondTypeCredit);
    if (widget.oldId != null || widget.oldBondModel != null) {
      print("init");
      bondController.tempBondModel = GlobalModel.fromJson(widget.oldBondModel?.toFullJson() ?? bondController.allBondsItem[widget.oldId]!.toFullJson());
      print(bondController.tempBondModel);
      bondController.bondModel = widget.oldBondModel ?? bondController.allBondsItem[widget.oldId]!;
      print( bondController.tempBondModel.toFullJson());
      isNew = false;
      // var aa = bondController.tempBondModel.bondRecord
      //     ?.where(
      //       (element) => element.bondRecId == "X",
      //     )
      //     .first
      //     .bondRecAccount;
      // // var _ = accountController.accountList.values.toList().firstWhere((e) => e.accId == bondController.tempBondModel.bondRecord?[0].bondRecAccount).accName;
      // bondController.userAccountController.text = getAccountNameFromId(aa)!;
      // bondController.tempBondModel.bondRecord?.removeWhere(
      //   (element) => element.bondRecId == "X",
      // );
    } else {
      bondController.tempBondModel = getBondData();
      bondController.bondModel = getBondData();
      isNew = true;
      bondController.tempBondModel.bondType = widget.isDebit ? Const.bondTypeDebit : Const.bondTypeCredit;
      newCodeController.text = bondController.getNextBondCode(type: widget.isDebit ? Const.bondTypeDebit : Const.bondTypeCredit);
      bondController.tempBondModel.bondCode = newCodeController.text;
    }
    defualtCode = bondController.tempBondModel.bondCode!;
    // bondController.initPage(bondController.tempBondModel.bondType);

    // newCodeController.text = (int.parse(bondController.allBondsItem.values.lastOrNull?.bondCode ?? "0") + 1).toString();
    // while (bondController.allBondsItem.values.toList().map((e) => e.bondCode).toList().contains(newCodeController.text)) {
    //   newCodeController.text = (int.parse(newCodeController.text) + 1).toString();
    //   defualtCode = newCodeController.text;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<BondViewModel>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Text("${bondController.bondModel.bondCode ?? "سند جديد"} ${getBondTypeFromEnum(bondController.tempBondModel.bondType.toString())}"),
              // leading: const BackButton(),
              actions:  !checkPermission(Const.roleUserAdmin, Const.roleViewInvoice)?[]:isNew
                  ? [
                            Row(
                  children: [
                    const Text("تاريخ السند : ", style: TextStyle()),
                   DatePicker(
                          initDate:  controller.tempBondModel.bondDate,
                          onSubmit: (_) {
                             controller.tempBondModel.bondDate = _.toString().split(".")[0];
                            controller.update();
                          },
                        ),
                          SizedBox(width:50),
                  ],
                ),
                      const Text("الرمز التسلسلي: "),
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          controller: newCodeController,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onTapOutside: (_) {
                            if (controller.codeList.keys.toList().contains(newCodeController.text)) {
                              Get.snackbar("Error", "Is Used");
                              newCodeController.text = defualtCode;
                            } else {
                              controller.tempBondModel.bondCode = newCodeController.text;
                            }
                          },
                          onFieldSubmitted: (_) {
                            if (controller.codeList.keys.toList().contains(newCodeController.text)) {
                              Get.snackbar("Error", "Is Used");
                              newCodeController.text = defualtCode;
                            } else {
                              controller.tempBondModel.bondCode = newCodeController.text;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                    ]
                  : [
                            Row(
                  children: [
                    const Text("تاريخ السند : ", style: TextStyle()),
                   DatePicker(
                          initDate:  controller.tempBondModel.bondDate,
                          onSubmit: (_) {
                             controller.tempBondModel.bondDate = _.toString().split(".")[0];
                            controller.update();
                          },
                        ),
                          SizedBox(width:50),
                  ],
                ),   if (controller.allBondsItem.values.toList().firstOrNull?.bondId != controller.bondModel.bondId)
                        TextButton(
                            onPressed: () {
                              controller.firstBond();

                            },
                            child: const Icon(Icons.keyboard_double_arrow_right))
                      else
                        const SizedBox(
                          width: 50,
                        ),
                      if (controller.allBondsItem.values.toList().firstOrNull?.bondId != controller.bondModel.bondId)
                        TextButton(
                            onPressed: () {
                             controller.prevBond();

                            },
                            child: Icon(Icons.keyboard_arrow_right))
                      else
                        SizedBox(
                          width: 50,
                        ),
                      // Text((isNew
                      //         ? controller.allBondsItem.length
                      //         : controller.allBondsItem.values
                      //             .toList()
                      //             .indexWhere((element) => element.bondId == controller.bondModel.bondId))
                      //     .toString()),
                      Container(
                        decoration: BoxDecoration(border: Border.all()),

                        padding: const EdgeInsets.all(5),
                        width: 80,
                        child: TextFormField(
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onFieldSubmitted: (_) {
                            controller.changeIndexCode(code: _,type: controller.tempBondModel.bondType!,);
                            // bondController.initPage(bondController.tempBondModel.bondType);
                          },
                          decoration: const InputDecoration.collapsed(hintText: ""),
                          controller: TextEditingController(text: bondController.tempBondModel.bondCode),
                        ),
                      ),
                      if (controller.allBondsItem.values.toList().lastOrNull?.bondId != controller.bondModel.bondId)
                        TextButton(
                            onPressed: () {
                              controller.nextBond();

                            },
                            child: const Icon(Icons.keyboard_arrow_left))
                      else
                        const SizedBox(
                          width: 55,
                        ),
                         if (controller.allBondsItem.values.toList().lastOrNull?.bondId != controller.bondModel.bondId)
                        TextButton(
                            onPressed: () {
                              controller.lastBond();

                            },
                            child: const Icon(Icons.keyboard_double_arrow_left))
                      else
                        const SizedBox(
                          width: 55,
                        ),
                      const SizedBox(
                        width: 50,
                      ),
                      if (!isNew)
                        ElevatedButton(
                            onPressed: () async {
                              confirmDeleteWidget().then((value) {
                                if (value) {
                                  checkPermissionForOperation(Const.roleUserDelete, Const.roleViewBond).then((value) async {
                                    if (value) {
                                      globalController.deleteGlobal(bondController.tempBondModel);
                                      Get.back();
                                      controller.update();
                                    }
                                  });
                                }
                              });
                            },
                            child: Text("حذف"))
                      else
                        const SizedBox(
                          width: 20,
                        ),
                      const SizedBox(
                        width: 50,
                      ),
                    ]),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    const Text("اسم الحساب"),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: controller.userAccountController,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true
                        ),
                        onFieldSubmitted: (_) async {
                          List<String> result = searchText(_);
                          if (result.isEmpty) {
                            Get.snackbar("خطأ", "غير موجود");
                          } else if (result.length == 1) {
                            controller.userAccountController.text = result[0];
                          } else {
                            await Get.defaultDialog(
                                title: "اختر احد الحسابات",
                                content: SizedBox(
                                  height: 500,
                                  width: Get.width/1.5,
                                  child: ListView.builder(
                                      itemCount: result.length,
                                      itemBuilder: (contet, index) {
                                        return InkWell(
                                          onTap: () {
                                            controller.userAccountController.text = result[index];
                                            Get.back();
                                          },
                                          child: Text(result[index]),
                                        );
                                      }),
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text("خروج"))
                                ]);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: controller.allBondsItem.stream,
                      builder: (context, snapshot) {
                        if (snapshot.data == "null") {
                          return const CircularProgressIndicator();
                        } else {
                          return GetBuilder<BondViewModel>(builder: (controller) {
                            // if (controller.bondModel.originId != null) {
                            // initPage();
                            // }
                           // controller.initPage(bondController.tempBondModel.bondType);
                            return SfDataGrid(
                              source: bondController.customBondRecordDataSource,
                              controller: bondController.dataGridController,
                              allowEditing: controller.bondModel.originId == null,
                              selectionMode: SelectionMode.singleDeselect,
                              editingGestureType: EditingGestureType.tap,
                              navigationMode: GridNavigationMode.cell,
                              columnWidthMode: ColumnWidthMode.fill,
                              allowSwiping: controller.bondModel.originId == null,
                              swipeMaxOffset: 200,
                              onSwipeStart: (swipeStartDetails) {
                                if (swipeStartDetails.swipeDirection == DataGridRowSwipeDirection.endToStart) {
                                  return false;
                                }
                                if (swipeStartDetails.rowIndex == bondController.tempBondModel.bondRecord?.length || bondController.tempBondModel.bondRecord?.length == 1) {
                                  return false;
                                }
                                return true;
                              },
                              startSwipeActionsBuilder: (BuildContext context, DataGridRow row, int rowIndex) {
                                return GestureDetector(
                                    onTap: () {
                                      // controller.deleteOneRecord(rowIndex);
                                      // controller.initPage(bondController.tempBondModel.bondType);
                                    },
                                    child: Container(color: Colors.red, padding: const EdgeInsets.only(left: 30.0), alignment: Alignment.centerLeft, child: const Text('Delete', style: TextStyle(color: Colors.white))));
                              },
                              columns: <GridColumn>[
                                GridColumnItem(label: "الرمز التسلسلي", name: Const.rowBondId),
                                GridColumnItem(label: 'الحساب', name: Const.rowBondAccount),
                                widget.isDebit ? GridColumnItem(label: ' مدين', name: Const.rowBondDebitAmount) : GridColumnItem(label: ' دائن', name: Const.rowBondCreditAmount),
                                GridColumnItem(label: "البيان", name: Const.rowBondDescription),
                              ],
                            );
                          });
                        }
                      }),
                ),
                Row(
                  children: [
                    Spacer(),
                    Text("المجموع"),
                    SizedBox(
                      width: 30,
                    ),
                    if (widget.isDebit)
                      Builder(builder: (context) {
                        double _ = 0;
                        bondController.tempBondModel.bondRecord!.forEach((element) {
                          _ = _ + element.bondRecDebitAmount!;
                        });
                        return Container(color: Colors.green, padding: EdgeInsets.all(8), child: Text(_.toString()));
                      }),
                    SizedBox(
                      width: 20,
                    ),
                    if (!widget.isDebit)
                      Builder(builder: (context) {
                        double _ = 0;
                        bondController.tempBondModel.bondRecord!.forEach((element) {
                          _ = _ + element.bondRecCreditAmount!;
                        });
                        return Container(color: Colors.green, padding: EdgeInsets.all(8), child: Text(_.toString()));
                      }),
                    SizedBox(
                      width: 50,
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      if (controller.userAccountController.text.isEmpty) {
                        Get.snackbar("خطأ", "حقل الحساب فارغ");
                        return;
                      }
                      var validate = bondController.checkValidate();
                      if (validate != null) {
                        Get.snackbar("خطأ", validate);
                        return;
                      }
                      var mainAccount = accountController.accountList.values.toList().firstWhere((e) => e.accName == controller.userAccountController.text).accId;
                      double total = 0;
                      bondController.tempBondModel.bondRecord?.forEach((element) {
                        if (bondController.tempBondModel.bondType == Const.bondTypeDebit) {
                          total += element.bondRecDebitAmount ?? 0;
                        } else {
                          total += element.bondRecCreditAmount ?? 0;
                        }
                      });
                      // var total = int.parse(bondController.tempBondModel.bondTotal!);

                      // if (!isNew) {
                      //   bondController.tempBondModel.bondRecord?.removeWhere((element) => element.bondRecId == "X");
                      // }
                      bondController.tempBondModel.bondRecord?.add(BondRecordModel("X", widget.isDebit ? total : 0, widget.isDebit ? 0 : total, mainAccount, "تم توليده بشكل تلقائي"));
                      var validate2 = bondController.checkValidate();
                      if (isNew) {
                        if (validate2 == null) {
                          checkPermissionForOperation(Const.roleUserWrite, Const.roleViewBond).then((value) async {
                            if (value) {
                              print(bondController.tempBondModel.bondRecord?.map((e) => e.toJson()));
                              await globalController.addGlobalBond(bondController.tempBondModel);
                              isNew = false;
                              controller.isEdit = false;
                              bondController.tempBondModel.bondRecord?.removeWhere((element) => element.bondRecId == "X");
                            }
                          });
                        } else {
                          Get.snackbar("خطأ", validate2);
                        }
                      } else if (controller.bondModel.originId == null) {
                        if (validate2 == null) {
                          checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewBond).then((value) async {
                            if (value) {
                              GlobalModel temp = GlobalModel.fromJson(bondController.tempBondModel.toFullJson());
                              bondController.tempBondModel.bondRecord?.removeWhere((element) => element.bondRecId == "X");
                              await globalController.updateGlobalBond(temp);

                              isNew = false;
                              controller.isEdit = false;
                            }
                          });
                        } else {
                          Get.snackbar("خطأ", validate2);
                        }
                      }
                    },
                    child: Text(
                      isNew
                          ? "إضافة"
                          : "تحديث",
                      maxLines: 4,
                    )),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  GridColumn GridColumnItem({required label, name}) {
    return GridColumn(
        allowEditing: name == Const.rowBondId ? false : true,
        columnName: name,
        label: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text(
              label.toString(),
              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w700),
            )));
  }

  late List<AccountModel> products = <AccountModel>[];

  List<String> searchText(String query) {
    AccountViewModel accountController = Get.find<AccountViewModel>();
    products = accountController.accountList.values.toList().where((item) {
      var name = item.accName.toString().toLowerCase().contains(query.toLowerCase());
      var code = item.accCode.toString().toLowerCase().contains(query.toLowerCase());
      return name || code;
    }).toList();
    return products.map((e) => e.accName!).toList();
  }
}
