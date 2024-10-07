import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/account_record_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Const/const.dart';

class AccountRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();
  double lastBalance = 0;
  AccountRecordDataSource({required List<AccountRecordModel> accountRecordModel, required AccountModel accountModel}) {
    dataGridRows.clear();
    var accountController = Get.find<AccountViewModel>();

    List<AccountRecordModel> allRecord = [];
    allRecord.addAll(accountRecordModel);
    for (var element in accountModel.accChild) {
      print(element);
      allRecord.addAll(accountController.accountList[element]!.accRecord.toList());
    }
    if (accountModel.accType == Const.accountTypeAggregateAccount) {
      for (var element in accountModel.accAggregateList) {
        allRecord.addAll(accountController.accountList[element]!.accRecord.toList());
      }
    }
    allRecord.sort((a, b) => a.date!.compareTo(b.date!),);
    dataGridRows = allRecord.map<DataGridRow>((e) {
      String? _;
      if (e.isPaidStatus == Const.paidStatusSemiUsed) {
        _ = " متبقي " + "(" + e.paid.toString() + ")";
      }

      return DataGridRow(cells: [
        DataGridCell<String>(columnName: Const.rowAccountName, value: getAccountNameFromId(e.account)),
        DataGridCell<String>(columnName: Const.rowAccountName, value:e.date),
        DataGridCell<String>(columnName: Const.rowAccountType, value: getGlobalTypeFromEnum(e.accountRecordType!)),
        DataGridCell<String>(columnName: Const.rowAccountTotal, value: double.parse(e.total!) > 0 ? "0" : e.total!),
        DataGridCell<String>(columnName: Const.rowAccountTotal2, value: double.parse(e.total!) < 0 ? "0" : e.total!),
        DataGridCell<double>(columnName: Const.rowAccountBalance, value: lastBalance += double.parse(e.total!)),
        DataGridCell<String>(columnName: Const.rowAccountId, value: e.id),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getRowBackgroundColor() {
      final int index = effectiveRows.indexOf(row);
      if (index % 2 == 0) {
        return  Colors.white;
      }

      return Colors.blueAccent.withOpacity(0.5);
    }
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          color:getRowBackgroundColor(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: dataGridCell.columnName == Const.rowAccountType
              ? Text(dataGridCell.value, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 22))
              : dataGridCell.columnName == Const.rowAccountBalance || dataGridCell.columnName == Const.rowAccountTotal
                  ? Text(dataGridCell.value == null ? '' : double.parse(dataGridCell.value.toString()).toStringAsFixed(2), style: TextStyle(fontSize: 22))
                  : Text(dataGridCell.value == null ? '' : dataGridCell.value.toString(), overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 22)));
    }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Text(

        summaryValue,
      ),
    );
  }

  // description
  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    // Return false, to retain in edit mode.
    return false; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }
}
