import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/old_model/account_model.dart';
import 'package:ba3_business_solutions/old_model/account_record_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Const/const.dart';

class AccountRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();
  double lastBalance=0;
  AccountRecordDataSource({required List<AccountRecordModel> accountRecordModel,required AccountModel accountModel}) {

    dataGridRows.clear();
    var accountController = Get.find<AccountViewModel>();

    List<AccountRecordModel> allRecord =[];
    allRecord.addAll(accountRecordModel);
    for (var element in accountModel.accChild) {
      print(element);
      allRecord.addAll(accountController.accountList[element]!.accRecord.toList());
    }
    if(accountModel.accType==Const.accountTypeAggregateAccount){
      for (var element in accountModel.accAggregateList) {
        allRecord.addAll(accountController.accountList[element]!.accRecord.toList());
      }
    }

    dataGridRows = allRecord
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: Const.rowAccountName, value: getAccountNameFromId(e.account)),
              DataGridCell<RecordType>(columnName: Const.rowAccountType, value: RecordType.bond),
              DataGridCell<String>(columnName: Const.rowAccountTotal, value: e.total),
              DataGridCell<double>(columnName: Const.rowAccountBalance, value: lastBalance+= double.parse(e.total!)),
              DataGridCell<String>(columnName: Const.rowAccountId, value: e.id),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: dataGridCell.columnName == Const.rowAccountType
              ? Text(
                  dataGridCell.value == RecordType.bond
                      ? 'سندات'
                      : dataGridCell.value == RecordType.invoice
                          ? "فواتير"
                          : "غير ذالك",
                  overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 22) )
              :dataGridCell.columnName == Const.rowAccountBalance||dataGridCell.columnName == Const.rowAccountTotal
          ?Text(dataGridCell.value == null ? '' : double.parse(dataGridCell.value.toString()).toStringAsFixed(2),style: TextStyle(fontSize: 22))
          :Text(dataGridCell.value == null ? '' : dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 22) ));
    }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Text(summaryValue,),
    );
  }

  // description
  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    // Return false, to retain in edit mode.
    return false; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }
}
