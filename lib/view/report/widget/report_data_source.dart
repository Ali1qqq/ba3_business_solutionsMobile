import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Const/const.dart';
import '../../../controller/account_view_model.dart';
import '../../../controller/pattern_model_view.dart';
import '../../../controller/product_view_model.dart';
import '../../../controller/sellers_view_model.dart';
import '../../../controller/store_view_model.dart';

class ReportDataSource extends DataGridSource {
  ReportDataSource(List employees, List<String> rowList) {
    buildDataGridRows(employees, rowList);
  }

  List<DataGridRow> datagridRows = [];
  List<String> rowList = [];
  String tab = "	";
  RegExp isArabic = RegExp(r"[\u0600-\u06FF]");

  @override
  List<DataGridRow> get rows => datagridRows;

  void buildDataGridRows(List employeesData, List<String> rowList) {
    this.rowList = rowList;
    datagridRows = employeesData.map<DataGridRow>((e) => DataGridRow(cells: rowList.map((ea) => DataGridCell<String>(columnName: ea, value: getData(e[ea].toString()))).toList())).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dataGridCell.columnName == rowList.first
                        ? '${dataGridCell.value}\n'
                        : dataGridCell.value.toString() + tab,
                    overflow: TextOverflow.ellipsis,
                      textDirection: isArabic.hasMatch(dataGridCell.value.toString()) ?TextDirection.rtl:TextDirection.ltr,
                      style: const TextStyle(fontSize: 12),
                      maxLines: null,),
                  ],
                ),
              ),
            ],
          );
        }).toList());
  }

  String getData(dynamic text) {

    if (text =="null") {
      return " ";
    } else  if (text ==" ") {
      return " ";
    } else  if (text =="") {
      return " ";
    } else if (checkIsID("acc",text)) {
      return getAccountNameFromId(text);
    } else if (checkIsID("prod",text)) {
      return getProductNameFromId(text);
    } else if (checkIsID("seller",text)) {
      return getSellerNameFromId(text)??'';
    } else if (checkIsID("store",text)) {
      return getStoreNameFromId(text);
    } else if (checkIsID("pat",text)) {
      return getPatModelFromPatternId(text).patName!;
    } else if(double.tryParse(text)!=null){
      return double.parse(text).toStringAsFixed(2);
    } else if(text =="true"){
      return "نعم";
    }else if(text =="false"){
      return "لا";
    }else{
      String _ = getInvTypeFromEnum(text);
      _ = getProductTypeFromEnum(text);

      return _;
    }
  }
  bool checkIsID(id,text){
    RegExp _ = RegExp("$id+[0-9]+");
    return _.hasMatch(text);
  }
}