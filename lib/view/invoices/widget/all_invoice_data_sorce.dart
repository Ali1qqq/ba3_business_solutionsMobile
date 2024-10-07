import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../model/global_model.dart';

class allInvoiceDataGridSource extends DataGridSource {
  Map<String, GlobalModel> invoiceModle;

  allInvoiceDataGridSource(this.invoiceModle);

  @override
  List<DataGridRow> get rows => invoiceModle.entries.map<DataGridRow>((entry) {
        String invId = entry.key;
        var invoice = entry.value;
        return DataGridRow(cells: [
          DataGridCell<String>(columnName: 'invId', value: invId),
          DataGridCell<String>(columnName: 'invoice.invPrimaryAccount', value: getAccountNameFromId(invoice.invPrimaryAccount)),
          DataGridCell<String>(columnName: 'invoice.invSecondaryAccount', value: getAccountNameFromId(invoice.invSecondaryAccount)),
          DataGridCell<String>(columnName: 'invoice.invTotal', value: invoice.invTotal.toString()),
          //DataGridCell<String>(columnName: 'invoice.invRecords', value: invoice.invRecords!.length.toString()),
          DataGridCell<String>(columnName: 'invoice.invRecords', value: getPatModelFromPatternId(invoice.patternId.toString()).patName),
          DataGridCell<String>(columnName: 'invoice.invRecords', value: invoice.invCode.toString()),
        ]);
      }).toList();

  get dataGridRows => rows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(dataGridCell.value.toString(),style: TextStyle(fontSize: 22),),
      );
    }).toList());
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
