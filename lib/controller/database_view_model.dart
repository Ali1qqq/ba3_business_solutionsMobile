import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/cards_view_model.dart';
import 'package:ba3_business_solutions/controller/import_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/print_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/bindings.dart';

import '../view/user_management/account_management_view.dart';
import 'account_view_model.dart';
import 'cheque_view_model.dart';
import 'cost_center_view_model.dart';

import 'invoice_view_model.dart';
import 'product_view_model.dart';
import 'sellers_view_model.dart';
import 'user_management_model.dart';

class DataBaseViewModel extends GetxController {
  List<String> databaseList=[];
  DataBaseViewModel() {
    getAllDataBase();
  }


  getAllDataBase() {
    FirebaseFirestore.instance.collection(Const.settingCollection).doc(Const.dataCollection).get().then((value) {
      // databaseList.clear();

      databaseList=(value.data()?['dataList'] as List).map((e) => e.toString()).toList();

      WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
        update();
      });
    });
  }

  Future<void> setDataBase(String databaseName,context) async {
    Const.init(oldData: databaseName);
    await Get.deleteAll(force: true);
    Get.put(UserManagementViewModel(),permanent: true);
    Get.put(AccountViewModel(),permanent: true);
    Get.put(StoreViewModel(),permanent: true);
    Get.put(ProductViewModel(),permanent: true);
    Get.put(BondViewModel(),permanent: true);
    Get.put(PatternViewModel(),permanent: true);
    Get.put(SellersViewModel(),permanent: true);
    Get.put(InvoiceViewModel(),permanent: true);
    Get.put(ChequeViewModel(),permanent: true);
    Get.put(CostCenterViewModel(),permanent: true);
    // Get.put(CameraService(),permanent: true);
    // Get.put(FaceDetectorService(),permanent: true);
    // Get.put(MLService(),permanent: true);
    Get.put(DataBaseViewModel(),permanent: true);
    Get.put(ImportViewModel(),permanent: true);
    Get.put(CardsViewModel(),permanent: true);
    Get.put(PrintViewModel(),permanent: true);
    Get.offAll(
          () => UserManagement(),
      binding: GetBinding(),
    );
  }


  void setDefaultDataBase(String databaseName) {
    if(databaseList.contains(databaseName)){
      FirebaseFirestore.instance.collection(Const.settingCollection).doc(Const.dataCollection).update({"defaultDataName":databaseName});
    }else{
      Get.snackbar("خطأ", "لا يوجد قاعدة بيانات بنفس الاسم");
    }
  }
  void newDataBase(String databaseName) {
    if(databaseList.contains(databaseName)){
      Get.snackbar("خطأ", "يوجد قاعدة بيانات بنفس الاسم");
    }else{
      FirebaseFirestore.instance.collection(Const.settingCollection).doc(Const.dataCollection).update({
        'dataList': FieldValue.arrayUnion([databaseName]),
      });
    }
  }


}
