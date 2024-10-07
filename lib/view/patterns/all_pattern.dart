import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/view/patterns/pattern_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../Widgets/new_Pluto.dart';
class AllPattern extends StatelessWidget {
  const AllPattern({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatternViewModel>(builder: (controller) {
      return CustomPlutoGridWithAppBar(
        title: "أنماط البيع",
        onLoaded: (e) {},
        onSelected: (p0) {

          Get.to(PatternDetails(
            oldKey: p0.row?.cells["id"]?.value,
          ));

          /*   Get.to(() => InvoiceView(
                billId: p0.row?.cells["الرقم التسلسلي"]?.value,
                patternId: "",
              ));*/
        },
        modelList:controller.patternModel.values.toList(),
      );
    });
/*    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("أنماط البيع"),

        ),
        body: GetBuilder<PatternViewModel>(
          builder: (patternController) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Expanded(
                    child: SfDataGrid(
                      onCellTap: (details) {
                        if (details.rowColumnIndex.rowIndex != 0) {
                          var stId = (patternController.recordViewDataSource?.dataGridRows[details.rowColumnIndex.rowIndex - 1].getCells().firstWhere((element) => element.columnName == Const.patId).value);
                          Get.to(PatternDetails(
                            oldKey: stId,
                          ));
                        }
                        // patternController.selectPattern(details);
                        // // print(details.rowColumnIndex.toString());
                      },
                      columns: <GridColumn>[
                        GridColumn(
                            visible: false,
                            allowEditing: false,
                            columnName:  Const.patId,
                            label: const Text('ID'
                            )),
                        // GridColumnItem(label: "ID", name: Const.patId),
                        gridColumnItem(label: "الرمز", name: Const.patCode),
                        //GridColumnItem(label: Const.patPrimary, name: Const.patPrimary),
                        gridColumnItem(label: "الاسم", name: Const.patName),
                        gridColumnItem(label: "النوع", name: Const.patType),
                      ],
                      source: patternController.recordViewDataSource!,
                      allowEditing: false,
                      selectionMode: SelectionMode.none,
                      editingGestureType: EditingGestureType.tap,
                      navigationMode: GridNavigationMode.cell,
                      columnWidthMode: ColumnWidthMode.fill,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );*/
  }
}
GridColumn gridColumnItem({required label, name}) {
  return GridColumn(
      allowEditing: false,
      columnName: name,
      label: Container(
          color: Colors.blue.shade800,
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Text(
            label.toString(),
            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
          )));
}