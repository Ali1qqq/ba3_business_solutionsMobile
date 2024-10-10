import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/invoice/Search_View_Controller.dart';
import '../../../main.dart';
import '../../../view/invoices/pages/New_Invoice_View.dart';
import '../../../view/invoices/pages/all_invoices.dart';
import '../../constants/app_strings.dart';
import '../../helper/functions/functions.dart';
import '../../services/Get_Date_From_String.dart';
import '../widgets/option_text_widget.dart';
import 'Search_Product_Text_Dialog.dart';

class InvoiceOptionDialog extends StatelessWidget {
  const InvoiceOptionDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backGroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<SearchViewController>(builder: (controller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(AppStrings.displayOptions.tr),
              const SizedBox(height: 15),
              OptionTextWidget(
                title: AppStrings.item.tr,
                controller: controller.productForSearchController,
                onSubmitted: (text) async {
                  controller.productForSearchController.text =
                      await searchProductTextDialog(
                              controller.productForSearchController.text) ??
                          "";
                  controller.update();
                },
              ),
              OptionTextWidget(
                title: AppStrings.fromDate.tr,
                controller: controller.startDateForSearchController,
                onSubmitted: (text) async {
                  controller.startDateForSearchController.text =
                      getDateFromString(text);
                  controller.update();
                },
              ),
              OptionTextWidget(
                title: AppStrings.toDate.tr,
                controller: controller.endDateForSearchController,
                onSubmitted: (text) async {
                  controller.endDateForSearchController.text =
                      getDateFromString(text);
                  controller.update();
                },
              ),
              AppButton(
                title: AppStrings.confirm.tr,
                iconData: Icons.check,
                onPressed: () {
                  Get.to(() => AllInvoice(
                      listDate: getDatesBetween(
                          DateTime.parse(
                              controller.startDateForSearchController.text),
                          DateTime.parse(
                              controller.endDateForSearchController.text)),
                      productName: getProductIdFromName(
                          controller.productForSearchController.text)));
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
