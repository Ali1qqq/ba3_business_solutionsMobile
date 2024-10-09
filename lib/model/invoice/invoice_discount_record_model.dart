import 'package:flutter/cupertino.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../core/constants/app_strings.dart';

class InvoiceDiscountRecordModel {
  String? invId, accountId;
  double? discountPercentage, discountTotal, addedPercentage, addedTotal;

  int? discountId;
  bool? isChooseDiscountTotal, isChooseAddedTotal;

  InvoiceDiscountRecordModel(
      {this.invId,
      this.accountId,
      this.addedPercentage,
      this.addedTotal,
      this.discountId,
      this.isChooseDiscountTotal,
      this.discountPercentage,
      this.discountTotal,
      this.isChooseAddedTotal});

  InvoiceDiscountRecordModel.fromJson(json) {
    invId = json['invId'];
    accountId = json['accountId'];
    isChooseDiscountTotal = json['isChooseDiscountTotal'];
    discountPercentage = json['discountPercentage'];
    discountTotal = json['discountTotal'];
    discountId = json['discountId'];
    isChooseAddedTotal = json['isChooseAddedTotal'];
    addedPercentage = json['addedPercentage'];
    addedTotal = json['addedTotal'];
  }

  toJson() {
    return {
      "invId": invId,
      "accountId": accountId,
      "discountPercentage": discountPercentage,
      "discountTotal": discountTotal,
      "isChooseDiscountTotal": isChooseDiscountTotal,
      "discountId": discountId,
      "addedPercentage": addedPercentage,
      "addedTotal": addedTotal,
      "isChooseAddedTotal": isChooseAddedTotal,
    };
  }

  Map<PlutoColumn, dynamic> toEditedMap() {
    return {
      PlutoColumn(
        title: AppStrings.invoiceId,
        field: 'invId',
        readOnly: true,
        width: 50,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          if (rendererContext.row.cells["accountId"]?.value != '') {
            rendererContext.cell.value = rendererContext.rowIdx.toString();
            return Text(rendererContext.rowIdx.toString());
          }
          return const Text("");
        },
      ): invId,
      PlutoColumn(
        title: AppStrings.accountId,
        field: 'accountId',
        type: PlutoColumnType.text(),
        checkReadOnly: (row, cell) {
          return false;
        },
      ): accountId,
      PlutoColumn(
        title: AppStrings.addedTotal,
        field: "addedTotal",
        type: PlutoColumnType.text(),
        checkReadOnly: (row, cell) {
          return cell.row.cells['accountId']?.value == '';
        },
      ): addedTotal,
      PlutoColumn(
        title: AppStrings.addedPercentage,
        field: 'addedPercentage',
        type: PlutoColumnType.text(),
        checkReadOnly: (row, cell) {
          return cell.row.cells['accountId']?.value == '';
        },
      ): addedPercentage,
      PlutoColumn(
        title: AppStrings.discountTotal,
        field: "discountTotal",
        type: PlutoColumnType.text(),
        checkReadOnly: (row, cell) {
          return cell.row.cells['accountId']?.value == '';
        },
      ): discountTotal,
      PlutoColumn(
        title: AppStrings.discountPercentage,
        field: 'discountPercentage',
        type: PlutoColumnType.text(),
      ): discountPercentage,
    };
  }
}
