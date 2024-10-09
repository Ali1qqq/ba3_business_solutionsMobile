import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/controller/account/account_view_model.dart';
import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/helper/functions/functions.dart';

class AllChequesViewDataGridSource extends DataGridSource {
  final RxMap<String, GlobalModel> cheqMap;

  AllChequesViewDataGridSource(
    this.cheqMap,
  );

  @override
  List<DataGridRow> get rows => cheqMap.entries.where(
        (element) {
          return element.value.cheqStatus == AppConstants.chequeStatusNotPaid;
        },
      ).map<DataGridRow>((entry) {
        String cheqId = entry.key;
        GlobalModel cheque = entry.value;
        return DataGridRow(cells: [
          DataGridCell<String>(
              columnName: AppConstants.rowViewCheqId, value: cheqId),
          DataGridCell<String>(
              columnName: AppConstants.rowViewChequeStatus,
              value: getChequeStatusfromEnum(cheque.cheqStatus ?? "")),
          DataGridCell<String>(
              columnName: AppConstants.rowViewChequePrimeryAccount,
              value: getAccountNameFromId(cheque.cheqPrimeryAccount)),
          DataGridCell<String>(
              columnName: AppConstants.rowViewChequeSecoundryAccount,
              value: getAccountNameFromId(cheque.cheqSecoundryAccount)),
          DataGridCell<String>(
              columnName: AppConstants.rowViewChequeAllAmount,
              value: cheque.cheqAllAmount),
        ]);
      }).toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getRowBackgroundColor() {
      final int index = effectiveRows.indexOf(row);
      if (index % 2 == 0) {
        return Colors.white;
      }

      return Colors.blue.withOpacity(0.5);
    }

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        color: getRowBackgroundColor(),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
