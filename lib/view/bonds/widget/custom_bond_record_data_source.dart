import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/model/bond_record_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../Const/const.dart';
import '../../../controller/account_view_model.dart';
import '../../../model/account_model.dart';

final bondController = Get.find<BondViewModel>();

class CustomBondRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  dynamic newCellValue;
  late bool isDebit;
  TextEditingController editingController = TextEditingController();

  CustomBondRecordDataSource({required GlobalModel recordData, required bool oldisDebit}) {
    buildRowInit(recordData, oldisDebit);
    addItem(oldisDebit);
    isDebit = oldisDebit;
  }
  final accountController = Get.find<AccountViewModel>();

  buildRowInit(GlobalModel recordData, isDebit) {
    recordData.bondRecord?.map((e) => print(e.bondRecAccount));
    dataGridRows = recordData.bondRecord!
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: Const.rowBondId, value: e.bondRecId),
              DataGridCell<String>(columnName: Const.rowBondAccount, value: accountController.accountList.values.toList().firstWhereOrNull((_) => _.accId == e.bondRecAccount)?.accName),
              isDebit
                  ? DataGridCell<double>(columnName: Const.rowBondDebitAmount, value: e.bondRecDebitAmount)
                  : DataGridCell<double>(columnName: Const.rowBondCreditAmount, value: e.bondRecCreditAmount),
              DataGridCell<String>(columnName: Const.rowBondDescription, value: e.bondRecDescription),
            ]))
        .toList();
  }

  void addItem(isDebit) {
    dataGridRows.add(DataGridRow(cells: [
      const DataGridCell<String>(columnName: Const.rowBondId, value: ""),
      const DataGridCell<String>(columnName: Const.rowBondAccount, value: ''),
      isDebit ? const DataGridCell<double>(columnName: Const.rowBondCreditAmount, value: null) : DataGridCell<double>(columnName: Const.rowBondDebitAmount, value: null),
      const DataGridCell<String>(columnName: Const.rowBondDescription, value: ""),
    ]));
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value == null ? '' : dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Text(summaryValue),
    );
  }

  Future<void> onCellSubmitFun(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    // final dynamic oldValue = dataGridRow.getCells().firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == column.columnName)?.value ?? '';
    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);
    // if (newCellValue == null || oldValue == newCellValue) {
    //   return null;
    // }
    print(column.columnName);
    if (dataGridRows.length == dataRowIndex + 1) {
      var id = (int.parse(dataGridRows[dataRowIndex - 1].getCells()[0].value) + 1).toString();
      if (int.parse(id) < 10) id = "0$id";
      dataGridRows[dataRowIndex].getCells()[0] = DataGridCell<String>(columnName: Const.rowBondId, value: id);
      bondController.tempBondModel.bondRecord?.add(BondRecordModel(id, 0.0, 0.0, '', ''));
    }
    // if(column.columnName == Const.rowBondDebitAmount ||column.columnName == Const.rowBondCreditAmount){
    //   if(column.columnName == Const.rowBondDebitAmount ){
    //     if( dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex+1].value==null||dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex+1].value==0){
    //       dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
    //           DataGridCell<int>(columnName: column.columnName , value: int.parse(newCellValue));
    //       bondController.tempBondModel.bondRecord![dataRowIndex].BondRecDebitAmount = int.parse(newCellValue);
    //     }else{
    //       dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
    //           DataGridCell<int>(columnName: column.columnName , value: 0);
    //       bondController.tempBondModel.bondRecord![dataRowIndex].BondRecDebitAmount = 0;
    //       if(newCellValue!="0") {
    //         Get.defaultDialog(middleText: "debit or credit should be 0");
    //       }
    //     }
    //   }else{
    //     if( dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex-1].value==null||dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex-1].value==0){
    //       dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
    //           DataGridCell<int>(columnName: column.columnName , value: int.parse(newCellValue));
    //       bondController.tempBondModel.bondRecord![dataRowIndex].BondRecCreditAmount = int.parse(newCellValue);
    //     }else{
    //       dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
    //           DataGridCell<int>(columnName: column.columnName , value: 0);
    //       bondController.tempBondModel.bondRecord![dataRowIndex].BondRecCreditAmount = 0;
    //       if(newCellValue!="0"){
    //         Get.defaultDialog(middleText: "debit or credit should be 0");
    //       }
    //     }
    //   }
    // }

    if (column.columnName == Const.rowBondAccount) {
      print("object");
      List<String> result = searchText(newCellValue.toString());
      if (result.isEmpty) {
        print(bondController.tempBondModel.bondRecord?.firstWhere((element) => element.bondRecId == rows[dataRowIndex].getCells()[0].value));
        print(rows[dataRowIndex].getCells()[0].value);
        Get.snackbar("error", "not found");
      } else if (result.length == 1) {
        var name = result[0];
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<String>(columnName: column.columnName, value: name);
        var accId = accountController.accountList.values.toList().firstWhere((e) => e.accName == name).accId;
        bondController.tempBondModel.bondRecord?.firstWhere((element) => element.bondRecId == rows[dataRowIndex].getCells()[0].value).bondRecAccount = accId;
        print(bondController.tempBondModel.bondRecord?[dataRowIndex].toJson());

        bondController.update();
      } else {
        await Get.defaultDialog(
            title: "اختر احد الحسابات",
            content: SizedBox(
              height: Get.height/2,
              width:Get.height/1.5,
              child: ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        bondController.tempBondModel.bondRecord?[dataRowIndex].bondRecAccount = result[index];
                        var accId = accountController.accountList.values.toList().firstWhere((e) => e.accName == result[index]).accId;
                        // bondController.tempBondModel.bondRecord?[dataRowIndex].bondRecAccount=accId;
                        bondController.tempBondModel.bondRecord?.firstWhere((element) => element.bondRecId == rows[dataRowIndex].getCells()[0].value).bondRecAccount = accId;
                        // bondController.initPage(bondController.tempBondModel.bondType);
                        bondController.update();
                        Get.back();
                      },
                      child: Center(child: Text(result[index],style: TextStyle(fontSize: 20),)),
                    );
                  }),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("رجوع"))
            ]);
      }
    }

    if (column.columnName == Const.rowBondDescription) {
      // bondController.tempBondModel.bondRecord?[dataRowIndex].bondRecDescription=newCellValue;
      bondController.tempBondModel.bondRecord?.firstWhere((element) => element.bondRecId == rows[dataRowIndex].getCells()[0].value).bondRecDescription = newCellValue;
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<String>(columnName: column.columnName, value: newCellValue);
    }
    else if (column.columnName == Const.rowBondCreditAmount) {
      bondController.tempBondModel.bondRecord?.firstWhere((element) => element.bondRecId == rows[dataRowIndex].getCells()[0].value).bondRecCreditAmount = double.parse(newCellValue??"0");
      // bondController.tempBondModel.bondRecord?[dataRowIndex].bondRecCreditAmount=int.parse(newCellValue);
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<double>(columnName: column.columnName, value: double.parse(newCellValue??"0"));
    }
    else if (column.columnName == Const.rowBondDebitAmount) {
      bondController.tempBondModel.bondRecord?.firstWhere((element) => element.bondRecId.toString() == rows[dataRowIndex].getCells()[0].value.toString()).bondRecDebitAmount = double.parse(newCellValue??"0");
      // bondController.tempBondModel.bondRecord?[dataRowIndex].bondRecDebitAmount=int.parse(newCellValue);
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<double>(columnName: column.columnName, value: double.parse(newCellValue??"0"));
    }
    bondController.initTotal();
    bondController.isEdit = true;
    bondController.update();

    if (dataGridRows.length == dataRowIndex + 1) {
      addItem(isDebit);
    }
  }

  // description
  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    return true;
 //  return super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    FocusNode focusNodeListener = FocusNode();
    var displayText = dataGridRows[rowColumnIndex.rowIndex].getCells()[rowColumnIndex.columnIndex].value;
    displayText ??= '';
    if(displayText.toString()=="0.0")displayText="";

    newCellValue = null;
    editingController.text = displayText.toString();
    final bool isNumericType = column.columnName == Const.rowBondId || column.columnName == Const.rowBondCreditAmount || column.columnName == Const.rowBondDebitAmount;

    // Holds regular expression pattern based on the column type.
    // final RegExp regExp = _getRegExp(isNumericType, column.columnName);
    FocusNode focusNode = FocusNode();
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: KeyboardListener(
        focusNode: focusNodeListener,
        onKeyEvent: (_){
          if(_.physicalKey == PhysicalKeyboardKey.enter||_.physicalKey == PhysicalKeyboardKey.numpadEnter){
            if(!isNumericType){
              newCellValue = editingController.text;
              onCellSubmitFun( dataGridRow,  rowColumnIndex,  column,);
              bondController.dataGridController.endEdit();
            } else {
              if(double.tryParse(editingController.text)!=null){
                newCellValue = editingController.text;
                onCellSubmitFun( dataGridRow,  rowColumnIndex,  column,);
                bondController.dataGridController.endEdit();
              }else{
                Get.snackbar("error", "enter a valid number");
                newCellValue = null;
              }
            }
            focusNode.unfocus();
          }
        },
        child: TextField(
          focusNode: focusNode,
          autofocus: true,
          controller: editingController,
          textAlign: TextAlign.center,
          autocorrect: false,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
          ),
          //inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(regExp)],
          keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
          onChanged: (String value) {
            if (value.isNotEmpty) {
              newCellValue = value;
            } else {
              newCellValue = null;
            }
          },
          onSubmitted: (String value) {
            if(!isNumericType){
              newCellValue = value;
              onCellSubmitFun( dataGridRow,  rowColumnIndex,  column,);
              bondController.dataGridController.endEdit();
            } else {
              if(double.tryParse(value)!=null){
                newCellValue = value;
                onCellSubmitFun( dataGridRow,  rowColumnIndex,  column,);
                bondController.dataGridController.endEdit();
              }else{
                Get.snackbar("error", "enter a valid number");
                newCellValue = null;
              }
            }
          },
        ),
      ),
    );
  }

  RegExp _getRegExp(bool isNumericKeyBoard, String columnName) {
    return isNumericKeyBoard ? RegExp(r'\b\d+\.\d+\b') : RegExp(r'.*');
  }

  late List<AccountModel> products = <AccountModel>[];

  List<String> searchText(String query) {
    AccountViewModel accountController = Get.find<AccountViewModel>();
    products = accountController.accountList.values.toList().where((item) {
      var name = item.accName.toString().toLowerCase().contains(query.toLowerCase());
      var code = item.accCode.toString().toLowerCase().contains(query.toLowerCase());
      var type = item.accType==Const.accountTypeDefault;
      return type&&(name || code);
    }).toList();
    return products.map((e) => e.accName!).toList();
  }
}
