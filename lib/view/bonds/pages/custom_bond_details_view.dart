import 'package:ba3_business_solutions/controller/bond/bond_view_model.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/utils/date_picker.dart';
import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controller/account/account_view_model.dart';
import '../../../controller/globle/global_view_model.dart';
import '../../../controller/user/user_management_model.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../core/utils/confirm_delete_dialog.dart';
import '../../../model/account/account_model.dart';
import '../../../model/bond/bond_record_model.dart';

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
    bondController.initCodeList(widget.isDebit
        ? AppConstants.bondTypeDebit
        : AppConstants.bondTypeCredit);
    if (widget.oldId != null || widget.oldBondModel != null) {
      print("init");
      bondController.tempBondModel = GlobalModel.fromJson(
          widget.oldBondModel?.toFullJson() ??
              bondController.allBondsItem[widget.oldId]!.toFullJson());
      print(bondController.tempBondModel);
      bondController.bondModel =
          widget.oldBondModel ?? bondController.allBondsItem[widget.oldId]!;
      print(bondController.tempBondModel.toFullJson());
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
      bondController.tempBondModel.bondType = widget.isDebit
          ? AppConstants.bondTypeDebit
          : AppConstants.bondTypeCredit;
      newCodeController.text = bondController.getNextBondCode(
          type: widget.isDebit
              ? AppConstants.bondTypeDebit
              : AppConstants.bondTypeCredit);
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
    return GetBuilder<BondViewModel>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
                "${bondController.bondModel.bondCode ?? AppStrings.newDocument.tr} "
                "${getBondTypeFromEnum(bondController.tempBondModel.bondType.toString())}"),
            // leading: const BackButton(),
            actions: !checkPermission(
                    AppConstants.roleUserAdmin, AppConstants.roleViewInvoice)
                ? []
                : isNew
                    ? [
                        Row(
                          children: [
                            Text(AppStrings.documentDate.tr,
                                style: TextStyle()),
                            DatePicker(
                              initDate: controller.tempBondModel.bondDate,
                              onSubmit: (_) {
                                controller.tempBondModel.bondDate =
                                    _.toString().split(".")[0];
                                controller.update();
                              },
                            ),
                            const SizedBox(width: 50),
                          ],
                        ),
                        Text(AppStrings.documentDateSerialNumber.tr),
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            controller: newCodeController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onTapOutside: (_) {
                              if (controller.codeList.keys
                                  .toList()
                                  .contains(newCodeController.text)) {
                                Get.snackbar("Error", "Is Used");
                                newCodeController.text = defualtCode;
                              } else {
                                controller.tempBondModel.bondCode =
                                    newCodeController.text;
                              }
                            },
                            onFieldSubmitted: (_) {
                              if (controller.codeList.keys
                                  .toList()
                                  .contains(newCodeController.text)) {
                                Get.snackbar("Error", "Is Used");
                                newCodeController.text = defualtCode;
                              } else {
                                controller.tempBondModel.bondCode =
                                    newCodeController.text;
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                      ]
                    : [
                        Row(
                          children: [
                            Text(AppStrings.documentDate.tr,
                                style: TextStyle()),
                            DatePicker(
                              initDate: controller.tempBondModel.bondDate,
                              onSubmit: (_) {
                                controller.tempBondModel.bondDate =
                                    _.toString().split(".")[0];
                                controller.update();
                              },
                            ),
                            const SizedBox(width: 50),
                          ],
                        ),
                        if (controller.allBondsItem.values
                                .toList()
                                .firstOrNull
                                ?.bondId !=
                            controller.bondModel.bondId)
                          TextButton(
                              onPressed: () {
                                controller.firstBond();
                              },
                              child:
                                  const Icon(Icons.keyboard_double_arrow_right))
                        else
                          const SizedBox(
                            width: 50,
                          ),
                        if (controller.allBondsItem.values
                                .toList()
                                .firstOrNull
                                ?.bondId !=
                            controller.bondModel.bondId)
                          TextButton(
                              onPressed: () {
                                controller.prevBond();
                              },
                              child: const Icon(Icons.keyboard_arrow_right))
                        else
                          const SizedBox(
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onFieldSubmitted: (_) {
                              controller.changeIndexCode(
                                code: _,
                                type: controller.tempBondModel.bondType!,
                              );
                              // bondController.initPage(bondController.tempBondModel.bondType);
                            },
                            decoration:
                                const InputDecoration.collapsed(hintText: ""),
                            controller: TextEditingController(
                                text: bondController.tempBondModel.bondCode),
                          ),
                        ),
                        if (controller.allBondsItem.values
                                .toList()
                                .lastOrNull
                                ?.bondId !=
                            controller.bondModel.bondId)
                          TextButton(
                              onPressed: () {
                                controller.nextBond();
                              },
                              child: const Icon(Icons.keyboard_arrow_left))
                        else
                          const SizedBox(
                            width: 55,
                          ),
                        if (controller.allBondsItem.values
                                .toList()
                                .lastOrNull
                                ?.bondId !=
                            controller.bondModel.bondId)
                          TextButton(
                              onPressed: () {
                                controller.lastBond();
                              },
                              child:
                                  const Icon(Icons.keyboard_double_arrow_left))
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
                                    checkPermissionForOperation(
                                            AppConstants.roleUserDelete,
                                            AppConstants.roleViewBond)
                                        .then((value) async {
                                      if (value) {
                                        globalController.deleteGlobal(
                                            bondController.tempBondModel);
                                        Get.back();
                                        controller.update();
                                      }
                                    });
                                  }
                                });
                              },
                              child: Text(AppStrings.delete.tr))
                        else
                          const SizedBox(
                            width: 20,
                          ),
                        const SizedBox(
                          width: 50,
                        ),
                      ]),
        body: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                Text(AppStrings.accountName.tr),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: controller.userAccountController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white, filled: true),
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
                              width: Get.width / 1.5,
                              child: ListView.builder(
                                  itemCount: result.length,
                                  itemBuilder: (contet, index) {
                                    return InkWell(
                                      onTap: () {
                                        controller.userAccountController.text =
                                            result[index];
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
                                  child: Text(AppStrings.exit.tr))
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
                            if (swipeStartDetails.swipeDirection ==
                                DataGridRowSwipeDirection.endToStart) {
                              return false;
                            }
                            if (swipeStartDetails.rowIndex ==
                                    bondController
                                        .tempBondModel.bondRecord?.length ||
                                bondController
                                        .tempBondModel.bondRecord?.length ==
                                    1) {
                              return false;
                            }
                            return true;
                          },
                          startSwipeActionsBuilder: (BuildContext context,
                              DataGridRow row, int rowIndex) {
                            return GestureDetector(
                                onTap: () {
                                  // controller.deleteOneRecord(rowIndex);
                                  // controller.initPage(bondController.tempBondModel.bondType);
                                },
                                child: Container(
                                    color: Colors.red,
                                    padding: const EdgeInsets.only(left: 30.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(AppStrings.delete.tr,
                                        style:
                                            TextStyle(color: Colors.white))));
                          },
                          columns: <GridColumn>[
                            GridColumnItem(
                                label: "الرمز التسلسلي",
                                name: AppStrings.rowBondId.tr),
                            GridColumnItem(
                                label: 'الحساب',
                                name: AppStrings.rowBondAccount.tr),
                            widget.isDebit
                                ? GridColumnItem(
                                    label: ' مدين',
                                    name: AppStrings.rowBondDebitAmount.tr)
                                : GridColumnItem(
                                    label: ' دائن',
                                    name: AppStrings.rowBondCreditAmount.tr),
                            GridColumnItem(
                                label: "البيان",
                                name: AppStrings.rowBondDescription.tr),
                          ],
                        );
                      });
                    }
                  }),
            ),
            Row(
              children: [
                const Spacer(),
                Text(AppStrings.total.tr),
                const SizedBox(
                  width: 30,
                ),
                if (widget.isDebit)
                  Builder(builder: (context) {
                    double _ = 0;
                    bondController.tempBondModel.bondRecord!.forEach((element) {
                      _ = _ + element.bondRecDebitAmount!;
                    });
                    return Container(
                        color: Colors.green,
                        padding: const EdgeInsets.all(8),
                        child: Text(_.toString()));
                  }),
                const SizedBox(
                  width: 20,
                ),
                if (!widget.isDebit)
                  Builder(builder: (context) {
                    double _ = 0;
                    bondController.tempBondModel.bondRecord!.forEach((element) {
                      _ = _ + element.bondRecCreditAmount!;
                    });
                    return Container(
                        color: Colors.green,
                        padding: const EdgeInsets.all(8),
                        child: Text(_.toString()));
                  }),
                const SizedBox(
                  width: 50,
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  if (controller.userAccountController.text.isEmpty) {
                    Get.snackbar(
                        AppStrings.error.tr, AppStrings.accountFieldEmpty.tr);
                    return;
                  }
                  var validate = bondController.checkValidate();
                  if (validate != null) {
                    Get.snackbar(AppStrings.error.tr, validate);
                    return;
                  }
                  var mainAccount = accountController.accountList.values
                      .toList()
                      .firstWhere((e) =>
                          e.accName == controller.userAccountController.text)
                      .accId;
                  double total = 0;
                  bondController.tempBondModel.bondRecord?.forEach((element) {
                    if (bondController.tempBondModel.bondType ==
                        AppConstants.bondTypeDebit) {
                      total += element.bondRecDebitAmount ?? 0;
                    } else {
                      total += element.bondRecCreditAmount ?? 0;
                    }
                  });
                  // var total = int.parse(bondController.tempBondModel.bondTotal!);

                  // if (!isNew) {
                  //   bondController.tempBondModel.bondRecord?.removeWhere((element) => element.bondRecId == "X");
                  // }
                  bondController.tempBondModel.bondRecord?.add(BondRecordModel(
                      "X",
                      widget.isDebit ? total : 0,
                      widget.isDebit ? 0 : total,
                      mainAccount,
                      "تم توليده بشكل تلقائي"));
                  var validate2 = bondController.checkValidate();
                  if (isNew) {
                    if (validate2 == null) {
                      checkPermissionForOperation(AppConstants.roleUserWrite,
                              AppConstants.roleViewBond)
                          .then((value) async {
                        if (value) {
                          print(bondController.tempBondModel.bondRecord
                              ?.map((e) => e.toJson()));
                          await globalController
                              .addGlobalBond(bondController.tempBondModel);
                          isNew = false;
                          controller.isEdit = false;
                          bondController.tempBondModel.bondRecord?.removeWhere(
                              (element) => element.bondRecId == "X");
                        }
                      });
                    } else {
                      Get.snackbar(AppStrings.error.tr, validate2);
                    }
                  } else if (controller.bondModel.originId == null) {
                    if (validate2 == null) {
                      checkPermissionForOperation(AppConstants.roleUserUpdate,
                              AppConstants.roleViewBond)
                          .then((value) async {
                        if (value) {
                          GlobalModel temp = GlobalModel.fromJson(
                              bondController.tempBondModel.toFullJson());
                          bondController.tempBondModel.bondRecord?.removeWhere(
                              (element) => element.bondRecId == "X");
                          await globalController.updateGlobalBond(temp);

                          isNew = false;
                          controller.isEdit = false;
                        }
                      });
                    } else {
                      Get.snackbar(AppStrings.error.tr, validate2);
                    }
                  }
                },
                child: Text(
                  isNew ? AppStrings.addString : AppStrings.update,
                  maxLines: 4,
                )),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      );
    });
  }

  GridColumn GridColumnItem({required label, name}) {
    return GridColumn(
        allowEditing: name == AppStrings.rowBondId ? false : true,
        columnName: name,
        label: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text(
              label.toString(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            )));
  }

  late List<AccountModel> products = <AccountModel>[];

  List<String> searchText(String query) {
    AccountViewModel accountController = Get.find<AccountViewModel>();
    products = accountController.accountList.values.toList().where((item) {
      var name =
          item.accName.toString().toLowerCase().contains(query.toLowerCase());
      var code =
          item.accCode.toString().toLowerCase().contains(query.toLowerCase());
      return name || code;
    }).toList();
    return products.map((e) => e.accName!).toList();
  }
}
