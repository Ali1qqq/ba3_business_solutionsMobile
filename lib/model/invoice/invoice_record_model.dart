import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../core/constants/app_strings.dart';

class InvoiceRecordModel {
  String? invRecId, invRecProduct, prodChoosePriceMethod;
  int? invRecQuantity, invRecGift;
  double? invRecSubTotal, invRecTotal, invRecVat, invRecGiftTotal;
  bool? invRecIsLocal;

  InvoiceRecordModel({
    this.invRecId,
    this.invRecProduct,
    this.invRecQuantity,
    this.invRecSubTotal,
    this.invRecTotal,
    this.invRecVat,
    this.prodChoosePriceMethod,
    this.invRecIsLocal,
    this.invRecGift,
    this.invRecGiftTotal,
  });

  InvoiceRecordModel.fromJson(Map<dynamic, dynamic> map) {
    invRecId = map['invRecId'];
    invRecProduct = map['invRecProduct'];
    invRecQuantity = int.tryParse(map['invRecQuantity'].toString());
    invRecSubTotal = double.tryParse(map['invRecSubTotal'].toString());
    invRecTotal = double.tryParse(map['invRecTotal'].toString());
    invRecVat = double.tryParse((map['invRecVat']).toString());
    invRecIsLocal = map['invRecIsLocal'];
    invRecGift = int.tryParse(map['invRecGift'].toString());
    invRecGiftTotal =
        (int.tryParse(map['invRecGiftTotal'].toString()) ?? 0) * 1.0;
  }

  InvoiceRecordModel.fromJsonPluto(Map<dynamic, dynamic> map) {
    invRecId = map['invRecId'];
    invRecProduct =
        getProductIdFromName(map['invRecProduct']) ?? map['invRecProduct'];
    invRecQuantity = int.tryParse(
        replaceArabicNumbersWithEnglish(map['invRecQuantity'].toString()))??1;
    invRecSubTotal = double.tryParse(
        replaceArabicNumbersWithEnglish(map['invRecSubTotal'].toString()))??0.0;
    invRecTotal = double.tryParse(map['invRecTotal'].toString())??0.0;
    invRecVat = double.tryParse((map['invRecVat']).toString())??0.0;
    invRecIsLocal = map['invRecIsLocal'];
    invRecGift = int.tryParse(
        replaceArabicNumbersWithEnglish(map['invRecGift'].toString()))??0;
    invRecGiftTotal =
        (int.tryParse(map['invRecGiftTotal'].toString()) ?? 0) * 1.0;
  }

  toJson() {
    return {
      'invRecId': invRecId,
      'invRecProduct': invRecProduct,
      'invRecQuantity': invRecQuantity,
      'invRecSubTotal': invRecSubTotal,
      'invRecTotal': invRecTotal,
      'invRecVat': invRecVat,
      'invRecIsLocal': invRecIsLocal,
      'invRecGift': invRecGift,
      'invRecGiftTotal': invRecGiftTotal,
    };
  }

  @override
  int get hashCode => invRecId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceRecordModel &&
          runtimeType == other.runtimeType &&
          invRecId == other.invRecId;

  Map<String, Map<String, dynamic>> getChanges(InvoiceRecordModel other) {
    Map<String, dynamic> newChanges = {};
    Map<String, dynamic> oldChanges = {};

    if (invRecProduct != other.invRecProduct) {
      newChanges['invRecProduct'] = other.invRecProduct;
      oldChanges['invRecProduct'] = invRecProduct;
    }

    if (invRecQuantity != other.invRecQuantity) {
      newChanges['invRecQuantity'] = other.invRecQuantity;
      oldChanges['invRecQuantity'] = invRecQuantity;
    }

    if (invRecSubTotal != other.invRecSubTotal) {
      newChanges['invRecSubTotal'] = other.invRecSubTotal;
      oldChanges['invRecSubTotal'] = invRecSubTotal;
    }

    if (invRecTotal != other.invRecTotal) {
      newChanges['invRecTotal'] = other.invRecTotal;
      oldChanges['invRecTotal'] = invRecTotal;
    }

    if (invRecVat != other.invRecVat) {
      newChanges['invRecVat'] = other.invRecVat;
      oldChanges['invRecVat'] = invRecVat;
    }

    if (invRecIsLocal != other.invRecIsLocal) {
      newChanges['invRecIsLocal'] = other.invRecIsLocal;
      oldChanges['invRecIsLocal'] = invRecIsLocal;
    }
    if (invRecGift != other.invRecGift) {
      newChanges['invRecGift'] = other.invRecGift;
      oldChanges['invRecGift'] = invRecGift;
    }
    if (invRecGiftTotal != other.invRecGiftTotal) {
      newChanges['invRecGiftTotal'] = other.invRecGiftTotal;
      oldChanges['invRecGiftTotal'] = invRecGiftTotal;
    }

    if (newChanges.isNotEmpty) newChanges['invRecId'] = other.invRecId;
    if (oldChanges.isNotEmpty) oldChanges['invRecId'] = invRecId;

    return {"newData": newChanges, "oldData": oldChanges};
  }

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
      PlutoColumn(
        title: AppStrings.unitPrice.tr,
        field: "invRecSubTotal",
        type: PlutoColumnType.text(),
        checkReadOnly: (row, cell) {
          return cell.row.cells['invRecProduct']?.value == '';
        },
      ): invRecSubTotal,
      PlutoColumn(
        title: AppStrings.vat.tr,
        field: 'invRecVat',
        type: PlutoColumnType.text(),
      ): invRecVat,
      PlutoColumn(
        title: AppStrings.total.tr,
        field: 'invRecTotal',
        type: PlutoColumnType.text(),
        checkReadOnly: (row, cell) {
          return cell.row.cells['invRecProduct']?.value == '';
        },
      ): invRecTotal,
      PlutoColumn(
        title: AppStrings.discount.tr,
        field: 'invRecDis',
        type: PlutoColumnType.text(),
      ): '',
      PlutoColumn(
        title: AppStrings.gift.tr,
        field: "invRecGift",
        type: PlutoColumnType.text(),
        checkReadOnly: (row, cell) {
          return cell.row.cells['invRecProduct']?.value == '';
        },
      ): invRecGift,
    };
  }
}
