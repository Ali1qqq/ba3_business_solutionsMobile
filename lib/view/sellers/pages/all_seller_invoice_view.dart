import 'package:ba3_business_solutions/controller/seller/sellers_view_model.dart';
import 'package:ba3_business_solutions/view/sellers/pages/add_seller.dart';
import 'package:ba3_business_solutions/view/sellers/pages/seller_targets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../controller/invoice/discount_pluto_edit_view_model.dart';
import '../../../controller/invoice/Invoice_Pluto_Edit_View_Model.dart';
import '../../../core/utils/date_range_picker.dart';
import '../../invoices/pages/New_Invoice_View.dart';

class AllSellerInvoice extends StatelessWidget {
  final String? oldKey;

  AllSellerInvoice({super.key, this.oldKey});

  List<DateTime>? dateRange = [];

  @override
  Widget build(BuildContext context) {
    SellersViewModel controller = Get.find<SellersViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "سجل مبيعات: ${controller.allSellers[oldKey]?.sellerName ?? ""}"),
        actions: [
          Text("فلتر"),
          SizedBox(
            width: 20,
          ),
          DateRangePicker(
            onSubmit: (_) {
              dateRange = _;
              controller.filter(_, oldKey);
            },
          ),
          SizedBox(
            width: 60,
          ),
          ElevatedButton(
              onPressed: () {
                dateRange = null;
                controller.initSellerPage(oldKey);
                controller.update();
              },
              child: Text("افراغ الفلتر")),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(() =>
                    AddSeller(
                      oldKey: oldKey,
                    ));
              },
              child: Text("تعديل")),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(() =>
                    SellerTarget(
                      sellerId: oldKey!,
                    ));
              },
              child: Text("التارغيت")),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: controller.allSellers.isEmpty
          ? CircularProgressIndicator()
          :
      // String model = controller.allAccounts.keys.toList()[index];
      // AccountModel accountModel=controller.accountListMyId[model]!;
      StreamBuilder(
          stream: controller.allSellers.stream,
          builder: (context, snapshot) {
            return GetBuilder<SellersViewModel>(builder: (controller) {
              if (dateRange == null) controller.initSellerPage(oldKey);
              return SfDataGrid(
                onCellTap: (DataGridCellTapDetails details) {
                  if (details.rowColumnIndex.rowIndex != 0) {
                    final rowIndex = details.rowColumnIndex.rowIndex - 1;
                    var rowData =
                    controller.recordViewDataSource[rowIndex];
                    String model = rowData.getCells()[0].value;
                    print('Tapped Row Data: $model');
                    Get.to(
                          () =>
                          InvoiceView(
                            billId: model,
                            patternId: '',
                          ),
                      binding: BindingsBuilder(() {
                        Get.lazyPut(() => InvoicePlutoViewModel());
                        Get.lazyPut(() => DiscountPlutoViewModel());
                      }),
                    );
                    // logger(
                    //     newData: ChequeModel(
                    //       cheqId: model,
                    //     ),
                    //     transfersType: TransfersType.read);
                  }
                },
                columns: <GridColumn>[
                  GridColumn(
                      visible: false,
                      allowEditing: false,
                      columnName: AppConstants.rowSellerAllInvoiceInvId,
                      label: const Text('ID')),
                  // GridColumnItem(label: "الرمز التسلسلي", name: Const.rowSellerAllInvoiceInvId),
                  GridColumnItem(
                      label: "قيمة الفاتورة",
                      name: AppConstants.rowSellerAllInvoiceAmount),
                  GridColumnItem(
                      label: "تاريخ الفاتورة",
                      name: AppConstants.rowSellerAllInvoiceAmount),
                ],
                source: controller.recordViewDataSource,
                allowEditing: false,
                selectionMode: SelectionMode.none,
                editingGestureType: EditingGestureType.tap,
                navigationMode: GridNavigationMode.cell,
                columnWidthMode: ColumnWidthMode.fill,
              );
            });
          }),

    );
  }
}

GridColumn GridColumnItem({required label, name}) {
  return GridColumn(
      allowEditing: false,
      columnName: name,
      label: Container(
          color: Colors.blue.shade700,
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Text(
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            label.toString(),
          )));
}
