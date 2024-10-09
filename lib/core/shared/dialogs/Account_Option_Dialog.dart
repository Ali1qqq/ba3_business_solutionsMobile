import 'package:ba3_business_solutions/controller/account/account_view_model.dart';
import 'package:ba3_business_solutions/core/constants/app_strings.dart';
import 'package:ba3_business_solutions/core/shared/dialogs/SearchAccuntTextDialog.dart';
import 'package:ba3_business_solutions/main.dart';
import 'package:ba3_business_solutions/model/account/account_model.dart';
import 'package:ba3_business_solutions/view/invoices/pages/New_Invoice_View.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view/accounts/pages/account_details.dart';
import '../../../view/invoices/Controller/Search_View_Controller.dart';
import '../../helper/functions/functions.dart';
import '../../services/Get_Date_From_String.dart';
import '../widgets/option_text_widget.dart';

class AccountOptionDialog extends StatelessWidget {
  const AccountOptionDialog({
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
                title: AppStrings.accountName.tr,
                controller: controller.accountForSearchController,
                onSubmitted: (text) async {
                  controller.accountForSearchController.text =
                      await searchAccountTextDialog(
                              controller.accountForSearchController.text) ??
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
                  AccountModel? model = getAccountModelFromName(
                      controller.accountForSearchController.text);
                  if (model != null) {
                    List<String> listDate = getDatesBetween(
                        DateTime.parse(
                            controller.startDateForSearchController.text),
                        DateTime.parse(
                            controller.endDateForSearchController.text));

                    Get.to(() => AccountDetails(
                          modelKey: model.accChild
                                  .map(
                                    (e) => e.toString(),
                                  )
                                  .toList() +
                              [model.accId!],
                          listDate: listDate,
                        ));
                  } else {
                    Get.snackbar(AppStrings.inputError.tr,
                        AppStrings.inputAccountErrorMessage.tr,
                        icon: const Icon(Icons.error_outline));
                  }
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
