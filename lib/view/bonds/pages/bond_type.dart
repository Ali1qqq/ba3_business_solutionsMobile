import 'package:ba3_business_solutions/controller/bond/bond_record_pluto_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/core/shared/dialogs/BondDebitOption.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import 'bond_details_view.dart';

class BondType extends StatefulWidget {
  const BondType({super.key});

  @override
  State<BondType> createState() => _BondTypeState();
}

class _BondTypeState extends State<BondType> {
  PatternViewModel patternController = Get.find<PatternViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("السندات"),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          Item("سند يومية", () {
            Get.to(
              () => const BondDetailsView(
                bondType: AppConstants.bondTypeDaily,
              ),
              binding: BindingsBuilder(() {
                Get.lazyPut(
                    () => BondRecordPlutoViewModel(AppConstants.bondTypeDaily));
              }),
            );
          }),
          Item("سند دفع", () {
            Get.to(
              () => const BondDetailsView(
                bondType: AppConstants.bondTypeDebit,
              ),
              binding: BindingsBuilder(() {
                Get.lazyPut(
                    () => BondRecordPlutoViewModel(AppConstants.bondTypeDebit));
              }),
            );
          }),
          Item("سند قبض", () {
            Get.to(
              () => const BondDetailsView(
                bondType: AppConstants.bondTypeCredit,
              ),
              binding: BindingsBuilder(() {
                Get.lazyPut(() =>
                    BondRecordPlutoViewModel(AppConstants.bondTypeCredit));
              }),
            );
          }),
          Item("سند دفع اجل", () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => BondDebitDialog(),
            );
          }),
          Item("قيد افتتاحي", () {
            Get.to(
              () => const BondDetailsView(
                bondType: AppConstants.bondTypeStart,
              ),
              binding: BindingsBuilder(() {
                Get.lazyPut(
                    () => BondRecordPlutoViewModel(AppConstants.bondTypeStart));
              }),
            );
          }),
/*            if (checkPermission(Const.roleUserAdmin, Const.roleViewInvoice))
              Item("عرض جميع السندات", () {
                checkPermissionForOperation(Const.roleUserRead, Const.roleViewBond).then((value) {
                  if (value) Get.to(() => const AllBonds());
                });
              }),*/

          /*           Item("عرض سندات القيد ", () {
              checkPermissionForOperation(Const.roleUserRead, Const.roleViewBond).then((value) {
                if (value) Get.to(() => const AllEntryBonds());
              });
            }),*/
        ],
      ),
    );
  }

  Widget Item(text, onTap) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Text(
              text,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ))),
      ),
    );
  }
}
