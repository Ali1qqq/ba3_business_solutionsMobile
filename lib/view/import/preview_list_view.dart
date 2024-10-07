import 'package:ba3_business_solutions/view/import/import_configuration_view.dart';
import 'package:ba3_business_solutions/view/import/widget/preview_view_data_grid_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PreviewView extends StatefulWidget {
  final List<List<String>> productList;
  final List<String> rows;

  PreviewView({super.key, required this.productList, required this.rows});

  @override
  State<PreviewView> createState() => _PreviewViewState();
}

class _PreviewViewState extends State<PreviewView> {
  List<DateTime>? dateRange;
  PreViewViewDataGridSource? recordViewDataSource;

  @override
  void initState() {
    super.initState();
    recordViewDataSource = PreViewViewDataGridSource(productList: widget.productList, rows: widget.rows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            ElevatedButton(
                onPressed: () {
                  List<List<String>> data = recordViewDataSource!.dataGridRows.map((e) => e.getCells().map((e) => e.value.toString()).toList()).toList();
                  Get.to(() => ImportConfigurationView(
                        rows: widget.rows,
                        productList: data,
                      ));
                },
                child: const Text("next"))
          ],
        ),
        body: widget.productList.isEmpty
            ?  const Center(
                child: Text("no data"),
              )
            : SfDataGrid(
                // onCellTap: (DataGridCellTapDetails details) {
                //   if (details.rowColumnIndex.rowIndex != 0) {
                //     final rowIndex = details.rowColumnIndex.rowIndex - 1;
                //     var rowData = recordViewDataSource[rowIndex];
                //     String model = rowData.getCells()[0].value;
                //     print('Tapped Row Data: $model');
                //     seeDetails(model);
                //     // logger(
                //     //     newData: ChequeModel(
                //     //       cheqId: model,
                //     //     ),
                //     //     transfersType: TransfersType.read);
                //   }
                // },
                columns: List.generate(widget.rows.length, (index) => GridColumnItem(label: widget.rows[index], name: widget.rows[index])),
                // columns: <GridColumn>[
                //   GridColumnItem(label: "الاسم", name: Const.rowImportName),
                //   GridColumnItem(label: "السعر", name: Const.rowImportPrice),
                //   GridColumnItem(label: "الباركودات", name: Const.rowImportBarcode),
                //   GridColumnItem(label: "رمز المادة", name: Const.rowImportCode),
                //   GridColumnItem(label: "رمز المجموعة", name: Const.rowImportGroupCode),
                //   GridColumnItem(label: "بخضع للضريبة", name: Const.rowImportHasVat),
                // ],
                source: recordViewDataSource!,
                allowEditing: true,
                rowHeight: 75,
                headerRowHeight: 60,

                selectionMode: SelectionMode.single,
                editingGestureType: EditingGestureType.tap,
                navigationMode: GridNavigationMode.cell,
                columnWidthMode: ColumnWidthMode.fill,
              ));
  }
}

GridColumn GridColumnItem({required label, name}) {
  return GridColumn(
      allowEditing: true,
      columnName: name,
      label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Text(
            label.toString(),
          )));
}
