import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/invoice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Widgets/Invoice_Pluto_Edit_View_Model.dart';
import '../../Widgets/new_Pluto.dart';
import '../../controller/account_view_model.dart';
import '../invoices/New_Invoice_View.dart';

class AllDueAccount extends StatelessWidget {

 final List<String>modelKey;
  const AllDueAccount({super.key,required this.modelKey});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountViewModel>(initState: (state) {
      // Get.find<AccountViewModel>().getAllBondForAccount(modelKey, );
      Get.find<AccountViewModel>().getAllDusAccount(modelKey, /*listDate*/);
    }, builder: (controller) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: CustomPlutoGridWithAppBar(
                title: "مستحقات ${getAccountNameFromId(modelKey.last)}",
                type: Const.typeAccountDueView,
                onLoaded: (e) {},
                onSelected: (p0) {

                    Get.to(
                          () => InvoiceView(
                        billId: p0.row?.cells["id"]?.value,
                        patternId: p0.row?.cells["نوع الفاتورة"]?.value,
                      ),
                      binding: BindingsBuilder(() {
                        Get.lazyPut(() => InvoicePlutoViewModel());
                      }),
                    );

                },
                // modelList: controller.currentViewAccount,
                modelList: controller.accountList[modelKey.last]?.accRecord.where((element) => element.balance!>0,).toList() ?? [],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "المجموع :",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 24),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    formatDecimalNumberWithCommas(controller.accountList[modelKey.last]?.finalBalance??0.0),
                    style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w600, fontSize: 32),
                  ),

                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
