import 'package:ba3_business_solutions/Dialogs/Account_Option_Dialog.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/view/accounts/account_tree_view.dart';
import 'package:ba3_business_solutions/view/accounts/account_view.dart';
import 'package:ba3_business_solutions/view/accounts/widget/add_account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../Dialogs/AccountDueOption.dart';
import '../../Widgets/CustomerPlutoEditView.dart';
import '../invoices/Controller/Search_View_Controller.dart';
import 'All_Due_Account.dart';
import 'PartnerDueAccount.dart';

class AccountType extends StatefulWidget {
  const AccountType({super.key});

  @override
  State<AccountType> createState() => _AccountTypeState();
}

class _AccountTypeState extends State<AccountType> {
  PatternViewModel patternController = Get.find<PatternViewModel>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الحسابات"),
        ),
        body: Column(
          children: [
            item("إنشاء حساب", () {
              Get.to(() => const AddAccount(),binding: BindingsBuilder(

                    () => Get.lazyPut(()=>CustomerPlutoEditViewModel()),
              ));
            }),
            // item("معاينة الحسابات", () {
            //   checkPermissionForOperation(Const.roleUserRead, Const.roleViewAccount).then((value) {
            //     if (value) Get.to(() => const AllAccountOLD());
            //   });
            // }),
            item("كشف حساب", () {
              checkPermissionForOperation(Const.roleUserRead, Const.roleViewAccount).then((value) {
                if (value) {
                  Get.find<SearchViewController>().initController();
                  showDialog<String>(
                    context: Get.context!,
                    builder: (BuildContext context) => const AccountOptionDialog(),
                  );
                }
              });
            }),
            item("معاينة الحسابات", () {
              checkPermissionForOperation(Const.roleUserRead, Const.roleViewAccount).then((value) {
                if (value) {
                  Get.to(() => const AllAccount());
                }
              });
            }),
            item("شجرة الحسابات", () {
              checkPermissionForOperation(Const.roleUserRead, Const.roleViewAccount).then((value) {
                if (value) Get.to(() => AccountTreeView());
              });
            }),
            item("سجل استحقاق الشركاء", () {
              checkPermissionForOperation(Const.roleUserRead, Const.roleViewAccount).then((value) {
                if (value) Get.to(() => const AllPartnerDueAccount());
              });

            }),
            item("المستحقات", () {
              checkPermissionForOperation(Const.roleUserRead, Const.roleViewAccount).then((value) {
                if (value) {
                  Get.find<SearchViewController>().initController();
                  showDialog<String>(
                    context: Get.context!,
                    builder: (BuildContext context) => const AccountDueOptionDialog(),
                  );
                }
              });


            }),
          ],
        ),
      ),
    );
  }

  Widget item(text, onTap) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
            )),
      ),
    );
  }
}
