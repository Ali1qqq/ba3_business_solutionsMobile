import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchViewController extends GetxController {
  TextEditingController productForSearchController = TextEditingController();
  TextEditingController startDateForSearchController = TextEditingController()..text = DateTime.now().toString().split(" ")[0];
  TextEditingController endDateForSearchController = TextEditingController()..text = DateTime.now().toString().split(" ")[0];
  TextEditingController groupForSearchController = TextEditingController();
  TextEditingController accountForSearchController = TextEditingController();
  TextEditingController storeForSearchController = TextEditingController();

  initController({String? accountForSearch}) {
    productForSearchController.clear();
    startDateForSearchController.text = DateTime.now().copyWith(month: 1,day: 1,year: 2024).toString().split(" ")[0];
    endDateForSearchController.text = DateTime.now().toString().split(" ")[0];
    groupForSearchController.clear();
    accountForSearch == null ? accountForSearchController.clear() : accountForSearchController.text = accountForSearch;
    storeForSearchController.clear();
  }
}
