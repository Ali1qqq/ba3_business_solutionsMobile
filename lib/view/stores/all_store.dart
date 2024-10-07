import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/view/stores/store_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../Const/const.dart';
import '../patterns/all_pattern.dart';

class AllStore extends StatelessWidget {
  AllStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl ,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("المستودعات"),
          actions: [
            // ElevatedButton(
            //     onPressed: () {
            //       Get.to(AddStore());
            //     },
            //     child: Text("add"))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: GetBuilder<StoreViewModel>(builder: (storeController) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SfDataGrid(
                    horizontalScrollPhysics: NeverScrollableScrollPhysics(),
                    verticalScrollPhysics: BouncingScrollPhysics(),
                    controller: storeController.storeDataGridController,
                    onCellTap: (details) {
                      if (details.rowColumnIndex.rowIndex != 0) {
                        var stId = (storeController.recordViewDataSource?.dataGridRows[details.rowColumnIndex.rowIndex - 1].getCells().firstWhere((element) => element.columnName == Const.stId).value);

                        Get.to(()=>StoreDetails(
                          oldKey: stId,
                        ));
                      }
                    },
                    columns: <GridColumn>[
                      GridColumn(
                          visible: false,
                          allowEditing: false,
                          columnName: "stId",
                          label: const Text('ID'
                          )),
                      gridColumnItem(
                        label: "الرمز",
                        name: Const.stCode,
                      ),
                      gridColumnItem(label: "الاسم", name: Const.stName),
                    ],
                    source: storeController.recordViewDataSource!,
                    allowEditing: false,
                    selectionMode: SelectionMode.none,
                    editingGestureType: EditingGestureType.tap,
                    navigationMode: GridNavigationMode.cell,
                    columnWidthMode: ColumnWidthMode.fill,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
