import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:pluto_grid/pluto_grid.dart';

class BondRecordModel {
  String? bondRecId, bondRecAccount, bondRecDescription, invId;
  double? bondRecCreditAmount, bondRecDebitAmount;

  BondRecordModel(this.bondRecId, this.bondRecCreditAmount, this.bondRecDebitAmount, this.bondRecAccount, this.bondRecDescription, {this.invId});

  BondRecordModel.fromJson(json) {
    bondRecId = json['bondRecId'];
    bondRecAccount = json['bondRecAccount'];
    bondRecDescription = json['bondRecDescription'];
    bondRecCreditAmount = double.tryParse(json['bondRecCreditAmount'].toString()) ?? 0.0;
    bondRecDebitAmount = double.tryParse(json['bondRecDebitAmount'].toString()) ?? 0.0;
    invId = json['invId'];
  }

  BondRecordModel.fromPlutoJson(json) {
    bondRecId = json['bondRecId'];
    bondRecAccount = getAccountIdFromText(json['bondRecAccount']);
    bondRecDescription = json['bondRecDescription'];
    bondRecCreditAmount = double.tryParse(json['bondRecCreditAmount'].toString()) ?? 0.0;
    bondRecDebitAmount = double.tryParse(json['bondRecDebitAmount'].toString()) ?? 0.0;
    invId = json['invId'];
  }

  Map<String, dynamic> toJson() {
    return {"bondRecId": bondRecId, "bondRecAccount": bondRecAccount, "bondRecDescription": bondRecDescription, "bondRecCreditAmount": bondRecCreditAmount, "bondRecDebitAmount": bondRecDebitAmount, if (invId != null) 'invId': invId};
  }

  // Override hashCode and operator == for proper set comparison
  @override
  int get hashCode => bondRecId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BondRecordModel && runtimeType == other.runtimeType && bondRecId == other.bondRecId;

  Map<String, Map<String, dynamic>> getChanges(BondRecordModel other) {
    Map<String, dynamic> newChanges = {};
    Map<String, dynamic> oldChanges = {};

    if (bondRecAccount != other.bondRecAccount) {
      newChanges['bondRecAccount'] = other.bondRecAccount;
      oldChanges['bondRecAccount'] = bondRecAccount;
    }
    if (bondRecCreditAmount != other.bondRecCreditAmount) {
      newChanges['bondRecCreditAmount'] = other.bondRecCreditAmount;
      oldChanges['bondRecCreditAmount'] = bondRecCreditAmount;
    }
    if (bondRecDebitAmount != other.bondRecDebitAmount) {
      newChanges['bondRecDebitAmount'] = other.bondRecDebitAmount;
      oldChanges['bondRecDebitAmount'] = bondRecDebitAmount;
    }
    if (bondRecDescription != other.bondRecDescription) {
      newChanges['bondRecDescription'] = other.bondRecDescription;
      oldChanges['bondRecDescription'] = bondRecDescription;
    }
    if (newChanges.isNotEmpty) newChanges['bondRecId'] = other.bondRecId;
    if (oldChanges.isNotEmpty) oldChanges['bondRecId'] = bondRecId;
    return {"newData": newChanges, "oldData": oldChanges};
  }

  Map<PlutoColumn, dynamic> toEditedMap(String type) {
    switch (type) {
      case Const.bondTypeDebit:
        return {
          PlutoColumn(
            title: 'الرقم',
            field: 'bondRecId',
            readOnly: true,
            width: 50,
            type: PlutoColumnType.text(),

            renderer: (rendererContext) {
              rendererContext.cell.value=rendererContext.rowIdx.toString();
              return Text(rendererContext.rowIdx.toString());
            },
          ): invId,
          PlutoColumn(
            title: 'مدين',
            field: 'bondRecDebitAmount',
            type: PlutoColumnType.text(),
          ): bondRecDebitAmount,
          PlutoColumn(
            title: 'الحساب',
            field: "bondRecAccount",
            type: PlutoColumnType.text(),
            checkReadOnly: (row, cell) {
              return cell.row.cells['invRecProduct']?.value == '';
            },
          ): getAccountNameFromId(bondRecAccount),
          PlutoColumn(
            title: 'البيان',
            field: 'bondRecDescription',
            type: PlutoColumnType.text(),
          ): bondRecDescription,
        };
      case Const.bondTypeCredit:
        return {
          PlutoColumn(
            title: 'الرقم',
            field: 'bondRecId',
            readOnly: true,
            width: 50,
            type: PlutoColumnType.text(),
            renderer: (rendererContext) {



                rendererContext.cell.value = rendererContext.rowIdx.toString();
                return Text(rendererContext.rowIdx.toString());


            },
          ): invId,
          PlutoColumn(
            title: 'دائن',
            field: 'bondRecCreditAmount',
            type: PlutoColumnType.text(),
          ): bondRecCreditAmount,
          PlutoColumn(
            title: 'الحساب',
            field: "bondRecAccount",
            type: PlutoColumnType.text(),
            checkReadOnly: (row, cell) {
              return cell.row.cells['invRecProduct']?.value == '';
            },
          ): getAccountNameFromId(bondRecAccount),
          PlutoColumn(
            title: 'البيان',
            field: 'bondRecDescription',
            type: PlutoColumnType.text(),
          ): bondRecDescription,
        };

      default:
        return {
          PlutoColumn(
            title: 'الرقم',
            field: 'bondRecId',
            readOnly: true,
            width: 50,
            type: PlutoColumnType.text(),
            renderer: (rendererContext) {

                rendererContext.cell.value = rendererContext.rowIdx.toString();
                return Text(rendererContext.rowIdx.toString());

            },
          ): invId,
          PlutoColumn(
            title: 'مدين',
            field: 'bondRecDebitAmount',
            type: PlutoColumnType.text(),
          ): bondRecDebitAmount,
          PlutoColumn(
            title: 'دائن',
            field: 'bondRecCreditAmount',
            type: PlutoColumnType.text(),
          ): bondRecCreditAmount,
          PlutoColumn(
            title: 'الحساب',
            field: "bondRecAccount",
            type: PlutoColumnType.text(),
            checkReadOnly: (row, cell) {
              return cell.row.cells['invRecProduct']?.value == '';
            },
          ): getAccountNameFromId(bondRecAccount),
          PlutoColumn(
            title: 'البيان',
            field: 'bondRecDescription',
            type: PlutoColumnType.text(),
          ): bondRecDescription,
        };
    }
  }
}
