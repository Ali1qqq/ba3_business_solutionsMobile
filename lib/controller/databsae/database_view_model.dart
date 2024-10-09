import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/controller/bond/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/user/cards_view_model.dart';
import 'package:ba3_business_solutions/controller/databsae/import_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/print/print_view_model.dart';
import 'package:ba3_business_solutions/controller/store/store_view_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/bindings/bindings.dart';

import '../../core/helper/init_app/init_app.dart';
import '../../view/user_management/pages/account_management_view.dart';
import '../account/account_view_model.dart';
import '../cheque/cheque_view_model.dart';
import '../cost/cost_center_view_model.dart';

import '../invoice/invoice_view_model.dart';
import '../product/product_view_model.dart';
import '../seller/sellers_view_model.dart';
import '../user/user_management_model.dart';

class DataBaseViewModel extends GetxController {
  List<String> databaseList = [];

  DataBaseViewModel() {
    getAllDataBase();
  }

  getAllDataBase() {
    FirebaseFirestore.instance
        .collection(AppConstants.settingCollection)
        .doc(AppConstants.dataCollection)
        .get()
        .then((value) {
      // databaseList.clear();

      databaseList =
          (value.data()?['dataList'] as List).map((e) => e.toString()).toList();

      WidgetsFlutterBinding.ensureInitialized()
          .waitUntilFirstFrameRasterized
          .then((value) {
        update();
      });
    });
  }

  Future<void> setDataBase(String databaseName, context) async {
    init(oldData: databaseName);
    await Get.deleteAll(force: true);
    Get.put(UserManagementViewModel(), permanent: true);
    Get.put(AccountViewModel(), permanent: true);
    Get.put(StoreViewModel(), permanent: true);
    Get.put(ProductViewModel(), permanent: true);
    Get.put(BondViewModel(), permanent: true);
    Get.put(PatternViewModel(), permanent: true);
    Get.put(SellersViewModel(), permanent: true);
    Get.put(InvoiceViewModel(), permanent: true);
    Get.put(ChequeViewModel(), permanent: true);
    Get.put(CostCenterViewModel(), permanent: true);
    // Get.put(CameraService(),permanent: true);
    // Get.put(FaceDetectorService(),permanent: true);
    // Get.put(MLService(),permanent: true);
    Get.put(DataBaseViewModel(), permanent: true);
    Get.put(ImportViewModel(), permanent: true);
    Get.put(CardsViewModel(), permanent: true);
    Get.put(PrintViewModel(), permanent: true);
    Get.offAll(
      () => UserManagement(),
      binding: GetBinding(),
    );
  }

  void setDefaultDataBase(String databaseName) {
    if (databaseList.contains(databaseName)) {
      FirebaseFirestore.instance
          .collection(AppConstants.settingCollection)
          .doc(AppConstants.dataCollection)
          .update({"defaultDataName": databaseName});
    } else {
      Get.snackbar("خطأ", "لا يوجد قاعدة بيانات بنفس الاسم");
    }
  }

  void newDataBase(String databaseName) {
    if (databaseList.contains(databaseName)) {
      Get.snackbar("خطأ", "يوجد قاعدة بيانات بنفس الاسم");
    } else {
      FirebaseFirestore.instance
          .collection(AppConstants.settingCollection)
          .doc(AppConstants.dataCollection)
          .update({
        'dataList': FieldValue.arrayUnion([databaseName]),
      });
    }
  }
}
