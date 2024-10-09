import 'package:ba3_business_solutions/core/adapter/Warranty_adapter.dart';
import 'package:ba3_business_solutions/core/adapter/account_record_model_adapter.dart';
import 'package:ba3_business_solutions/core/adapter/global_model_adapter.dart';
import 'package:ba3_business_solutions/core/adapter/product_model_adapter.dart';
import 'package:ba3_business_solutions/core/adapter/product_record_model_adapter.dart';
import 'package:ba3_business_solutions/core/adapter/store_model_adapter.dart';
import 'package:ba3_business_solutions/model/account/account_customer.dart';
import 'package:ba3_business_solutions/model/account/account_model.dart';
import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:ba3_business_solutions/model/inventory/inventory_model.dart';
import 'package:ba3_business_solutions/model/product/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../adapter/Account_Customer_adapter.dart';
import '../adapter/account_model_adapter.dart';
import '../adapter/inventory_model_adapter.dart';
import '../../model/warranty/Warranty_Model.dart';
import '../../model/store/store_model.dart';

class HiveDataBase {
  static late Box<GlobalModel> globalModelBox;
  static late Box<ProductModel> productModelBox;
  static late Box<AccountModel> accountModelBox;
  static late Box<AccountCustomer> accountCustomerBox;
  static late Box<WarrantyModel> warrantyModelBox;
  static late Box<AccountModel> mainAccountModelBox;
  static late Box<Map> statisticBox;
  static late Box<StoreModel> storeModelBox;
  static late Box<InventoryModel> inventoryModelBox;
  static late Box<int> lastChangesIndexBox;
  static late Box<String> constBox;
  static late Box<bool> isFree;

  // static late Box<int> timerTimeBox;
  static late Box<String> timerDateBox;
  static late Box<bool> isNewUser;

  static Future<void> init() async {
    // final directory = await getApplicationDocumentsDirectory();
    // final directory = await getExternalStorageDirectory();

    // print(directory?.path);
    // if(Platform.isAndroid) {
    await Hive.initFlutter(
        "/storage/emulated/0/Android/data/com.ba3business.ba3_business_solutions/files");
    // } else{
    await Hive.initFlutter();

    // }
    Hive.registerAdapter(GlobalModelAdapter());
    Hive.registerAdapter(WarrantyAdapter());
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(AccountCustomerAdapter());
    Hive.registerAdapter(AccountModelAdapter());
    Hive.registerAdapter(StoreModelAdapter());
    Hive.registerAdapter(AccountRecordAdapter());
    Hive.registerAdapter(ProductRecordModelAdapter());
    Hive.registerAdapter(InventoryModelAdapter());
    productModelBox = await Hive.openBox<ProductModel>("AllProduct");
    warrantyModelBox = await Hive.openBox<WarrantyModel>("AllWarranty");
    accountCustomerBox =
        await Hive.openBox<AccountCustomer>("AllCustomerAccount");
    accountModelBox = await Hive.openBox<AccountModel>("AllAccount");
    storeModelBox = await Hive.openBox<StoreModel>("AllStore");
    lastChangesIndexBox = await Hive.openBox<int>("lastChangesIndex");
    inventoryModelBox = await Hive.openBox<InventoryModel>("AllInventory");
    mainAccountModelBox = await Hive.openBox<AccountModel>("mainAccount");
    statisticBox = await Hive.openBox<Map>("statisticBox");
    isFree = await Hive.openBox<bool>("isFree");

    // globalModelBox=await Hive.openBox<GlobalModel>();
    constBox = await Hive.openBox<String>("Const");
    // timerTimeBox=await Hive.openBox<int>("TimerTime");
    timerDateBox = await Hive.openBox<String>("TimerDate");
    isNewUser = await Hive.openBox<bool>("IsNewUser");
    if (constBox.get("myReadFlag") == null) {
      constBox.put(
          "myReadFlag", "readFlag${DateTime.now().microsecondsSinceEpoch}");
    }
    if (lastChangesIndexBox.get("lastChangesIndex") == null) {
      lastChangesIndexBox.put("lastChangesIndex", 0);
    }
    if (isFree.get("isFree") == null) {
      isFree.put("isFree", false);
    }
  }

  static String getMyReadFlag() {
    return constBox.get("myReadFlag")!;
  }

  static bool getWithFree() {
    return isFree.get("isFree") ?? false;
  }

  static Future<void> setDataName(dataName) async {
    globalModelBox = await Hive.openBox<GlobalModel>(dataName);
  }

  static Future<void> setIsFree(bool type) async {
    isFree.put("isFree", type);
  }

  static deleteAllLocal() {
    HiveDataBase.globalModelBox.deleteFromDisk();
    HiveDataBase.accountModelBox.deleteFromDisk();
    HiveDataBase.storeModelBox.deleteFromDisk();
    // HiveDataBase.productModelBox.deleteFromDisk();
    HiveDataBase.lastChangesIndexBox.deleteFromDisk();
    HiveDataBase.constBox.deleteFromDisk();
    HiveDataBase.isNewUser.deleteFromDisk();
    HiveDataBase.isFree.deleteFromDisk();
    HiveDataBase.accountCustomerBox.deleteFromDisk();
  }
}
