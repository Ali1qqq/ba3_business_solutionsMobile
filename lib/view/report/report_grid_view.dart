import 'package:ba3_business_solutions/controller/invoice_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/view/report/widget/report_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../model/invoice_record_model.dart';

class ReportGridView extends StatefulWidget {
  const ReportGridView({Key? key}) : super(key: key);

  @override
  ReportGridViewState createState() => ReportGridViewState();
}

class ReportGridViewState extends State<ReportGridView> {
  String tab = "	";

  late ReportDataSource _DataSource;
  List _dataList = [];
  List<String> rowList = [];
  Map nameRowList = {
    'invTotal': "إجمالي الفاتورة",
    'invPrimaryAccount': "الحساب الاساسي",
    'invSecondaryAccount': "الحساب الثانوي",
    'invStorehouse': "المستودع",
    'invComment': "بيان الفاتورة",
    'invCode': "رمز الفاتورة",
    'invFullCode': "رمز الفاتورة الكامل",
    'patternId': "نوع الفاتورة",
    'invSeller': "اسم البائع",
    'invDate': "تاريخ الفاتورة",
    'invMobileNumber': "رقم جوال الزبون",
    'invVatAccount': "حساب الضريبة",
    'invCustomerAccount': "حساب الزبون",
    'invRecProduct': "اسم المادة",
    'invRecQuantity': "الكمية",
    'invRecGift': "الهدايا",
    'invRecSubTotal': "السعر الإفرادي",
    'invRecTotal': "إجمالي القيمة",
    'invRecVat': "إجمالي الضريبة",
    "bondCode": "رمز السند المولد",
    'prodName': "اسم المادة",
    'prodCode': "كود للمادة",
    'prodCustomerPrice': "سعر المستهلك ",
    'prodWholePrice': "سعر الجملة ",
    'prodRetailPrice': "سعر المفرق",
    'prodCostPrice': "سعر التكلفة",
    'prodMinPrice': "اقل سعر مسموح",
    'prodHasVat': "هل يحوي ضريبة",
    'prodBarcode': "باركود المادة",
    'prodGroupCode': "رمز الاب للمادة",
    'prodType': "نوع المادة",
    'prodParentId': "اسم الاب للمادة",
  'discountTotal':"مجموع الحسم",
  };
  late SelectionManagerBase selectionManagerBase;
  ScrollController scrollController = ScrollController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    InvoiceViewModel invoiceController = Get.find<InvoiceViewModel>();
    for (var element in invoiceController.invoiceModel.values) {
      for (InvoiceRecordModel et in element.invRecords ?? []) {
        if (et.invRecProduct != null) {
          if( getProductModelFromId(et.invRecProduct)!=null) {
            Map productMap = getProductModelFromId(et.invRecProduct)?.toJson();
            Map m = element.toJson();
            m.addAll(et.toJson());
            m.addAll(productMap);

            _dataList.add(m);
          }
        }
      }
    }
    rowList = ["invDate", "invFullCode", "invCustomerAccount", "invRecProduct", "invRecQuantity", "invRecGift", "invRecSubTotal", "invRecVat", "invRecTotal", "invStorehouse", "invSeller", "invSecondaryAccount"];
    initPage();
  }

  void initPage() {
    _DataSource = ReportDataSource(_dataList, rowList);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('تقرير المبيعات'),
          actions: [
            ElevatedButton(onPressed: () => bottomSheet(scaffoldKey), child: Text("إضافة حقول")),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(onPressed: copyAll, child: Text("نسخ الكل")),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        body: SelectionArea(
          onSelectionChanged: (SelectedContent? selectedContent) {
            print(selectedContent?.plainText);
          },
          child: SfDataGrid(
            selectionMode: SelectionMode.none,
            source: _DataSource,
            isScrollbarAlwaysShown: true,
            verticalScrollController: scrollController,
            columns: rowList
                .map((e) => GridColumn(
                    // width: 150,
                    columnWidthMode: ColumnWidthMode.auto,
                    columnName: e,
                    label: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e == rowList.first ? nameRowList[e.toString()] + '\n' : nameRowList[e.toString()] + tab,
                                textDirection: isArabic.hasMatch(e.toString()) ? TextDirection.rtl : TextDirection.ltr,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )))
                .toList(),
            columnWidthMode: ColumnWidthMode.fill,
          ),
        ),
      ),
    );
  }

  void copyAll() {
    String _ = "";
    _DataSource.rowList.forEach((element) {
      if (element == rowList.last) {
        _ = _ + nameRowList[element.toString()] + "\n";
      } else {
        _ = _ + nameRowList[element.toString()] + tab;
      }
    });
    _DataSource.datagridRows.map((e) => e.getCells()).forEach((element) {
      for (var element in element) {
        if (element.columnName == rowList.last) {
          _ = _ + element.value.toString() + "\n";
        } else {
          _ = _ + element.value.toString() + tab;
        }
      }
    });
    Clipboard.setData(ClipboardData(text: _));
    Get.snackbar("عملية ناجحة", "تم النسخ بنجاح");
  }

  RegExp isArabic = RegExp(r"[\u0600-\u06FF]");

  bottomSheet(GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState?.showBottomSheet((context) => Container(
          height: MediaQuery.sizeOf(context).height / 1.2,
          child: StatefulBuilder(builder: (context, setstate) {
            return ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Text("أختر الحقل المطلوب"),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("إغلاق"))
                    ],
                  ),
                ),
                ...nameRowList.keys.toList().map(
                  (allRowElement) {
                    return ListTile(
                      leading: Checkbox(
                        value: rowList.contains(allRowElement),
                        onChanged: (bool? value) {
                          if (value!) {
                            rowList.add(allRowElement);
                          } else {
                            rowList.remove(allRowElement);
                          }
                          initPage();
                          setstate(() {});
                          setState(() {});
                        },
                      ),
                      title: Text(nameRowList[allRowElement]),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            );
          }),
        ));
  }
}
