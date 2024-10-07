
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Const/const.dart';
import '../../Widgets/new_Pluto.dart';
import '../../Widgets/warranty_pluto_view_model.dart';
import 'Controller/warranty_view_model.dart';
import 'Warranty_View.dart';

class AllWarrantyInvoices extends StatelessWidget {
  const AllWarrantyInvoices({super.key});



  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarrantyViewModel>(builder: (controller) {
      return CustomPlutoGridWithAppBar(
        title: "جميع فواتير الضمان",
        onLoaded: (e) {},
        onSelected: (p0) {

          Get.to(()=>WarrantyInvoiceView(billId: p0.row?.cells["invId"]?.value,),
              binding: BindingsBuilder(
                    () => Get.lazyPut(
                      () => WarrantyPlutoViewModel(),
                ),
              ));

          /*   Get.to(() => InvoiceView(
                billId: p0.row?.cells["الرقم التسلسلي"]?.value,
                patternId: "",
              ));*/
        },
        modelList: controller.warrantyMap.values.toList(),
      );
    });
  }
}

