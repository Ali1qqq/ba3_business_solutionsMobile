import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../Const/const.dart';
import '../../../controller/account_view_model.dart';
import '../../../model/account_model.dart';


class EntryBondRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  dynamic newCellValue;
  dynamic newCellValuea;
  TextEditingController editingController = TextEditingController();

  EntryBondRecordDataSource({required GlobalModel recordData}) {
    buildRowInit(recordData);
    addItem();
  }
  final accountController = Get.find<AccountViewModel>();

  buildRowInit(GlobalModel recordData) {
    dataGridRows = (recordData.entryBondRecord ?? [])
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: Const.rowBondId, value: e.bondRecId),
              DataGridCell<String>(columnName: Const.rowBondAccount, value: accountController.accountList.values.toList().firstWhereOrNull((_) => _.accId == e.bondRecAccount)?.accName),
              DataGridCell<double>(columnName: Const.rowBondDebitAmount, value: e.bondRecDebitAmount),
              DataGridCell<double>(columnName: Const.rowBondCreditAmount, value: e.bondRecCreditAmount),
              DataGridCell<String>(columnName: Const.rowBondDescription, value: e.bondRecDescription),
            ]))
        .toList();
  }

  void addItem() {
    dataGridRows.add(const DataGridRow(cells: [
      DataGridCell<String>(columnName: Const.rowBondId, value: ""),
      DataGridCell<String>(columnName: Const.rowBondAccount, value: ''),
      DataGridCell<double>(columnName: Const.rowBondCreditAmount, value: null),
      DataGridCell<double>(columnName: Const.rowBondDebitAmount, value: null),
      DataGridCell<String>(columnName: Const.rowBondDescription, value: ""),
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
            dataGridCell.value == null
                ? ''
                : dataGridCell.value.runtimeType == double
                    ? dataGridCell.value.toStringAsFixed(2)
                    : dataGridCell.value.toString(),
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

  // Future<void> submitCella(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column,) async {
  //   final dynamic oldValue = dataGridRow.getCells().firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == column.columnName)?.value ?? '';
  //   final int dataRowIndex = rowColumnIndex.rowIndex;
  //   print(newCellValuea);
  //   print(newCellValuea);
  //   // if(dataRowIndex==-1){
  //   //   return;
  //   // }
  //   print(dataGridRows.map((e) => e.getCells().map((e) => e.value)));
  //   if (newCellValue == null || oldValue == newCellValue) {
  //     print("you input null value");
  //   }
  //   if (dataGridRows.length == dataRowIndex + 1) {
  //     var id = (int.parse(dataGridRows[dataRowIndex - 1].getCells()[0].value) + 1).toString();
  //     if (int.parse(id) < 10) id = "0$id";
  //     dataGridRows[dataRowIndex].getCells()[0] = DataGridCell<String>(columnName: Const.rowBondId, value: id);
  //     bondController.tempBondModel.bondRecord?.add(BondRecordModel(id, 0, 0, '', ''));
  //   }
  //   if (column.columnName == Const.rowBondDebitAmount || column.columnName == Const.rowBondCreditAmount) {
  //     if (column.columnName == Const.rowBondDebitAmount) {
  //       if (dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex + 1].value == null || dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex + 1].value == 0) {
  //         dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<double>(columnName: column.columnName, value: double.tryParse(newCellValue??"0"));
  //         bondController.tempBondModel.bondRecord![dataRowIndex].bondRecDebitAmount = double.parse(newCellValue??"0");
  //       } else {
  //         dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<double>(columnName: column.columnName, value: 0);
  //         bondController.tempBondModel.bondRecord![dataRowIndex].bondRecDebitAmount = 0;
  //         if (newCellValue != "0") {
  //           Get.defaultDialog(middleText: "debit or credit should be 0");
  //         }
  //       }
  //     } else {
  //       if (dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex - 1].value == null || dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex - 1].value == 0) {
  //         dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<double>(columnName: column.columnName, value: double.tryParse(newCellValue??"0"));
  //         bondController.tempBondModel.bondRecord![dataRowIndex].bondRecCreditAmount = double.parse(newCellValue??"0");
  //       } else {
  //         dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<double>(columnName: column.columnName, value: 0);
  //         bondController.tempBondModel.bondRecord![dataRowIndex].bondRecCreditAmount = 0;
  //         if (newCellValue != "0") {
  //           Get.defaultDialog(middleText: "debit or credit should be 0");
  //         }
  //       }
  //     }
  //   } else {
  //     if (column.columnName == Const.rowBondAccount) {
  //       print(newCellValue.toString());
  //       print(newCellValue.toString());
  //       print(dataRowIndex);
  //       List<String> result = searchText(newCellValue.toString());
  //       print(result);
  //       print(result);
  //       if (result.isEmpty) {
  //         Get.snackbar("خطأ", "الحساب غير موجود");
  //       } else if (result.length == 1) {
  //         var name = result[0];
  //         dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<String>(columnName: column.columnName, value: name);
  //         var accId = accountController.accountList.values.toList().firstWhere((e) => e.accName == name).accId;
  //         bondController.tempBondModel.bondRecord?[dataRowIndex].bondRecAccount = accId;
  //         bondController.update();
  //       } else {
  //         await Get.defaultDialog(
  //             title: "اختر احد الحسابات",
  //             content: SizedBox(
  //               height: Get.height/2,
  //               width:Get.height/2,
  //               child: ListView.builder(
  //                   itemCount: result.length,
  //                   itemBuilder: (_, index) {
  //                     return InkWell(
  //                       onTap: () {
  //                         bondController.tempBondModel.bondRecord?[dataRowIndex].bondRecAccount = result[index];
  //                         var accId = accountController.accountList.values.toList().firstWhere((e) => e.accName == result[index]).accId;
  //                         bondController.tempBondModel.bondRecord?[dataRowIndex].bondRecAccount = accId;
  //                         bondController.initPage(bondController.tempBondModel.bondType);
  //                         Get.back();
  //                       },
  //                       child: Center(child: Text(result[index],style: TextStyle(fontSize: 20),)),
  //                     );
  //                   }),
  //             ),
  //             actions: [
  //               ElevatedButton(
  //                   onPressed: () {
  //                     Get.back();
  //                   },
  //                   child: Text("رجوع"))
  //             ]);
  //       }
  //     }
  //     if (column.columnName == Const.rowBondDescription) {
  //       bondController.tempBondModel.bondRecord?[dataRowIndex].bondRecDescription = newCellValue;
  //       dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<String>(columnName: column.columnName, value: newCellValue);
  //     }
  //   }

  //   double debit = 0;
  //   double credit = 0;
  //   bondController.tempBondModel.bondTotal = "0";
  //   for (var element in bondController.tempBondModel.bondRecord!) {
  //     debit = debit + (element.bondRecDebitAmount ?? 0);
  //     credit = credit + (element.bondRecCreditAmount ?? 0);
  //   }
  //   bondController.tempBondModel.bondTotal = (debit - credit).toString();
  //   bondController.isEdit = true;
  //   bondController.update();

  //   if (dataGridRows.length == dataRowIndex + 1) {
  //     addItem();
  //   }
  // }

  // description
  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    // Return false, to retain in edit mode.
    return false; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }

  // @override
  // Widget? buildEditWidget(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
  //   FocusNode focusNodeListener = FocusNode();
  //   var displayText = dataGridRows[rowColumnIndex.rowIndex].getCells()[rowColumnIndex.columnIndex].value;
  //   displayText ??= '';
  //   if(displayText.toString()=="0.0")displayText="";

  //   newCellValue = null;
  //   editingController.text = displayText.toString();
  //   final bool isNumericType = column.columnName == Const.rowBondId || column.columnName == Const.rowBondCreditAmount || column.columnName == Const.rowBondDebitAmount;

  //   // Holds regular expression pattern based on the column type.
  //   final RegExp regExp = _getRegExp(isNumericType, column.columnName);
  //   FocusNode focusNode = FocusNode();
  //   return Container(
  //     padding: const EdgeInsets.all(8.0),
  //     alignment: Alignment.center,
  //     child: KeyboardListener(
  //       focusNode: focusNodeListener,
  //       onKeyEvent: (_){
  //         if(_.physicalKey == PhysicalKeyboardKey.enter||_.physicalKey == PhysicalKeyboardKey.numpadEnter){
  //           if(!isNumericType){
  //             newCellValue = editingController.text;
  //             submitCella( dataGridRow,  rowColumnIndex,  column,);
  //             bondController.dataGridController.endEdit();
  //           } else {
  //             if(double.tryParse(editingController.text)!=null){
  //               newCellValue = editingController.text;
  //               submitCella( dataGridRow,  rowColumnIndex,  column,);
  //               bondController.dataGridController.endEdit();
  //             }else{
  //               Get.snackbar("error", "enter a valid number");
  //               newCellValue = null;
  //             }
  //           }
  //           focusNode.unfocus();
  //         }
  //       },
  //       child: TextField(
  //         focusNode: focusNode,
  //         autofocus: true,
  //         controller: editingController,
  //         textAlign: TextAlign.center,
  //         autocorrect: false,
  //         decoration: const InputDecoration(
  //           contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
  //         ),
  //         //inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(regExp)],
  //         keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
  //         onChanged: (String value) {
  //           if (value.isNotEmpty) {
  //             newCellValue = value;
  //           } else {
  //             newCellValue = null;
  //           }
  //         },
  //         onSubmitted: (String value) {
  //           if(!isNumericType){
  //             newCellValue = value;
  //             submitCella( dataGridRow,  rowColumnIndex,  column,);
  //             bondController.dataGridController.endEdit();
  //           } else {
  //             if(double.tryParse(value)!=null){
  //               newCellValue = value;
  //               submitCella( dataGridRow,  rowColumnIndex,  column,);
  //               bondController.dataGridController.endEdit();
  //             }else{
  //               Get.snackbar("error", "enter a valid number");
  //               newCellValue = null;
  //             }
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }

  // @override
  // Widget? buildEditWidget(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
  //   var displayText = dataGridRows[rowColumnIndex.rowIndex].getCells()[rowColumnIndex.columnIndex].value;
  //   displayText ??= '';
  //   if(displayText.toString()=="0.0")displayText="";
  //   newCellValue = null;
  //
  //   final bool isNumericType = column.columnName == Const.rowBondId || column.columnName == Const.rowBondCreditAmount || column.columnName == Const.rowBondDebitAmount;
  //   final RegExp regExp = _getRegExp(isNumericType, column.columnName);
  //   FocusNode focusNode=FocusNode();
  //   return Container(
  //     padding: const EdgeInsets.all(8.0),
  //     alignment: Alignment.center,
  //     child: TextFormField(
  //       focusNode: focusNode,
  //       autofocus: true,
  //       controller: editingController..text = displayText.toString(),
  //       textAlign: TextAlign.center,
  //       autocorrect: false,
  //       decoration: const InputDecoration(
  //         contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
  //       ),
  //       //  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(regExp)],
  //       keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
  //       onChanged: (String value) {
  //         if (value.isNotEmpty) {
  //           newCellValue = value;
  //         } else {
  //          // newCellValue = null;
  //         }
  //       },
  //       onFieldSubmitted: (String value) {
  //         if(column.columnName == Const.rowBondDebitAmount||column.columnName == Const.rowBondCreditAmount){
  //           if (double.tryParse(value) != null) {
  //             newCellValue = value;
  //             bondController.dataGridController.endEdit();
  //             submitCella(dataGridRow, rowColumnIndex, column,);
  //           } else {
  //             Get.snackbar("خطأ", "يرجى إدخال رقم صحيح");
  //             newCellValue = null;
  //           }
  //         }else{
  //           newCellValue = value;
  //           bondController.dataGridController.endEdit();
  //           submitCella(dataGridRow, rowColumnIndex, column,);
  //         }
  //       },
  //     ),
  //   );
  // }

  RegExp _getRegExp(bool isNumericKeyBoard, String columnName) {
    // return isNumericKeyBoard ? RegExp(r"(\d+)?\.(\d+)?") : RegExp(r'.*');
    return isNumericKeyBoard ? RegExp(r'\b\d+\.\d+\b') : RegExp(r'.*');
  }

  late List<AccountModel> products = <AccountModel>[];

  List<String> searchText(String query) {
    AccountViewModel accountController = Get.find<AccountViewModel>();
    products = accountController.accountList.values.toList().where((item) {
      var name = item.accName.toString().toLowerCase().contains(query.toLowerCase());
      var code = item.accCode.toString().toLowerCase().contains(query.toLowerCase());
      // var type = item.accType==Const.accountTypeDefault;
      return (name || code);
    }).toList();
    return products.map((e) => e.accName!).toList();
  }
}
