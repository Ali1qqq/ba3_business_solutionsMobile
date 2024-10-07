import 'package:ba3_business_solutions/model/Warranty_record_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../controller/product_view_model.dart';
import '../model/product_model.dart';



class WarrantyPlutoViewModel extends GetxController {
  WarrantyPlutoViewModel() {
    getColumns();
  }

  getColumns() {
    Map<PlutoColumn, dynamic> sampleData = WarrantyRecordModel().toEditedMap();
    columns = sampleData.keys.toList();
    update();
    return columns;
  }

  updateInvoiceValuesByTotal(double? total, int? quantity){

  }
  getPrice({type, prodName}){

  }

  clearRowIndex(int rowIdx) {
    final rowToRemove = stateManager.rows[rowIdx];

    stateManager.removeRows([rowToRemove]);
    Get.back();
    update();
  }

  getRows(List<WarrantyRecordModel> modelList) {
    stateManager.removeAllRows();
    final newRows = stateManager.getNewRows(count: 30);

    if (modelList.isEmpty) {
      stateManager.appendRows(newRows);
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

    stateManager.appendRows(rows);
    stateManager.appendRows(newRows);
    // print(rows.length);
    return rows;
  }

  void addProductToInvoice(List<ProductModel> result) {

    for (var i = 0; i < result.length; i++) {

      // double price=0;

        // price = getPrice(type: Const.invoiceChoosePriceMethodeCustomerPrice, prodName: result[i].prodName);

      bool productExists = false;

      // Iterate over existing rows to check if the product already exists
      for (var row in stateManager.rows) {
        if (row.cells['invRecProduct']?.value == result[i].prodName) {
          // If product exists, increase the quantity
          var currentQuantity = row.cells['invRecQuantity']?.value ?? 1;
          row.cells['invRecQuantity']?.value = currentQuantity + 1;

          // Recalculate the total and VAT
          // row.cells['invRecVat']?.value = double.parse(((price * 0.05) * (currentQuantity + 1)).toStringAsFixed(2));
          productExists = true;
          update();
          break;
        }
      }

      // If the product doesn't exist, add a new row
      if (!productExists) {
        stateManager.prependRows([
          PlutoRow.fromJson(WarrantyRecordModel(
            invRecProduct: result[i].prodName!.toString(),
            invRecQuantity: 1,
          ).toJson())
        ]);
      }
    }
  }


  List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager = PlutoGridStateManager(columns: [], rows: [], gridFocusNode: FocusNode(), scroll: PlutoGridScrollController());
  List<PlutoColumn> columns = [];


  List<WarrantyRecordModel> invoiceRecord = [];

  List<WarrantyRecordModel> handleSaveAll() {
    stateManager.setShowLoading(true);
    List<WarrantyRecordModel> invRecord = [];

    invoiceRecord.clear();

      invRecord = stateManager.rows.where((element) {
        return getProductIdFromName(element.cells['invRecProduct']!.value) != null;
      }).map(
            (e) {

          return WarrantyRecordModel.fromJsonPluto(e.toJson());
        },
      ).toList();




    for (var record in invRecord) {
      invoiceRecord.add(record);
    }
    stateManager.setShowLoading(false);

    return invRecord;
  }

}
