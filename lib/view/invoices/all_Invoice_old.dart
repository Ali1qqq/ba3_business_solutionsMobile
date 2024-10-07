/*
import 'package:ba3_business_solutions/controller/invoice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../Widgets/Discount_Pluto_Edit_View_Model.dart';
import '../../Widgets/Invoice_Pluto_Edit_View_Model.dart';
import '../accounts/acconts_view_old.dart';
import 'New_Invoice_View.dart';

class AllInvoiceOLD extends StatelessWidget {
  const AllInvoiceOLD({super.key});

  @override
  Widget build(BuildContext context) {
    InvoiceViewModel controller = Get.find<InvoiceViewModel>();
    controller.getInvCode();
    return GetBuilder<InvoiceViewModel>(
        builder: (cont) => Scaffold(
              appBar: AppBar(
                title: const Text("جميع الفواتير"),
                leading: SizedBox(),
                actions: [
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: BackButton()),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       // Get.to(InvoiceView(billId: "1"));
                  //       // controller.viewPattern();
                  //     },
                  //     child: const Text("Create"))
                ],
              ),
              body: controller.invoiceModel.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 400, width: 400, child: Image.network("https://cdn.iconscout.com/icon/premium/png-512-thumb/no-file-search-4023431-3325856.png?f=webp&w=512")),
                          const Text(
                            "No Invoices data yet",
                            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    )
                  : SfDataGrid(
                      horizontalScrollPhysics: NeverScrollableScrollPhysics(),
                      verticalScrollPhysics: BouncingScrollPhysics(),
                      onCellTap: (DataGridCellTapDetails details) {
                        final rowIndex = details.rowColumnIndex.rowIndex - 1;
                        var rowData = controller.invoiceAllDataGridSource[rowIndex];
                        String model = rowData.getCells()[0].value;
                        print('Tapped Row Data: $model');
                        Get.to(() => InvoiceView(
                              billId: model,
                              patternId: "",
                            )  ,  binding: BindingsBuilder(() {
                          Get.lazyPut(() => InvoicePlutoViewModel());
                          Get.lazyPut(() => DiscountPlutoViewModel());
                        }),);
                      },
                      columns: <GridColumn>[
                        GridColumn(
                          visible: false,
                            allowEditing: false,
                            columnName: "Const.rowViewAccountId",
                            label: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(25)),
                                color: Colors.grey,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'ID',
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                        gridColumnItem(label: 'المدين', name: "Const.rowViewAccountId"),
                        gridColumnItem(label: 'الدائن', name: "Const.rowViewAccountName"),
                        gridColumnItem(label: 'قيمة الفاتورة', name: "Const.rowAccountBalance"),
                      //  GridColumnItem(label: 'عدد المواد', name: "Const.rowViewAccountLength"),
                        gridColumnItem(label: 'نوع الفاتورة', name: "Const.rowViewAccountLength"),
                        gridColumnItem(label: 'رقم الفاتورة', name: "Const.rowViewAccountLength"),
                      ],
                      source: controller.invoiceAllDataGridSource,
                      allowEditing: false,
                      selectionMode: SelectionMode.none,
                      editingGestureType: EditingGestureType.tap,
                      navigationMode: GridNavigationMode.cell,
                      columnWidthMode: ColumnWidthMode.fill,
                    ),
            ));
  }
}
*/
