import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/entry_bond_view_model.dart';
import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../model/global_model.dart';
import '../../utils/logger.dart';
import '../widget/filtering_data_grid.dart';
import 'entry_bond_details_view.dart';

class AllEntryBonds extends StatelessWidget {
  const AllEntryBonds({super.key});

  @override
  Widget build(BuildContext context) {
    EntryBondViewModel entryBondViewModel = Get.find<EntryBondViewModel>();
    RxMap<String, GlobalModel> data = entryBondViewModel.allEntryBonds;
    return Scaffold(
      body: FilteringDataGrid<GlobalModel>(
        title: "سندات القيد",
        constructor: GlobalModel(),
        dataGridSource: data,
        globalType: Const.globalTypeBond,
        onCellTap: (index, id, init) {
          GlobalModel model = data[id]!;
          logger(newData: model, transfersType: TransfersType.read);
          Get.to(() => EntryBondDetailsView(
                oldId: model.entryBondId,
              ));
        },
        init: () async {
          IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
          isolateViewModel.init();
          final a = await compute<({List<GlobalModel> a, IsolateViewModel isolateViewModel}), List<DataGridRow>>((message) {
            Get.put(message.isolateViewModel);
            List<DataGridRow> dataGridRow = message.a.map<DataGridRow>((order) => DataGridRow(cells: [
                      DataGridCell(columnName: "entryBondId", value: order.toJson()['entryBondId']),
                      ...order.toEntryBondAR().entries.map((mapEntry) {
                            // if (int.tryParse(mapEntry.value.toString()) != null) {
                            //   return DataGridCell<int>(columnName: mapEntry.key, value: int.parse(mapEntry.value.toString()));
                            // } else if (double.tryParse(mapEntry.value.toString()) != null) {
                            //   return DataGridCell<double>(columnName: mapEntry.key, value: double.parse(mapEntry.value.toString()));
                            // }
                            // else if(mapEntry.key == "bondDate"){
                            //   int day = int.parse(mapEntry.value.toString().split("-")[2]);
                            //   int month =  int.parse(mapEntry.value.toString().split("-")[1]);
                            //   int year =  int.parse(mapEntry.value.toString().split("-")[0]);
                            //   return DataGridCell<DateTime>(columnName: mapEntry.key, value: DateTime(year,month,day));
                            // }
                            // else{
                            return DataGridCell<String>(columnName: mapEntry.key, value: (mapEntry.value ?? "-").toString());
                            // }
                          })
                          .cast<DataGridCell<dynamic>>()
                          .toList()
                    ]))
                .toList();
            return dataGridRow;
          }, (a: data.values.toList(), isolateViewModel: isolateViewModel));
          InfoDataGridSource infoDataGridSource = InfoDataGridSource();
          infoDataGridSource.dataGridRows = a;
          return infoDataGridSource;
        },
      ),
    );
  }
}
