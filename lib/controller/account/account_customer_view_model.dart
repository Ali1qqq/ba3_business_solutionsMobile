import 'package:ba3_business_solutions/model/account/account_customer.dart';
import 'package:ba3_business_solutions/core/utils/hive.dart';
import 'package:get/get.dart';

class AccountCustomerViewModel extends  GetxController{


  Map<String,AccountCustomer> customerMap={};
  AccountCustomerViewModel(){
    for (var element in HiveDataBase.accountCustomerBox.values) {
      customerMap[element.customerAccountId!]=element;
    }}
}