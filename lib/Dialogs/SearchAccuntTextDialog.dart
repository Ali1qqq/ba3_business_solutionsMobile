import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Widgets/new_Pluto.dart';
import '../view/invoices/widget/custom_TextField.dart';

Future<String?> searchAccountTextDialog(String accountText)async {

  TextEditingController accountTextController=TextEditingController()..text=accountText;

  List<AccountModel> accountsForSearch;
  accountsForSearch=Get.find<AccountViewModel>().searchAccount(accountTextController.text);
  if(accountsForSearch.length==1) {
    return accountsForSearch.first.accName!;
  }else if(accountsForSearch.isEmpty) {
    return null;
  }
  await showDialog<String>(
      context: Get.context!,
      builder: (BuildContext context) => Dialog(
        child: GetBuilder<AccountViewModel>(builder: (accountViewModel) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    height: Get.height / 1.5,
                    child: ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(15),
                      child: CustomPlutoGridWithAppBar(
                        onSelected: (selected) {
                          accountTextController.text=selected.row?.cells["اسم الحساب"]!.value;
                          Get.back();
                        },
                        title: "اختيار حساب",
                        modelList: accountsForSearch,
                        onLoaded: (p0) {},
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextFieldWithIcon(controller: accountTextController,        onSubmitted:(_) async {
                    accountViewModel.update();
                  }, onIconPressed: () {}),
                ),
                const SizedBox(
                  height: 10,
                ),

              ],
            ),
          );
        }),
      )



  );

  return accountTextController.text;
}
