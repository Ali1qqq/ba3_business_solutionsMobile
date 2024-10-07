import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../Const/const.dart';

class StoreRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

  StoreRecordDataSource({required Map<String, StoreModel> stores}) {
    dataGridRows.clear();
    dataGridRows = stores.values
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: "stId", value: e.stId),
              DataGridCell<String>(columnName: Const.stCode, value: e.stCode),
              DataGridCell<String>(
                  columnName: Const.stName, value: e.stName),
            ]))
        .toList();
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

      return Colors.blue.withOpacity(0.5);
    }
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          color: getRowBackgroundColor(),
          padding:const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value == null ? '' : dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Text(summaryValue),
    );
  }

  // description
  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    // Return false, to retain in edit mode.
    return false; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }

  void sortDataGridRows(String columnName, bool isAscending) {
    dataGridRows.sort((a, b) {
      final valueA = getValueByColumnName(a, columnName);
      final valueB = getValueByColumnName(b, columnName);
      if (valueA != null && valueB != null) {
        if (isAscending) {
          return valueA.compareTo(valueB);
        } else {
          return valueB.compareTo(valueA);
        }
      }
      return 0;
    });
    notifyListeners();
  }

  dynamic getValueByColumnName(DataGridRow row, String columnName) {
    final cell = row.getCells().firstWhere(
            (element) => element.columnName == columnName,
        orElse: () => DataGridCell<String>(columnName: columnName, value: ''));
    return cell.value;
  }
}
