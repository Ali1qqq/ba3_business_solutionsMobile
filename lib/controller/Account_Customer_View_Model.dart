import 'package:ba3_business_solutions/model/AccountCustomer.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:get/get.dart';

class AccountCustomerViewModel extends  GetxController{


  Map<String,AccountCustomer> customerMap={};
  AccountCustomerViewModel(){
    for (var element in HiveDataBase.accountCustomerBox.values) {
      customerMap[element.customerAccountId!]=element;
    }}
}