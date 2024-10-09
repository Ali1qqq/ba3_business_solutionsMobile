import 'package:ba3_business_solutions/controller/account/account_view_model.dart';
import 'package:ba3_business_solutions/controller/invoice/invoice_view_model.dart';
import 'package:ba3_business_solutions/model/account/account_record_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../model/global/global_model.dart';

class AllDueView extends StatelessWidget {
  AllDueView({super.key});

  final List<({AccountRecordModel accountRecordModel, GlobalModel globalModel})>
      allList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: GetBuilder<AccountViewModel>(builder: (controller) {
          allList.clear();
          InvoiceViewModel invoiceViewModel = Get.find<InvoiceViewModel>();
          List<GlobalModel> allBuyInv =
              invoiceViewModel.invoiceModel.values.where(
            (element) {
              return element.invType == AppConstants.invoiceTypeBuy &&
                  element.invPayType == AppConstants.invPayTypeDue;
            },
          ).toList();
          for (var element in allBuyInv) {
            if (element.invPrimaryAccount != '') {
              allList.add((
                globalModel: element,
                accountRecordModel: controller
                    .accountList[element.invPrimaryAccount]!.accRecord
                    .firstWhere(
                  (e) => e.id == element.entryBondId,
                ),
              ));
            }
            // allList.add((
            //   accountRecordModel: controller.accountList[element.invSecondaryAccount]!.accRecord.firstWhere(
            //     (e) => e.id == element.bondId,
            //   ),
            //   globalModel: element
            // ));
          }
          // controller.accountList.forEach((key, value) {
          //   if(value.accRecord.isNotEmpty){
          //     value.accRecord.forEach((element) {
          //       if(element.accountRecordType!.contains("pat")){
          //         //if(allList.where((e) => e.id ==element.id ,).isEmpty){
          //           allList.add(element);
          //
          //         //}
          //       }
          //     },);
          //   }
          // },);
          return allList.isEmpty
              ? Center(
                  child: Text("لا يوجد فواتير"),
                )
              : ListView.builder(
                  itemCount: allList.length,
                  itemBuilder: (context, index) {
                    ({
                      AccountRecordModel accountRecordModel,
                      GlobalModel globalModel
                    }) model = allList[index];
                    print(model.accountRecordModel.toJson());
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: model.accountRecordModel.isPaidStatus ==
                                    AppConstants.paidStatusFullUsed
                                ? Colors.green.withOpacity(0.5)
                                : model.accountRecordModel.isPaidStatus ==
                                        AppConstants.paidStatusSemiUsed
                                    ? Colors.orange.withOpacity(0.5)
                                    : Colors.red.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                  width: 100,
                                  child: Text(getGlobalTypeFromEnum(model
                                      .accountRecordModel.accountRecordType!))),
                              SizedBox(
                                  width: 100,
                                  child: Text(getAccountNameFromId(
                                      model.globalModel.invPrimaryAccount))),
                              SizedBox(
                                  width: 100,
                                  child: Text(
                                      model.globalModel.invTotal.toString())),
                              SizedBox(
                                  width: 200,
                                  child: Text(getAccountPaidStatusFromEnum(
                                      model.accountRecordModel.isPaidStatus
                                          .toString(),
                                      true))),
                              SizedBox(
                                  width: 100,
                                  child: Text(
                                      "منذ ${DateTime.now().difference(DateTime.parse(model.globalModel.invDate!)).inDays} ايام ")),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        }));
  }
}
