import 'package:ba3_business_solutions/controller/bond/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/bond/entry_bond_view_model.dart';
import 'package:ba3_business_solutions/controller/globle/global_view_model.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/utils/date_picker.dart';
import 'package:ba3_business_solutions/view/bonds/pages/custom_bond_details_view.dart';
import 'package:ba3_business_solutions/view/cheques/pages/add_cheque.dart';
import 'package:ba3_business_solutions/view/invoices/pages/New_Invoice_View.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controller/invoice/Invoice_Pluto_Edit_View_Model.dart';
import '../../../controller/invoice/discount_pluto_edit_view_model.dart';
import '../../../core/constants/app_strings.dart';
import '../../../model/bond/bond_record_model.dart';
import '../../bonds/pages/bond_details_view.dart';

class EntryBondDetailsView extends StatefulWidget {
  EntryBondDetailsView({
    Key? key,
    this.oldId,
  }) : super(key: key);
  final String? oldId;

  @override
  _EntryBondDetailsViewState createState() => _EntryBondDetailsViewState();
}

class _EntryBondDetailsViewState extends State<EntryBondDetailsView> {
  var entryBondController = Get.find<EntryBondViewModel>();
  var globalController = Get.find<GlobalViewModel>();
  var i = 0;
  List<BondRecordModel> record = <BondRecordModel>[];
  var newCodeController = TextEditingController();
  String defualtCode = '';

  @override
  void initState() {
    super.initState();
    initPage();
    entryBondController.lastEntryBondOpened = widget.oldId;
  }

  void initPage() {
    entryBondController.initCodeList();

    entryBondController.tempBondModel =
        entryBondController.allEntryBonds[widget.oldId]!;
    entryBondController.initPage();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EntryBondViewModel>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text("سند قيد"),
            leading: BackButton(),
            actions: [
              SizedBox(
                width: 300,
                child: Row(
                  children: [
                    const Text("تاريخ السند : ", style: TextStyle()),
                    Expanded(
                      child: DatePicker(
                        initDate: (controller.tempBondModel.bondDate ??
                                controller.tempBondModel.invDate ??
                                controller.tempBondModel.cheqDate)
                            .toString(),
                        onSubmit: (_) {},
                      ),
                    ),
                    SizedBox(width: 50),
                  ],
                ),
              ),
              if (controller.allEntryBonds.values
                      .toList()
                      .firstOrNull
                      ?.entryBondId !=
                  controller.tempBondModel.entryBondId)
                TextButton(
                    onPressed: () {
                      controller.firstBond();
                    },
                    child: const Text("الاول"))
              else
                const SizedBox(width: 50),
              if (controller.allEntryBonds.values
                      .toList()
                      .firstOrNull
                      ?.entryBondId !=
                  controller.tempBondModel.entryBondId)
                TextButton(
                    onPressed: () {
                      controller.prevBond();
                    },
                    child: const Text("السابق"))
              else
                const SizedBox(width: 50),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(), color: Colors.white),
                padding: const EdgeInsets.all(5),
                width: 80,
                child: TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onFieldSubmitted: (_) {
                    controller.changeIndexCode(code: _);
                    controller.initPage();
                  },
                  decoration: const InputDecoration.collapsed(hintText: ""),
                  controller: TextEditingController(
                      text: entryBondController.tempBondModel.entryBondCode ??
                          ""),
                ),
              ),
              if (controller.allEntryBonds.values
                      .toList()
                      .lastOrNull
                      ?.entryBondId !=
                  controller.tempBondModel.entryBondId)
                TextButton(
                    onPressed: () {
                      controller.nextBond();
                    },
                    child: const Text("التالي"))
              else
                const SizedBox(width: 55),
              if (controller.allEntryBonds.values
                      .toList()
                      .lastOrNull
                      ?.entryBondId !=
                  controller.tempBondModel.entryBondId)
                TextButton(
                    onPressed: () {
                      controller.lastBond();
                    },
                    child: const Text("الاخير"))
              else
                const SizedBox(width: 55),
              const SizedBox(width: 50),
            ]),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                    stream: controller.allEntryBonds.stream,
                    builder: (context, snapshot) {
                      return GetBuilder<BondViewModel>(builder: (controller) {
                        return SfDataGrid(
                          horizontalScrollPhysics:
                              NeverScrollableScrollPhysics(),
                          verticalScrollPhysics: BouncingScrollPhysics(),
                          source: entryBondController.recordDataSource,
                          allowEditing: false,
                          selectionMode: SelectionMode.singleDeselect,
                          editingGestureType: EditingGestureType.tap,
                          navigationMode: GridNavigationMode.cell,
                          columnWidthMode: ColumnWidthMode.fill,
                          allowSwiping: false,
                          swipeMaxOffset: 200,
                          columns: <GridColumn>[
                            gridColumnItem(
                                label: "الرمز التسلسلي",
                                name: AppStrings.rowBondId),
                            gridColumnItem(
                                label: 'الحساب',
                                name: AppStrings.rowBondAccount),
                            gridColumnItem(
                                label: ' مدين',
                                name: AppStrings.rowBondDebitAmount),
                            gridColumnItem(
                                label: ' دائن',
                                name: AppStrings.rowBondCreditAmount),
                            gridColumnItem(
                                label: "البيان",
                                name: AppStrings.rowBondDescription),
                          ],
                        );
                      });
                    })),
            Row(
              children: [
                Spacer(),
                Text("المجموع"),
                SizedBox(width: 30),
                GetBuilder<BondViewModel>(builder: (controller) {
                  double _ = entryBondController.tempBondModel.entryBondRecord
                          ?.map(
                            (e) => e.bondRecDebitAmount ?? 0,
                          )
                          .reduce(
                            (value, element) => value + element,
                          ) ??
                      0;
                  return Container(
                      color: double.parse(null ?? "0") == 0
                          ? Colors.green
                          : Colors.red,
                      padding: EdgeInsets.all(8),
                      child: Text(_.toStringAsFixed(2)));
                }),
                SizedBox(width: 20),
                Builder(builder: (context) {
                  double _ = entryBondController.tempBondModel.entryBondRecord
                          ?.map(
                            (e) => e.bondRecCreditAmount ?? 0,
                          )
                          .reduce(
                            (value, element) => value + element,
                          ) ??
                      0;
                  return Container(
                      color: double.parse(null ?? "0") == 0
                          ? Colors.green
                          : Colors.red,
                      padding: EdgeInsets.all(8),
                      child: Text(_.toStringAsFixed(2)));
                }),
                SizedBox(width: 50),
              ],
            ),
            if (controller.tempBondModel.invId != null ||
                controller.tempBondModel.bondId != null)
              AppButton(
                  title: "الأصل",
                  onPressed: () {
                    if (controller.tempBondModel.globalType ==
                        AppConstants.globalTypeInvoice) {
                      Get.to(
                        () => InvoiceView(
                          billId: controller.tempBondModel.invId!,
                          patternId: controller.tempBondModel.patternId!,
                        ),
                        binding: BindingsBuilder(() {
                          Get.lazyPut(() => InvoicePlutoViewModel());
                          Get.lazyPut(() => DiscountPlutoViewModel());
                        }),
                      );
                    } else if (controller.tempBondModel.globalType ==
                        AppConstants.globalTypeCheque) {
                      Get.to(() => AddCheque(
                            modelKey: controller.tempBondModel.cheqId,
                          ));
                    } else if (controller.tempBondModel.bondType ==
                            AppConstants.bondTypeDaily ||
                        controller.tempBondModel.bondType ==
                            AppConstants.bondTypeStart) {
                      Get.to(() => BondDetailsView(
                            oldId: controller.tempBondModel.bondId,
                            bondType: controller.tempBondModel.bondType!,
                          ));
                    } else if (controller.tempBondModel.bondType ==
                            AppConstants.bondTypeDebit ||
                        controller.tempBondModel.bondType ==
                            AppConstants.bondTypeCredit) {
                      Get.to(() => CustomBondDetailsView(
                            oldId: controller.tempBondModel.bondId,
                            isDebit: controller.tempBondModel.bondType ==
                                AppConstants.bondTypeDebit,
                          ));
                    }
                  },
                  iconData: CupertinoIcons.share),
            const SizedBox(height: 50),
          ],
        ),
      );
    });
  }

  GridColumn gridColumnItem({required label, name}) {
    return GridColumn(
        allowEditing: name == AppStrings.rowBondId ? false : true,
        columnName: name,
        label: Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              label.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.white),
            )));
  }
}
