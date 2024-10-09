import 'package:ba3_business_solutions/controller/invoice/invoice_view_model.dart';
import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/model/product/product_record_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/constants/app_constants.dart';
import '../../../model/product/product_model.dart';

class ProductRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();
  ProductViewModel productController = Get.find<ProductViewModel>();
  int total = 0;

  ProductRecordDataSource({required ProductModel productModel}) {
    dataGridRows.clear();
    List<ProductRecordModel> allRec = [];
    allRec.addAll(productModel.prodRecord ?? []);
    productModel.prodChild?.forEach((element) {
      allRec
          .addAll(productController.productDataMap[element]?.prodRecord ?? []);
    });
    //total = allRec.map((e)=>int.parse(e.prodRecQuantity??"0")).toList().reduce((value, element) => value+element,);
    dataGridRows = allRec.map<DataGridRow>((e) {
      total = total + int.parse(e.prodRecQuantity ?? "0");
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: AppConstants.rowProductRecProduct,
            value: getProductNameFromId(e.prodRecProduct)),
        DataGridCell<String>(
            columnName: AppConstants.rowProductType,
            value: getInvoicePatternFromInvId(e.invId)),
        DataGridCell<String>(
            columnName: AppConstants.rowProductQuantity,
            value: e.prodRecQuantity),
        DataGridCell<String>(
            columnName: AppConstants.rowProductTotal, value: total.toString()),
        DataGridCell<String>(
            columnName: AppConstants.rowProductDate, value: e.prodRecDate),
        DataGridCell<String>(
            columnName: AppConstants.rowProductInvId, value: e.invId),
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
        return Colors.white;
      }

      return Colors.blue.withOpacity(0.5);
    }

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          color: getRowBackgroundColor(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value == null ? '' : dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }

  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    // Return false, to retain in edit mode.
    return false; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }
}
