import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/invoice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Widgets/Invoice_Pluto_Edit_View_Model.dart';
import '../../Widgets/new_Pluto.dart';
import '../invoices/New_Invoice_View.dart';

class AllPartnerDueAccount extends StatelessWidget {
  const AllPartnerDueAccount({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<InvoiceViewModel>(
        builder: (controller) {
          return  CustomPlutoGridWithAppBar(
            type: Const.globalTypeAccountDue,
            title: "الفواتير المستحقة على الشركاء",
            onLoaded: (e){
            },
            onSelected: (p0) {

              // Get.to(() =>  AddAccount(  modelKey: p0.row?.cells["accId"]?.value,oldParent:(p0.row?.cells["حساب الاب"]?.value) ,));
              // Get.to(() => AccountDetails(
              //   modelKey: p0.row?.cells["accId"]?.value,
              // ));
              Get.to(() => InvoiceView(
                billId:p0.row?.cells["الرقم التسلسلي"]?.value,
                patternId: "",
                
              ),binding: BindingsBuilder(() =>Get.lazyPut(()=>InvoicePlutoViewModel()) ,));
            },
            modelList: controller.invoiceModel.values.where((element){
              return element.invIsPaid==false&&element.invType==Const.invoiceTypeSalesWithPartner;
            },).toList(),

          );
        }
    );
/*    return Scaffold(
      body: FilteringDataGrid<AccountModel>(
        title: "الحسابات",
        constructor: AccountModel(),
        dataGridSource: data,
        onCellTap: (index,id,init) {

          AccountModel model = data[id]!;
          logger(newData: model, transfersType: TransfersType.read);
          Get.to(() => AccountDetails(
            initFun:init,
            modelKey: model.accId!,
          ));
        },
        init: () async {
          IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
          isolateViewModel.init();
          final a = await compute<({IsolateViewModel isolateViewModel}),List<DataGridRow>>((message) {
            Get.put(message.isolateViewModel);
            List<DataGridRow> dataGridRow  = message.isolateViewModel.accountList.values.toList()
                .map<DataGridRow>((order) => DataGridRow(cells: [
              DataGridCell(columnName: order.affectedKey()!, value: order.affectedId()),
              ...order.toMap().entries.map((mapEntry) {
                if (int.tryParse(mapEntry.value.toString()) != null) {
                  return DataGridCell<int>(columnName: mapEntry.key, value: int.parse(mapEntry.value.toString()));
                } else if (double.tryParse(mapEntry.value.toString()) != null) {
                  return DataGridCell<double>(columnName: mapEntry.key, value: double.parse(double.parse(mapEntry.value.toString()).toStringAsFixed(2)));
                }else if(DateTime.tryParse(mapEntry.value.toString())!=null){
                  return DataGridCell<DateTime>(columnName: mapEntry.key, value: DateTime.parse(mapEntry.value.toString()));
                }else{
                  return DataGridCell<String>(columnName: mapEntry.key, value: mapEntry.value.toString());
                }
              }).cast<DataGridCell<dynamic>>().toList()
            ])).toList();
            return dataGridRow;
          },(isolateViewModel:isolateViewModel));
          InfoDataGridSource  infoDataGridSource = InfoDataGridSource();
          infoDataGridSource.dataGridRows =a;
          return infoDataGridSource;
        },
      ),
    );*/
  }
}
