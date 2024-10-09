import 'package:ba3_business_solutions/controller/account/account_customer_view_model.dart';
import 'package:ba3_business_solutions/model/account/account_customer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<AccountCustomer> accountCustomerDialog(
    {String? text, List<AccountCustomer>? customers}) async {
  AccountCustomer customer = AccountCustomer(customerAccountName: "زبون كاش");
  if (customers != null) {
    customers = customers
        .where(
          (element) => element.customerAccountName
              .toString()
              .toLowerCase()
              .contains(text!.toLowerCase()),
        )
        .toList();
  } else {
    customers = Get.find<AccountCustomerViewModel>()
        .customerMap
        .values
        .where(
          (element) => element.customerAccountName
              .toString()
              .toLowerCase()
              .contains(text ?? "0"),
        )
        .toList();
  }

  // print(accountPickList.length);
  if (customers.length > 1) {
    await Get.defaultDialog(
      title: "Chose form dialog",
      content: SizedBox(
        width: 500,
        height: 500,
        child: ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                customer = customers![index];
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(8),
                width: 500,
                child: Center(
                  child: Text(
                    customers![index].customerAccountName!,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  } else if (customers.length == 1) {
    customer = customers[0];
  } else {
    Get.snackbar("فحص المطاييح", "هذا المطيح غير موجود من قبل");
  }
  return customer;
}
