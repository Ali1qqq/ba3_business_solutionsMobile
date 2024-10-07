import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/model/bond_record_model.dart';
import 'package:ba3_business_solutions/model/entry_bond_record_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class BondRecordPlutoViewModel extends GetxController {
  BondRecordPlutoViewModel(String type) {
    getColumns(type);
  }

  getColumns(String type) {
    {
      Map<PlutoColumn, dynamic> sampleData = BondRecordModel("", 0.0, 0, "", "").toEditedMap(type);
      columns = sampleData.keys.toList();
    }
    return columns;
  }

  getRows(List<BondRecordModel> modelList, String type) {
    stateManager.removeAllRows();
    final newRows = stateManager.getNewRows(count: 30);

    if (modelList.isEmpty) {
      stateManager.appendRows(newRows);
      return rows;
    } else {
      rows = modelList.map((model) {
        Map<PlutoColumn, dynamic> rowData = model.toEditedMap(type);

        Map<String, PlutoCell> cells = {};

        rowData.forEach((key, value) {
          cells[key.field] = PlutoCell(value: value?.toString() ?? '');
        });

        return PlutoRow(cells: cells);
      }).toList();
    }

    stateManager.appendRows(rows);
    stateManager.appendRows(newRows);
    // print(rows.length);
    return rows;
  }

  List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager = PlutoGridStateManager(columns: [], rows: [], gridFocusNode: FocusNode(), scroll: PlutoGridScrollController());
  List<PlutoColumn> columns = [];

  void updateCellValue(String field, dynamic value) {
    stateManager.changeCellValue(
      stateManager.currentRow!.cells[field]!,
      value,
      callOnChangedEvent: false,
      notify: true,
    );
  }

  double calcDebitTotal({bool? isDebit}) {
    double total = 0;
    if (isDebit == false) {
      total = calcCreditTotal();
    } else {
      for (var element in stateManager.rows) {
        if (getAccountIdFromText(element.toJson()["bondRecAccount"] ?? "") != '') {
          total += double.tryParse(element.toJson()["bondRecDebitAmount"] ?? "") ?? 0.0;
        }
      }
    }
    return total;
  }

  double calcCreditTotal({bool? isDebit}) {
    double total = 0;
    if (isDebit == true) {
      total = calcDebitTotal();
    } else {
      for (var element in stateManager.rows) {
        if (getAccountIdFromText(element.toJson()["bondRecAccount"] ?? "") != '') {
          total += double.tryParse(element.toJson()["bondRecCreditAmount"] ?? "") ?? 0;
        }
      }
    }
    return total;
  }

  bool checkIfBalancedBond({bool? isDebit}) {
    if (getDefBetweenCreditAndDebt(isDebit: isDebit) == 0) {
      return true;
    } else {
      return false;
    }
  }

  double getDefBetweenCreditAndDebt({bool? isDebit}) {
    return calcCreditTotal(isDebit: isDebit).toInt() - calcDebitTotal(isDebit: isDebit).toInt() * 1.0;
  }

  clearRowIndex(int rowIdx) {
    final rowToRemove = stateManager.rows[rowIdx];

    stateManager.removeRows([rowToRemove]);
    Get.back();
    update();
  }

  List<BondRecordModel> handleSaveAll({bool? isCredit, String? account}) {
    stateManager.setShowLoading(true);
    List<BondRecordModel> invRecord = [];
    invRecord = stateManager.rows
        .where((element) => getAccountIdFromText(element.cells['bondRecAccount']!.value) != "")
        .map(
          (e) => BondRecordModel.fromPlutoJson(e.toJson()),
        )
        .toList();
    if (isCredit == true) {
      invRecord.add(
        BondRecordModel(
          (invRecord.length + 1).toString(),
          0,
          calcCreditTotal(),
          getAccountIdFromText(account),
          "",
        ),
      );
    } else if (isCredit == false) {
      invRecord.add(
        BondRecordModel(
          (invRecord.length + 1).toString(),
          calcDebitTotal(),
          0,
          getAccountIdFromText(account),
          "",
        ),
      );
    }
// print(invRecord.map((e) => e.toJson(),).toList());
    stateManager.setShowLoading(false);
    return invRecord;
  }

  List<EntryBondRecordModel> handleSaveAllForEntry({bool? isCredit, String? account}) {
    stateManager.setShowLoading(true);
    List<EntryBondRecordModel> invRecord = [];
    invRecord = stateManager.rows
        .where((element) => getAccountIdFromText(element.cells['bondRecAccount']!.value) != "")
        .map(
          (e) => EntryBondRecordModel.fromPlutoJson(e.toJson()),
        )
        .toList();
    if (isCredit == true) {
      invRecord.add(
        EntryBondRecordModel(
          (invRecord.length + 1).toString(),
          calcCreditTotal(),
          0,
          getAccountIdFromText(account),
          "",
        ),
      );
    } else if (isCredit == false) {
      invRecord.add(
        EntryBondRecordModel(
          (invRecord.length + 1).toString(),
          0,
          calcDebitTotal(),
          getAccountIdFromText(account),
          "",
        ),
      );
    }

    stateManager.setShowLoading(false);
    return invRecord;
  }
}
