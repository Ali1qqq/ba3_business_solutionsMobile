
import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/model/seller_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/view/sellers/widget/all_seller_invoice_view_data_grid_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:math';
import '../model/global_model.dart';
import 'user_management_model.dart';

class SellersViewModel extends GetxController {
  late DataGridController dataViewGridController;
  late AllSellerInvoiceViewDataGridSource recordViewDataSource=AllSellerInvoiceViewDataGridSource(sellerRecModel: []);
  RxMap<String, SellerModel> allSellers = <String, SellerModel>{}.obs;

  SellersViewModel() {
    getAllSeller();
  }

  void getAllSeller() {
    FirebaseFirestore.instance.collection(Const.sellersCollection).snapshots().listen((event) {
      RxMap<String, List<SellerRecModel>> oldSellerList = <String, List<SellerRecModel>>{}.obs;
      allSellers.forEach((key, value) {
        oldSellerList[key]=value.sellerRecord??[];
      });
      allSellers.clear();
      for (var element in event.docs) {
        List<SellerRecModel> _=allSellers[element.id]?.sellerRecord??[];
        allSellers[element.id] = SellerModel.fromJson(element.data(), element.id);
        allSellers[element.id]?.sellerRecord=oldSellerList[element.id]??[];
      }
      // initChart();
      update();
    });
  }

  addSeller(SellerModel model) {
    List<SellerModel> _ = allSellers.values.where((element) => element.sellerCode == model.sellerCode).toList();
    if(_.isNotEmpty){
      if(model.sellerId ==null ){
        return ;
      }else if(model.sellerId !=null &&model.sellerId != _.first.sellerId){
        return;
      }
    }
    var id = generateId(RecordType.sellers);
    model.sellerId ??= id;
    FirebaseFirestore.instance.collection(Const.sellersCollection).doc(model.sellerId).set(model.toJson());
  }

  deleteSeller(SellerModel model) {
    FirebaseFirestore.instance.collection(Const.sellersCollection).doc(model.sellerId).delete();
  }

  void postRecord({userId, invId, amount, date}) {
    allSellers.values.map((e) => e.sellerRecord).toList().forEach((element) {
      element?.removeWhere((element) => element.selleRecInvId == invId);
    });
    SellerRecModel seller=   SellerRecModel(selleRecUserId: userId, selleRecInvId: invId, selleRecAmount: amount.toString(), selleRecInvDate: date);
    if(allSellers[userId]?.sellerRecord==null){
      allSellers[userId]?.sellerRecord=[seller];
    }else{
      allSellers[userId]?.sellerRecord?.removeWhere((element) => element.selleRecInvId==invId);
      allSellers[userId]?.sellerRecord?.add(seller);
    }
  }

  void deleteGlobalSeller(GlobalModel globalModel){
    allSellers[globalModel.invSeller]?.sellerRecord?.removeWhere((element) => element.selleRecInvId==globalModel.invId);
    WidgetsFlutterBinding.ensureInitialized()
        .waitUntilFirstFrameRasterized
        .then((value) {
      update();
    });
  }

  // void deleteRecord({userId, invId}) {
  //   FirebaseFirestore.instance.collection(Const.sellersCollection).doc(userId).collection(Const.recordCollection).doc(invId).delete();
  // }

  initSellerPage(key) {
    dataViewGridController = DataGridController();
    recordViewDataSource = AllSellerInvoiceViewDataGridSource(sellerRecModel: allSellers[key]!.sellerRecord!);
    // update();
  }

  void filter(List<DateTime> list, key) {
    var startDate = DateTime.parse(list[0].toString().split(" ")[0]);
    var endDate = DateTime.parse(list[1].toString().split(" ")[0]);
    var _ = allSellers[key]?.sellerRecord?.where((e) => DateTime.parse(e.selleRecInvDate!).millisecondsSinceEpoch <= endDate.millisecondsSinceEpoch && DateTime.parse(e.selleRecInvDate!).millisecondsSinceEpoch >= startDate.millisecondsSinceEpoch).toList();
    dataViewGridController = DataGridController();
    recordViewDataSource = AllSellerInvoiceViewDataGridSource(sellerRecModel: _!);
    update();
  }

  Map<String,Map<String,double>>userMoney={};
  Map<String,Color>colorMap={};
  double high =0;
  // initChart(){
  //   userMoney.clear();
  //   colorMap.clear();
  //   high=0;
  //   allSellers[getMyUserSellerId()]?.sellerRecord?.forEach((element) {
  //     var month=element.selleRecInvDate!.split("-")[1];
  //     var day=element.selleRecInvDate!.split("-")[2];
  //     if(userMoney[month]==null){
  //       userMoney[month]={};
  //     }
  //     userMoney[month]?[day]=(userMoney[month]?[day]??0)+double.parse(element.selleRecAmount!);
  //     if(high<(userMoney[month]?[day]??0)){
  //       high=(userMoney[month]?[day]??0);
  //     }
  //   });
  //
  //   // userMoney=sortNestedMaps(userMoney);
  //
  //   userMoney=sortNestedMaps(userMoney);
  //   userMoney.forEach((key, value) {
  //     colorMap[key]=getRandomColor();
  //   });
  //   // WidgetsFlutterBinding.ensureInitialized()
  //   //     .waitUntilFirstFrameRasterized
  //   //     .then((value) {
  //   //   update();
  //   // });
  //   // update();
  // }

  Color getRandomColor() {
    Random random = Random();

    // Generate random values for the RGB components
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);
    Color randomColor = Color.fromARGB(255, red, green, blue);

    return randomColor;
  }

  Map<String, Map<String, double>> sortNestedMaps(Map<String, Map<String, double>> data) {
    Map<String, Map<String, double>> sortedData = Map.fromEntries(data.entries.toList());

    sortedData.forEach((key, innerMap) {
      var sortedInnerMap = Map.fromEntries(innerMap.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key)));
      sortedData[key] = sortedInnerMap;
    });

    return sortedData;
  }

}

Future<String> getSellerComplete(text) async {
  var sellerController = Get.find<SellersViewModel>();
  List<SellerModel> _accountPickList = [];
  SellerModel? sellerModel;
  sellerController.allSellers.forEach((key, value) {
    _accountPickList.addIf((value.sellerCode!.toLowerCase().contains(text.toLowerCase()) || value.sellerName!.toLowerCase().contains(text.toLowerCase())), value);
  });
  if (_accountPickList.length > 1) {
    await Get.defaultDialog(
      title: "اختر احد البائعين",
      content: SizedBox(
        height: Get.height/2,
        width:Get.height/2,
        child: ListView.builder(
          itemCount: _accountPickList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.back();
                sellerModel = _accountPickList[index];
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(8),
                width: 500,
                child: Center(
                  child: Text(
                    _accountPickList[index].sellerName??"",
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  else if (_accountPickList.length == 1) {
    sellerModel= _accountPickList[0];
  } else {
    Get.snackbar("فحص المطاييح", "هذا المطيح غير موجود من قبل");
    return "";
  }
  if(sellerModel!.sellerId!=getMyUserSellerId()){

  if(await checkPermissionForOperation(Const.roleUserAdmin, Const.roleViewInvoice)){
    return sellerModel!.sellerName!;
  }else{
    return getSellerNameFromId(getMyUserSellerId())??"";
    }
  }else{
    return sellerModel!.sellerName!;
  }
}

String? getSellerIdFromText(text) {
  var sellerController = Get.find<SellersViewModel>();
  if (text != null && text != " " && text != "") {
    return sellerController.allSellers.values.toList().firstWhereOrNull((element) => element.sellerName!.contains(text))?.sellerId;
  } else {
    return null;
  }
}

String? getSellerNameFromId(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<SellersViewModel>().allSellers[id]!.sellerName;
  } else {
    return null;
  }

}
