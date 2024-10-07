/*
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:get/get.dart';

import '../Const/const.dart';
import '../model/Pattern_model.dart';
import '../model/account_model.dart';
import '../model/account_record_model.dart';
import '../model/invoice_record_model.dart';
import '../model/seller_model.dart';
import '../model/store_model.dart';
import '../model/store_record_model.dart';

class IsolateViewModel extends GetxController {

  Map<String, SellerModel> allSellers = <String, SellerModel>{};
  Map<String, StoreModel> storeMap = <String, StoreModel>{};
  Map<String, AccountModel> accountList = <String, AccountModel>{};
  Map<String, PatternModel> patternModel = <String, PatternModel>{};
  Map<String, ProductModel> productDataMap = <String, ProductModel>{};

  void init() {
    SellersViewModel sellersViewModel = Get.find<SellersViewModel>();
    StoreViewModel storeViewModel = Get.find<StoreViewModel>();
    AccountViewModel accountViewModel = Get.find<AccountViewModel>();
    PatternViewModel patternViewModel = Get.find<PatternViewModel>();
    ProductViewModel productViewModel = Get.find<ProductViewModel>();
    allSellers = sellersViewModel.allSellers;
    storeMap = storeViewModel.storeMap;
    accountList = Map.fromEntries(accountViewModel.accountList.entries.toList());
    productDataMap = Map.fromEntries(productViewModel.productDataMap.entries.toList());
    patternModel = patternViewModel.patternModel;
  }


  double getBalance(userId) {
    double _ = 0;
    List<AccountRecordModel> allRecord = [];
    AccountModel accountModel = accountList[userId]??AccountModel();
    allRecord.addAll(accountList[userId]!.accRecord);
    for (var element in accountModel.accChild) {
      allRecord.addAll(accountList[element]?.accRecord.toList()??[]);
    }
    if (accountModel.accType == Const.accountTypeAggregateAccount) {
      for (var element in accountModel.accAggregateList) {
        allRecord.addAll(accountList[element]?.accRecord.toList()??[]);
      }
    }
    if (allRecord.isNotEmpty) {
      _ = allRecord.map((e) => double.parse(e.total!)).toList().reduce((value, element) => value + element);
    }
    return _;
  }


 Map<String, double> totalAmountPage = {};
  Map<String , StoreRecordView>allData ={};
  initStorePage(storeId) {
    totalAmountPage.clear();
    storeMap[storeId]?.stRecords.forEach((value) {
      value.storeRecProduct?.forEach((key, value) {
        totalAmountPage[value.storeRecProductId!] = (totalAmountPage[value.storeRecProductId!] ?? 0) + double.parse(value.storeRecProductQuantity!);
       
      });
    });
   totalAmountPage.forEach((key, value) {
     allData[key] = StoreRecordView(
        productId:key ,
        total:value.toString(),
     );
   },);
  }

}

String getStoreNameFromIdIsolate(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<IsolateViewModel>().storeMap[id]!.stName!;
  } else {
    return "";
  }
}

String getSellerNameFromIdIsolate(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<IsolateViewModel>().allSellers[id]!.sellerName!;
  } else {
    return "";
  }
}
String getAccountNameFromIdIsolate(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<IsolateViewModel>().accountList[id]!.accName!;
  } else {
    return "";
  }
}
PatternModel getPatModelFromPatternIdIsolate(id){
  if (id != null && id != " " && id != "") {
    return Get.find<IsolateViewModel>().patternModel[id]!;
  } else {
    return PatternModel(patName: "not found");
  }}

double getAccountBalanceFromIdIsolate(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<IsolateViewModel>().getBalance(id);
  } else {
    return 0;
  }
}

String getProductNameFromIdIsolate(id) {
  if (id != null && id != " " && id != "") {
    if(Get.find<IsolateViewModel>().productDataMap[id] == null){

    }
    return Get.find<IsolateViewModel>().productDataMap[id]?.prodName! ??'';
  } else {
    return "";
  }}
ProductModel? getProductModelFromIdIsolate(id) {
  if (id.runtimeType == InvoiceRecordModel) {
    return Get.find<IsolateViewModel>().productDataMap[(id as InvoiceRecordModel).invRecProduct!];
  } else if (id != null && id != " " && id != "") {
    return Get.find<IsolateViewModel>().productDataMap[id]!;
  } else {
    return null;
  }
}*/
