import 'package:ba3_business_solutions/controller/invoice_view_model.dart';
import 'package:ba3_business_solutions/view/invoices/invoice_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../accounts/acconts_view.dart';

class AllInvoice extends StatelessWidget {
  const AllInvoice({super.key});

  @override
  Widget build(BuildContext context) {
    InvoiceViewModel controller = Get.find<InvoiceViewModel>();
    controller.getInvCode();
    return GetBuilder<InvoiceViewModel>(
        builder: (cont) => Scaffold(
              appBar: AppBar(
                title: const Text("Invoices"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        // Get.to(InvoiceView(billId: "1"));
                        controller.viewPattern();
                      },
                      child: const Text("Create"))
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
                      onCellTap: (DataGridCellTapDetails details) {
                        final rowIndex = details.rowColumnIndex.rowIndex - 1;
                        var rowData = controller.invoiceAllDataGridSource[rowIndex];
                        String model = rowData.getCells()[0].value;
                        print('Tapped Row Data: $model');
                        Get.to(() => InvoiceView(
                              billId: model,
                              patternId: "",
                            ));
                      },
                      columns: <GridColumn>[
                        GridColumnItem(
                          label: "id",
                          name: "Const.rowViewAccountId",
                        ),
                        GridColumnItem(label: 'المدين', name: "Const.rowViewAccountId"),
                        GridColumnItem(label: 'الدائن', name: "Const.rowViewAccountName"),
                        GridColumnItem(label: 'قيمة الفاتورة', name: "Const.rowAccountBalance"),
                        GridColumnItem(label: 'عدد المواد', name: "Const.rowViewAccountLength"),
                        GridColumnItem(label: 'نوع الفاتورة', name: "Const.rowViewAccountLength"),
                        GridColumnItem(label: 'رقم الفاتورة', name: "Const.rowViewAccountLength"),
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
