import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../core/constants/app_strings.dart';

class WarrantyRecordModel {
  String? invRecId, invRecProduct;
  int? invRecQuantity;

  WarrantyRecordModel({
    this.invRecId,
    this.invRecProduct,
    this.invRecQuantity,
  });

  WarrantyRecordModel.fromJson(Map<dynamic, dynamic> map) {
    invRecId = map['invRecId'];
    invRecProduct = map['invRecProduct'];
    invRecQuantity = int.tryParse(map['invRecQuantity'].toString());
  }

  WarrantyRecordModel.fromJsonPluto(Map<dynamic, dynamic> map) {
    invRecId = map['invRecId'];
    invRecProduct =
        getProductIdFromName(map['invRecProduct']) ?? map['invRecProduct'];
    invRecQuantity = int.tryParse(
        replaceArabicNumbersWithEnglish(map['invRecQuantity'].toString()));
  }

  toJson() {
    return {
      'invRecId': invRecId,
      'invRecProduct': invRecProduct,
      'invRecQuantity': invRecQuantity,
    };
  }

  @override
  int get hashCode => invRecId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WarrantyRecordModel &&
          runtimeType == other.runtimeType &&
          invRecId == other.invRecId;

  Map<PlutoColumn, dynamic> toEditedMap() {
    return {
      PlutoColumn(
        title: AppStrings.invoiceId.tr,
        field: 'invRecId',
        readOnly: true,
        width: 50,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          if (rendererContext.row.cells["invRecProduct"]?.value != '') {
            rendererContext.cell.value = rendererContext.rowIdx.toString();
            return Text(rendererContext.rowIdx.toString());
          }
          return const Text("");
        },
      ): invRecId,
      PlutoColumn(
        title: AppStrings.product.tr,
        field: 'invRecProduct',
        type: PlutoColumnType.text(),
        checkReadOnly: (row, cell) {
          return false;
        },
      ): getProductModelFromId(invRecProduct)?.prodName ?? invRecProduct,
      PlutoColumn(
        title: AppStrings.quantity.tr,
        field: 'invRecQuantity',
        type: PlutoColumnType.text(),
        checkReadOnly: (row, cell) {
          return cell.row.cells['invRecProduct']?.value == '';
        },
      ): invRecQuantity,
    };
  }
}
