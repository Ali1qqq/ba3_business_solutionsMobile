import 'package:ba3_business_solutions/view/dashboard/widget/dashboard_chart_widget1.dart';
import 'package:ba3_business_solutions/view/invoices/pages/New_Invoice_View.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/account/account_view_model.dart';
import '../../../controller/invoice/Search_View_Controller.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../core/shared/dialogs/Account_Option_Dialog.dart';
import '../../../core/utils/hive.dart';
import '../../../model/account/account_model.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          width: Get.width / 4,
          height: Get.width / 4,
          child: GetBuilder<AccountViewModel>(builder: (accountController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "الحسابات الرئيسية",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        AppButton(
                            title: "تحديث",

                            ///this for pay all check

                            onPressed: () {
                              // print(HiveDataBase.globalModelBox.toMap().entries.where((element) => element.value.bondId=="bon1726453481733905",).first.key);
                              accountController.setBalance(HiveDataBase
                                  .mainAccountModelBox.values
                                  .toList());
                              accountController.update();
                              //  HiveDataBase.accountModelBox.deleteFromDisk();
                              //  HiveDataBase.accountCustomerBox.deleteFromDisk();
                              //  HiveDataBase.globalModelBox.deleteFromDisk();
                              //  HiveDataBase.productModelBox.deleteFromDisk();

                              // print();
                              // print(getAccountIdFromText("الصندوق"));
                              // HiveDataBase.accountModelBox.delete("acc1725319300175064");
                            },
                            iconData: Icons.add),
                        const SizedBox(
                          width: 20,
                        ),
                        AppButton(
                            title: "إضافة",

                            ///this for pay all check
                            /*      onPressed: ()async{
                              List<dynamic> global=HiveDataBase.globalModelBox.toMap().entries.where((element)=> element.value.globalType==Const.globalTypeCheque).map((e) => e.value).toList();
                              print(global.length);
                              print(global);
                              // print(HiveDataBase.globalModelBox.values.last.toFullJson());

                              // HiveDataBase.globalModelBox.deleteAll(global);
                              // print(global.where((element) => element.cheqStatus==Const.chequeStatusPaid,).length);
                              for(GlobalModel element in global){

                                if(element.cheqStatus==Const.chequeStatusPaid){

                                  String des = element.cheqStatus != Const.chequeStatusNotPaid?"سند دفع شيك رقم ${element.cheqName}":"سند ارجاع قيمة شيك برقم ${element.cheqName}";
                                  List<BondRecordModel> bondRecord = [];
                                  List<EntryBondRecordModel> entryBondRecord = [];

                                  if (element.cheqStatus==Const.chequeStatusPaid) {

                                    bondRecord.add(BondRecordModel("00", 0, double.tryParse(element.cheqAllAmount!) ?? 0, getAccountIdFromText("اوراق الدفع"), des));
                                    bondRecord.add(BondRecordModel("01", double.tryParse(element.cheqAllAmount!) ?? 0, 0, getAccountIdFromText("المصرف"), des));
                                  }

                                  // bondRecord.add(BondRecordModel("03", controller.invoiceForSearch!.invTotal! - double.parse(controller.totalPaidFromPartner.text), 0, patternController.patternModel[controller.invoiceForSearch!.patternId]!.patSecondary!, des));

                                  for (var element in bondRecord) {
                                    entryBondRecord.add(EntryBondRecordModel.fromJson(element.toJson()));
                                  }
                                  GlobalViewModel globalViewModel = Get.find<GlobalViewModel>();
                                  String entryBond=generateId(RecordType.entryBond);
                                  await Future.delayed(Durations.short1);
                                  element.entryBondId=entryBond;
                                  await     HiveDataBase.globalModelBox.put(element.cheqId, element);
                                  await globalViewModel.addGlobalBond(
                                    GlobalModel(
                                      bondRecord: bondRecord,
                                      entryBondId: entryBond,
                                      bondCode: Get.find<BondViewModel>().getNextBondCode(type:Const.bondTypeDebit ),
                                      entryBondRecord: entryBondRecord,
                                      bondDescription: des,
                                      bondType: Const.bondTypeDebit,
                                      bondTotal: "0",
                                    ),
                                  );
                                }
                              }
                      },*/
                            onPressed: () async {
                              TextEditingController nameController =
                                  TextEditingController();
                              List<AccountModel> accountList = [];
                              await Get.defaultDialog(
                                  title: "اكتب اسم الحساب",
                                  content: StatefulBuilder(
                                      builder: (context, setstate) {
                                    return SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).width / 4,
                                      width:
                                          MediaQuery.sizeOf(context).width / 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              child: TextFormField(
                                                textDirection:
                                                    TextDirection.rtl,
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        "اكتب اسم الحساب او رقمه",
                                                    hintTextDirection:
                                                        TextDirection.rtl),
                                                onChanged: (_) {
                                                  accountList =
                                                      getAccountModelsFromName(
                                                          _);
                                                  // print(accountList);
                                                  setstate(() {});
                                                },
                                                controller: nameController,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Expanded(
                                                child: accountList.isEmpty
                                                    ? const Center(
                                                        child: Text(
                                                            "لا يوجد نتائج"),
                                                      )
                                                    : ListView.builder(
                                                        itemCount:
                                                            accountList.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          AccountModel model =
                                                              accountList[
                                                                  index];
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: InkWell(
                                                                onTap: () {
                                                                  HiveDataBase
                                                                      .mainAccountModelBox
                                                                      .put(
                                                                          model
                                                                              .accId,
                                                                          model);
                                                                  Get.back();
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    "${model.accName}   ${model.accCode}",
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl,
                                                                  ),
                                                                )),
                                                          );
                                                        },
                                                      ))
                                          ],
                                        ),
                                      ),
                                    );
                                  }));
                              accountController.update();

                              print(accountController.accountList.length);
                            },
                            iconData: Icons.add),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: HiveDataBase.mainAccountModelBox.values
                          .toList()
                          .length,
                      itemBuilder: (context, index) {
                        AccountModel model = HiveDataBase
                            .mainAccountModelBox.values
                            .toList()[index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onSecondaryTapDown: (details) {
                              showContextMenu(context, details.globalPosition,
                                  model.accId!, accountController);
                            },
                            onLongPressStart: (details) {
                              showContextMenu(context, details.globalPosition,
                                  model.accId!, accountController);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                    width: Get.width / 4,
                                    child: Text(
                                      model.accName.toString(),
                                      style: const TextStyle(fontSize: 22),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                SizedBox(
                                  width: Get.width / 4,
                                  child: Text(
                                    formatDecimalNumberWithCommas(
                                        model.finalBalance ?? 0),
                                    // model.accId!,
                                    style: const TextStyle(fontSize: 22),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
                  ],
                ),
              ),
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(25),
              child: DashboardChartWidget1()),
        ),
      ],
    );
  }

  void showContextMenu(BuildContext parentContext, Offset tapPosition,
      String id, AccountViewModel accountController) {
    showMenu(
      context: parentContext,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx + 1.0,
        tapPosition.dy * 1.0,
      ),
      items: [
        PopupMenuItem(
          onTap: () {
            Get.find<SearchViewController>()
                .initController(accountForSearch: getAccountNameFromId(id));
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => const AccountOptionDialog(),
            );
          },
          value: 'details',
          child: ListTile(
            leading: Icon(
              Icons.search,
              color: Colors.blue.shade300,
            ),
            title: Text('عرض الحركات'),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          onTap: () {
            HiveDataBase.mainAccountModelBox.delete(id);
            accountController.update();
          },
          child: ListTile(
            leading: Icon(
              Icons.remove_circle_outline,
              color: Colors.red.shade700,
            ),
            title: Text('حذف'),
          ),
        ),
      ],
    );
  }
}
