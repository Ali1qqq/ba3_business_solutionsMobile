import 'package:ba3_business_solutions/controller/invoice_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Const/const.dart';
import '../../Widgets/Discount_Pluto_Edit_View_Model.dart';
import '../../Widgets/Invoice_Pluto_Edit_View_Model.dart';
import '../../Widgets/new_Pluto.dart';
import 'New_Invoice_View.dart';

class AllInvoice extends StatelessWidget {
  const AllInvoice({super.key, required this.listDate, required this.productName});

  final List<String> listDate;
  final String? productName;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceViewModel>(builder: (controller) {
      return CustomPlutoGridWithAppBar(
        title: "جميع الفواتير",
        type: Const.globalTypeInvoice,
        onLoaded: (e) {},
        onSelected: (p0) {
          print(p0.row?.cells["الرقم التسلسلي"]?.value);
          Get.to(
            () => InvoiceView(
              billId: p0.row?.cells["الرقم التسلسلي"]?.value,
              patternId: p0.row?.cells["النمط"]?.value,
            ),
            binding: BindingsBuilder(() {
              Get.lazyPut(() => InvoicePlutoViewModel());
              Get.lazyPut(() => DiscountPlutoViewModel());
            }),
          );
          /*   Get.to(() => InvoiceView(
                billId: p0.row?.cells["الرقم التسلسلي"]?.value,
                patternId: "",
              ));*/
        },
        modelList: controller.invoiceModel.values.where(
          (element) {
            if (!HiveDataBase.getWithFree() && getPatTypeFromId(element.patternId!) == Const.invoiceTypeBuy) {
              return element.invRecords!.where(
                (element) {
                  return getProductModelFromId(element.invRecProduct)?.prodIsLocal == false;
                },
              ).isEmpty;
            } else {
              return true;
            }
          },
        ).where(
          (element) {
            if (productName != null && productName != "") {
              return listDate.contains((element.invDate?.split(" ")[0] ?? "")) &&
                  (element.invRecords
                          ?.where(
                            (invRecord) => invRecord.invRecProduct == productName,
                          )
                          .isNotEmpty ??
                      false);
            } else {
              return listDate.contains((element.invDate?.split(" ")[0] ?? ""));
            }
          },
        ).toList(),
      );
    });
  }
}

/* FilteringDataGrid<GlobalModel>(
        title: "الفواتير",
        constructor: GlobalModel(),
        dataGridSource: data,
        globalType: Const.globalTypeInvoice,
        onCellTap: (index,id,init) {
          GlobalModel model = data[id]!;
          logger(newData: model, transfersType: TransfersType.read);
          Get.to(() => InvoiceView(
            billId: model.invId!,
            patternId: "",
          ));
        },
        init: () async {
          IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
          isolateViewModel.init();
          print("from invoice View");
          final a = await compute<({List<dynamic> invoiceModel,IsolateViewModel isolateViewModel}),List<DataGridRow>>((message) {
            Get.put(message.isolateViewModel);
            List<DataGridRow> dataGridRow  = message.invoiceModel
                .map<DataGridRow>((order) => DataGridRow(cells: [
              DataGridCell(columnName: order.affectedKey(), value: order.affectedId()),
              ...order!.toMap().entries.map((mapEntry) {

                  return DataGridCell<String>(columnName: mapEntry.key, value: mapEntry.value.toString());

              }).cast<DataGridCell<dynamic>>().toList()
            ])).toList();
            return dataGridRow;
          },(invoiceModel: data.values.toList(),isolateViewModel:isolateViewModel));
          InfoDataGridSource  infoDataGridSource = InfoDataGridSource();
          infoDataGridSource.dataGridRows =a;
          return infoDataGridSource;
        },
      )*/
