import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../model/invoice_discount_record_model.dart';

class DiscountPlutoViewModel extends GetxController {
  DiscountPlutoViewModel() {
    getColumns();
  }

  getColumns() {
    {
      Map<PlutoColumn, dynamic> sampleData = InvoiceDiscountRecordModel().toEditedMap();
      columns = sampleData.keys.toList();
    }
    return columns;
  }

  getRows(List<InvoiceDiscountRecordModel> modelList) {
    if (modelList.isEmpty) {
      return rows;
    } else {
      rows = modelList.map((model) {
        Map<PlutoColumn, dynamic> rowData = model.toEditedMap();

        Map<String, PlutoCell> cells = {};

        rowData.forEach((key, value) {
          cells[key.field] = PlutoCell(value: value?.toString() ?? '');
        });

        return PlutoRow(cells: cells);
      }).toList();
    }
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

  List<InvoiceDiscountRecordModel> handleSaveAll() {
    stateManager.setShowLoading(true);
    List<InvoiceDiscountRecordModel> invRecord = [];

    invRecord = stateManager.rows
        .where((element) => element.cells['invRecProduct']!.value != '')
        .map(
          (e) => InvoiceDiscountRecordModel.fromJson(e.toJson()),
        )
        .toList();

    stateManager.setShowLoading(false);
    return invRecord;
  }
}
