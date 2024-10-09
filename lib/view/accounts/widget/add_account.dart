import 'package:ba3_business_solutions/controller/account/account_view_model.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/shared/widgets/custom_pluto_with_edite.dart';
import 'package:ba3_business_solutions/view/accounts/pages/customer_pluto_edit_view.dart';
import 'package:ba3_business_solutions/view/invoices/pages/New_Invoice_View.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helper/functions/functions.dart';
import '../../../model/account/account_model.dart';
import '../../invoices/widget/custom_TextField.dart';

class AddAccount extends StatefulWidget {
  final String? modelKey;
  final String? oldParent;

  const AddAccount({super.key, this.modelKey, this.oldParent});

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  TextEditingController nameController = TextEditingController();

  String? accountType;

  TextEditingController notesController = TextEditingController();

  TextEditingController codeController = TextEditingController();

  TextEditingController idController = TextEditingController();

  // TextEditingController accVatController = TextEditingController();
  String? accVat;
  TextEditingController accParentId = TextEditingController();
  bool accIsRoot = true;
  AccountModel accountModel = AccountModel();
  bool isNew = true;
  AccountViewModel accountController = Get.find<AccountViewModel>();
  CustomerPlutoEditViewModel customerPlutoEditViewModel =
      Get.find<CustomerPlutoEditViewModel>();

  @override
  void initState() {
    super.initState();
    accParentId.text = widget.oldParent ?? '';
    if (widget.modelKey != null) {
      isNew = false;
      accountModel = AccountModel.fromJson(
          accountController.accountList[widget.modelKey]!.toJson());
      nameController.text = accountModel.accName ?? "23232332";
      accountType = accountModel.accType ?? "23232332";
      notesController.text = accountModel.accComment ?? "23232332";
      codeController.text = accountModel.accCode ?? "23232332";
      accVat = accountModel.accVat ?? "GCC";
      accParentId.text = getAccountNameFromId(accountModel.accParentId);
      accIsRoot = accountModel.accParentId == null;
      customerPlutoEditViewModel.getRows(accountModel.accCustomer ?? []);
      //accountModel.accAggregateList=accountModel.accAggregateList.map((e) => getAccountNameFromId(e)).toList();
      // idController.text = accountModel.accCode??"23232332";
    } else {
      accVat = "GCC";
      codeController.text = accountController.getLastCode();
      accountType = AppConstants.accountTypeList[0];
      if (accParentId.text != '') {
        accIsRoot = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("بطاقة حساب"),
        actions: [
          Container(
            width: Get.width * 0.3,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                const Flexible(flex: 3, child: Text("رمز الحساب: ")),
                Flexible(
                    flex: 3,
                    child:
                        CustomTextFieldWithoutIcon(controller: codeController)),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Flexible(flex: 2, child: Text("اسم الحساب :")),
                        Flexible(
                            flex: 3,
                            child: CustomTextFieldWithoutIcon(
                                controller: nameController)),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Flexible(flex: 2, child: Text("نوع الحساب :")),
                        Flexible(
                            flex: 3,
                            child: StatefulBuilder(builder: (context, setstae) {
                              return DropdownButton(
                                value: accountType,
                                items: AppConstants.accountTypeList
                                    .map((e) => DropdownMenuItem(
                                          child:
                                              Text(getAccountTypeFromEnum(e)),
                                          value: e,
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {});
                                  setstae(() {
                                    accountType = value;
                                  });
                                },
                              );
                            })),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Flexible(flex: 1, child: Text("ملاحظات:")),
                  Flexible(
                      flex: 3,
                      child: CustomTextFieldWithoutIcon(
                          controller: notesController)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("الحساب الاب"),
                  const SizedBox(
                    width: 30,
                  ),
                  Container(
                    width: 300,
                    child: IgnorePointer(
                      ignoring: accIsRoot,
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: accParentId,
                          decoration: const InputDecoration(
                              fillColor: Colors.white, filled: true),
                          onFieldSubmitted: (_) async {
                            List<String> result = searchText(_);
                            if (result.isEmpty) {
                              Get.snackbar("خطأ", "غير موجود");
                            } else if (result.length == 1) {
                              accParentId.text = result[0];
                            } else {
                              await Get.defaultDialog(
                                  title: "اختر احد الحسابات",
                                  content: SizedBox(
                                    height: 500,
                                    width: Get.width / 1.5,
                                    child: ListView.builder(
                                        itemCount: result.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              accParentId.text = result[index];
                                              Get.back();
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${index + 1}_ ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24,
                                                      color:
                                                          Colors.blue.shade700),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  result[index],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
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
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("حساب اب"),
                      const SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                        width: 30,
                        height: 100,
                        child: Checkbox(
                          value: accIsRoot,
                          onChanged: (_) {
                            accIsRoot = _!;
                            accParentId.clear();
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: GetBuilder<AccountViewModel>(
                        builder: (accountController) {
                      return AppButton(
                        onPressed: () async {
                          if (checkInput()) {
                            await updateData(
                                nameController,
                                accountType!,
                                notesController,
                                idController,
                                accVat!,
                                codeController,
                                accParentId.text,
                                accIsRoot);
                            if (accountModel.accId == null) {
                              checkPermissionForOperation(
                                      AppConstants.roleUserWrite,
                                      AppConstants.roleViewAccount)
                                  .then((value) {
                                if (value)
                                  accountController.addNewAccount(accountModel,
                                      withLogger: true);
                              });
                            } else {
                              checkPermissionForOperation(
                                      AppConstants.roleUserUpdate,
                                      AppConstants.roleViewAccount)
                                  .then((value) {
                                if (value)
                                  accountController.updateAccount(accountModel,
                                      withLogger: true);
                              });
                            }
                          }
                        },
                        title: accountModel.accId == null ? "إضافة " : "تعديل ",
                        iconData:
                            accountModel.accId == null ? Icons.add : Icons.edit,
                      );
                    }),
                  ),
                  if (accountModel.accId != null)
                    Container(
                      alignment: Alignment.center,
                      child: GetBuilder<AccountViewModel>(
                          builder: (accountController) {
                        return AppButton(
                          onPressed: () async {},
                          title: "الزبائن",
                          iconData: Icons.person,
                          color: Colors.green,
                        );
                      }),
                    ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                // flex: 3,
                child: GetBuilder<CustomerPlutoEditViewModel>(builder: (logic) {
                  return SizedBox(
                    height: 400,
                    width: Get.width,
                    child: CustomPlutoWithEdite(
                      controller: logic,
                      evenRowColor: Colors.green.shade200,
                      onChanged: (p0) {},
                      onRowSecondaryTap: (plutoGridOnRowSecondaryTapEvent) {},
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateData(
      TextEditingController nameController,
      String typeController,
      TextEditingController notesController,
      TextEditingController idController,
      String accVat,
      TextEditingController codeController,
      String? accParentId,
      bool isRoot) {
    accountModel.accCode = codeController.text;
    accountModel.accName = nameController.text;
    accountModel.accComment = notesController.text;
    accountModel.accType = typeController;
    accountModel.accVat = accVat;
    accountModel.accIsParent = !isRoot;
    if (isRoot) {
      accountModel.accParentId = null;
    } else {
      accountModel.accParentId = getAccountIdFromText(accParentId);
    }
  }

  late List<AccountModel> products = <AccountModel>[];

  List<String> searchText(String query) {
    AccountViewModel accountController = Get.find<AccountViewModel>();
    products = accountController.accountList.values.toList().where((item) {
      var name =
          item.accName.toString().toLowerCase().contains(query.toLowerCase());
      var code =
          item.accCode.toString().toLowerCase().contains(query.toLowerCase());
      print(item.accCode);
      return name || code;
    }).toList();
    return products.map((e) => e.accName!).toList();
  }

  bool checkInput() {
    if (nameController.text.isEmpty) {
      Get.snackbar("خطأ", "يرجى كتابة اسم");
    } else if (accountType == null) {
      Get.snackbar("خطأ", "يرجى كتابة نوع حساب");
    } else if (accVat == null) {
      Get.snackbar("خطأ", "يرجى اختيار نوع الضريبة");
    } else if (codeController.text.isEmpty) {
      Get.snackbar("خطأ", "يرجى كتابة رمز");
    } else if (!accIsRoot && accParentId.text == "") {
      Get.snackbar("خطأ", "يرجى إضافة حساب اب");
    } else {
      return true;
    }
    return false;
  }
}
