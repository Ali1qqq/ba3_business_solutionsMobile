import 'dart:io';
import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/Pattern_model.dart';
import 'package:ba3_business_solutions/model/invoice_record_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/utils/loading_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/bond_record_model.dart';
import '../model/global_model.dart';
import '../utils/hive.dart';
import '../view/import/bond_list_view.dart';
import '../view/import/invoice_list_view.dart';
import '../view/import/preview_list_view.dart';

class ImportViewModel extends GetxController {

  // ImportViewModel(){
  //   MongoDB.productCollection.find({"a":"bb"}).listen((event) {
  //     print(event);
  //   });
  // //
  // }

  bool checkAllAccount(List<GlobalModel> bondList) {
    List<String> finalList = [];
    for (var e in bondList) {
      e.bondRecord?.forEach((element) {
        if (element.bondRecAccount == "") {
          finalList.add(element.bondRecAccount!);
        }
      });
    }

    if (finalList.isEmpty) {
      return true;
    } else {
      print(finalList);
      Get.defaultDialog(
          middleText: finalList.length.toString()+" account is not defined",
          cancel: Column(
            children: [
              for (var i = 0; i < finalList.length; i++) Text(finalList[i]),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("ok"))
            ],
          ));
      return false;
    }
  }

  Future<void> addBond(List<GlobalModel> bondList) async {
    BondViewModel bondController = Get.find<BondViewModel>();
    GlobalViewModel globalController = Get.find<GlobalViewModel>();
    print(bondList.length);
   await showLoadingDialog(total: bondList.length , fun: (index)async{
      GlobalModel element = bondList[index];
      await bondController.fastAddBondToFirebase(
        // bondId:a,
        oldBondCode: element.bondCode,
        //  bondId: element.bondId,
        bondDes:element.bondDescription,
          originId: null,
           total: double.parse("0.00"),
            record: element.bondRecord!,
             bondDate: element.bondDate,
              bondType: element.bondType
              );
    });
  }

  Future<void> addInvoice(List<GlobalModel> invList) async {
    GlobalViewModel globalController = Get.find<GlobalViewModel>();
    // for (var element in invList) {
    //   GlobalModel _ = globalController.correctInvRecord(element);
    //   globalController.addInvoiceToFirebase(_);
    // }
        

    await showLoadingDialog(total: invList.length , fun: (index)async{
      GlobalModel element = invList[index];
      element.invId = generateId(RecordType.invoice);
      print("-"*10);
      print( element.invId);
       print("-"*10);
      GlobalModel _ = globalController.correctInvRecord(element);
      await globalController.addInvoiceToFirebase(_);
    });
  }

  void pickBondFile(separator) async {
    List row = [];
    List row2 = [];
    var indexOfDate;
    var indexOfType;
    var indexOfDetails;
    var indexOfAccount;
    var indexOfCredit;
    var indexOfDebit;
    var indexOfTotal;
    var indexOfSmallDes;
    List<GlobalModel> bondList = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {
    } else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(separator);
      row2 = file[2].split(separator);
      file.removeAt(0);
      // print(row);
      // print(row.length);
      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }
      List<List<String>> dataList = file.map((e) => e.split(separator)).toList();
      row.forEach((element) {
        indexOfDate = row.indexOf("التاريخ");
        indexOfType = row.indexOf("أصل السند");
        indexOfTotal = row.indexOf("مدين");
        indexOfDetails = row.indexOf("البيان");
      });

      row2.forEach((element) {
        indexOfAccount = row2.indexOf("الحساب");
        indexOfCredit = row2.indexOf("دائن");
        indexOfDebit = row2.indexOf("مدين");
        indexOfSmallDes = row2.indexOf("البيان");
      });

      List<List<String>> accountList = [];
      List<List<String>> creditList = [];
      List<List<String>> debitList = [];
      List<List<String>> smallDesList = [];
      List<String> dateList = [];
      List<String> codeList = [];
      List<String> typeList = [];
      List<String> totalList = [];
      List<String> desList = [];
      List<String> accountTemp = [];
      List<String> creditTemp = [];
      List<String> debitTemp = [];
      List<String> smallDesTemp = [];
      dataList.forEach((element) {
        // print(element[indexOfAccount]);
        if (element[indexOfAccount] == "الحساب") {
          if (accountTemp.length != 0) {
            accountList.add(accountTemp.toList());
            creditList.add(creditTemp.toList());
            debitList.add(debitTemp.toList());
            smallDesList.add(smallDesTemp.toList());
            accountTemp.clear();
            debitTemp.clear();
            creditTemp.clear();
            smallDesTemp.clear();
          }
        } else if (element[indexOfAccount] == "") {
          dateList.add(element[indexOfDate]);
          desList.add(element[indexOfDetails]);
          totalList.add(element[indexOfTotal]);
          print(element[indexOfType].split(":"));
          codeList.add(element[indexOfType].split(":")[1]);
          typeList.add(element[indexOfType].split(":")[0]);
        } else {
          accountTemp.add(element[indexOfAccount].split("-")[0]);
          creditTemp.add(element[indexOfCredit].toString());
          debitTemp.add(element[indexOfDebit].toString());
          smallDesTemp.add(element[indexOfSmallDes].toString());
        }
        if (dataList.indexOf(element) + 1 == dataList.length) {
          accountList.add(accountTemp.toList());
          creditList.add(creditTemp.toList());
          debitList.add(debitTemp.toList());
          smallDesList.add(smallDesTemp.toList());
          accountTemp.clear();
          debitTemp.clear();
          smallDesTemp.clear();
          creditTemp.clear();
        }
      });
      for (var i = 0; i < accountList.length; i++) {
        List<BondRecordModel> recordTemp = [];
        for (var j = 0; j < accountList[i].length; j++) {
          int pad = 2;
          if (accountList[i][j] != '') {
            if(accountList[i].length>99){
              pad=3;
            }
            print("---------");
            String name = getAccountIdFromText(accountList[i][j]);
            if(name == ""){
              print(accountList[i][j]);
              print(codeList[i]);
            }
             print("---------");
            recordTemp.add(BondRecordModel(j.toString().padLeft(pad, '0'), double.parse(creditList[i][j].replaceAll(",", "")), double.parse(debitList[i][j].replaceAll(",", "")), name, smallDesList[i][j]));
          }
        }
        // print(typeList[i].removeAllWhitespace);
        // print(typeList[i].removeAllWhitespace=="دفع");
        String type =
        typeList[i].removeAllWhitespace=="دفع"
            ?Const.bondTypeDebit
            : typeList[i].removeAllWhitespace=="قبض"
              ? Const.bondTypeCredit
              :typeList[i].removeAllWhitespace=="ق.إ".removeAllWhitespace
                ?Const.bondTypeStart
                :Const.bondTypeDaily;
        // print(type);
        GlobalModel model = GlobalModel(bondDescription: desList[i],bondRecord: recordTemp.toList(), bondId: generateId(RecordType.bond), bondDate: dateList[i], bondTotal: totalList[i], bondCode: int.parse(codeList[i]).toString(), bondType: type);
        // print(model.toFullJson());
        bondList.add(GlobalModel.fromJson(model.toFullJson()));
        recordTemp.clear();
      }
      print(bondList.map((e) => e.toFullJson()));
      correctDebitAndCredit(bondList);
      Get.to(() => BondListView(
            bondList: bondList,
          ));
      // Get.to(() => ProductListView(
      //   productList: dataList,
      //   rows: row as List<String>,
      // ));
    }
  }

  correctDebitAndCredit(List bondList) {
    for(var index = 0 ; index <bondList.length ; index++){
      GlobalModel model = bondList[index];
      if(model.bondType == Const.bondTypeDebit ||model.bondType == Const.bondTypeCredit){
        Map <String,double> allRec= {};
        for (var ji  = 0 ; ji< (model.bondRecord??[]).length;ji++) {
          BondRecordModel  element = model.bondRecord![ji];
          if(model.bondType == Const.bondTypeDebit &&element.bondRecCreditAmount!=0){
            if(allRec[element.bondRecAccount!]==null)allRec[element.bondRecAccount!]=0;
            allRec[element.bondRecAccount!] = allRec[element.bondRecAccount]! + element.bondRecCreditAmount!;
          }else if(model.bondType == Const.bondTypeCredit &&element.bondRecDebitAmount!=0){
            if(allRec[element.bondRecAccount!]==null)allRec[element.bondRecAccount!]=0;
            allRec[element.bondRecAccount!] = allRec[element.bondRecAccount]! + element.bondRecDebitAmount!;
          }
        }
        if(model.bondType == Const.bondTypeCredit){
          model.bondRecord?.removeWhere((e) => e.bondRecDebitAmount !=0 );
          model.bondRecord?.add(BondRecordModel("X", 0, allRec.entries.first.value, allRec.entries.first.key, ""));
        }else{
          model.bondRecord?.removeWhere((e) => e.bondRecCreditAmount !=0 );
          model.bondRecord?.add(BondRecordModel("X",allRec.entries.first.value ,0,   allRec.entries.first.key, ""));
        }
      }
    }
  }

  Future<void> pickInvoiceFile(separator) async {
    BondViewModel bondViewModel = Get.find<BondViewModel>();
    List row = [];
    List row2 = [];
    // var indexOfInvType;
    // var indexOfPrimery;
    var indexOfSecoundry;
    var indexOfInvCode;
    var indexOfTotalWithVat;
    //var indexOfTotalVat;
    var indexOfTotalWithoutVat;
    var indexOfSubTotal;
    var indexOfQuantity;
    var indexOfProductName;
    var indexOfDate;
    var indexOfStore;
    var indexOfSeller;
    var indexOfPayType;
    List<GlobalModel> bondList = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {
    } else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(separator);

      file.removeAt(0);
      // print(row);
      // print(row.length);
      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }

      List<List<String>> dataList = file.map((e) => e.split(separator)).toList();
      row.forEach((element) {
        indexOfDate = row.indexOf("التاريخ");
        indexOfPayType = row.indexOf("طريقة الدفع");
        // indexOfInvType = row.indexOf("نوع الفاتورة");
        // indexOfPrimery = row.indexOf("اسم الزبون"); // BAD
        indexOfSecoundry = row.indexOf("حساب العميل في الفاتورة");
        indexOfInvCode = row.indexOf("الفاتورة");
        indexOfTotalWithVat = row.indexOf("صافي القيمة بعد الضريبة");
        //indexOfTotalVat = row.indexOf("القيمة المضافة");
        indexOfTotalWithoutVat = row.indexOf("القيمة");
        indexOfSubTotal = row.indexOf("السعر");
        indexOfQuantity = row.indexOf("الكمية");
        indexOfProductName = row.indexOf("اسم المادة");
        indexOfStore = row.indexOf("المستودع");
        indexOfSeller = row.indexOf("مركز الكلفة");
      });

      //  List<String> dateList=[];
      Map<String, GlobalModel> invMap = {};
      Map<String,({String? strart , String? end})> allChanges = {};
      List notFoundAccount = [];
      List notFoundProduct = [];
      List notFoundStore = [];
      List notFoundSeller = [];
      int bondCode = int.parse(bondViewModel.getNextBondCode(type: Const.bondTypeDaily))-1;
      for (var element in dataList) {
        var store = getStoreIdFromText(element[indexOfStore]);
        // var store = element[indexOfStore];
        if (store == '' && !notFoundStore.contains(element[indexOfStore])) {
          notFoundStore.add(element[indexOfStore]);
        }
        var seller = '';
        if(element[indexOfSeller]!=""){
        seller = getSellerIdFromText(element[indexOfSeller]);
        if (seller == '' && !notFoundSeller.contains(element[indexOfSeller])) {
          notFoundSeller.add(element[indexOfSeller]);
        }
        }
        late  PatternModel  patternModel;
       // print(element[indexOfInvCode]);
       //  print(element[indexOfInvCode]);
        List _ = element[indexOfInvCode].toString().replaceAll(" ", "").split(":");
         if(_[0]=="إخ.م"||_[0]=="إد.م"){
          print(_[0]);
          if(allChanges[_[1]]==null){
          allChanges[_[1]] = _[0] == "إخ.م" ?(strart:store ,end: null):(end:store ,strart: null);
          continue ;
          }else{
            allChanges[_[1]] =_[0] == "إخ.م" ?(end:allChanges[_[1]]!.end ,strart: store):(strart:allChanges[_[1]]!.strart ,end: store);
          }
          patternModel =  (Get.find<PatternViewModel>().patternModel.values.firstWhere((e) => e.patType == Const.invoiceTypeChange));
         }else{
         patternModel =  (Get.find<PatternViewModel>().patternModel.values.firstWhere((e) => e.patName?.replaceAll(" ", "") == element[indexOfInvCode].toString().split(":")[0].replaceAll(" ", "")));
         }
        bool isAdd = (patternModel.patType == Const.invoiceTypeAdd);
        var  primery ;
          var secoundry   ;

        // if( element[indexOfInvCode].toString().split(":")[0].replaceAll(" ", "") == "ت ادخال".replaceAll(" ", "") ||element[indexOfInvCode].toString().split(":")[0].replaceAll(" ", "") == 'ت خ'.replaceAll(" ", "") ){
        //   secoundry = patternModel.patSecondary;
        // }else{
        // //  primery = isAdd?'':getAccountIdFromText(element[indexOfPrimery]);
        //   secoundry=  isAdd?'':getAccountIdFromText(element[indexOfSecoundry]);
        // }
        // if (primery == '' && !notFoundAccount.contains(element[indexOfPrimery])&&!isAdd) {
        //   print("primery: |"+element[indexOfPrimery]);
        //   notFoundAccount.add(element[indexOfPrimery]);
        // }
        if(patternModel.patType == Const.invoiceTypeSales){
          primery = patternModel.patPrimary;
          secoundry = getAccountIdFromText(element[indexOfSecoundry]);
        }else if(patternModel.patType == Const.invoiceTypeBuy){
          primery = getAccountIdFromText(element[indexOfSecoundry]);
          secoundry = patternModel.patSecondary;
        }

        if (secoundry == '' && !notFoundAccount.contains(element[indexOfSecoundry])&&!isAdd) {
          print("secoundry: |"+element[indexOfSecoundry]+"| From "+element[indexOfInvCode]);
          notFoundAccount.add(element[indexOfSecoundry]);
        }
        var product = getProductIdFromName(element[indexOfProductName]);
        if (product == '' && !notFoundProduct.contains(element[indexOfProductName])) {
          print("product: |"+element[indexOfProductName]+"| From "+element[indexOfInvCode]);
          notFoundProduct.add(element[indexOfProductName]);
        }
        // if(primery ==""||primery ==null||secoundry ==null||secoundry == ""){
        //   print("------------------");
        //   print(primery.toString()+"|"+secoundry.toString()+"|"+element[indexOfInvCode]);
        //   print("------------------");
        // }
        if(patternModel.patType == Const.invoiceTypeChange){
          print("-----------");
          print(allChanges[_[1]]);
          print("-----------");
        }
        print(element[indexOfInvCode]);
        if (invMap[element[indexOfInvCode]] == null) {
           bondCode++;
          // var invId = generateId(RecordType.invoice);
          DateTime date = DateTime(int.parse(element[indexOfDate].split("-")[2]),int.parse(element[indexOfDate].split("-")[1]),int.parse(element[indexOfDate].split("-")[0]));
          invMap[element[indexOfInvCode]] = GlobalModel(
            //  invId: invId,
              bondId: generateId(RecordType.bond),
             // originId: invId,
              bondType: Const.bondTypeDaily,
              invIsPending: false,
              invPayType: element[indexOfPayType].removeAllWhitespace == "نقداً".removeAllWhitespace?Const.invPayTypeCash:Const.invPayTypeDue,
              //  bondCode: getNextBondCode(),
              invComment: "",
              bondCode: bondCode.toString(),
              ///aaaaaaa
              invMobileNumber: "",
              patternId: patternModel.patId,
              invSeller: seller,
              globalType: Const.globalTypeInvoice,
              invPrimaryAccount: primery,
              invSecondaryAccount: secoundry,
              invStorehouse: patternModel.patType!=Const.invoiceTypeChange ?store:allChanges[_[1]]!.strart ,
              invSecStorehouse: allChanges[_[1]]?.end,
              invDate: date.toString().split(".")[0],
              bondDate:  date.toString().split(".")[0],
              invVatAccount: patternModel.patVatAccount,
              invDiscountRecord: [],
              invTotal: double.parse(element[indexOfTotalWithVat].replaceAll(",", "").replaceAll("٫", ".")).abs(),
              // invType:  element[indexOfInvCode].toString().split(":")[0].replaceAll(" ", "")=="مبيع"?Const.invoiceTypeSales:Const.invoiceTypeBuy,
              invType: patternModel.patType,
              invCode: element[indexOfInvCode].toString().split(":")[1].replaceAll(" ", ""),
              invRecords: [
                InvoiceRecordModel(
                  prodChoosePriceMethod: Const.invoiceChoosePriceMethodeCustom,
                  invRecId: "1",
                  invRecQuantity: double.parse(element[indexOfQuantity].toString().replaceAll(",", "")).toInt().abs(),
                invRecProduct: product, //product id
                  invRecSubTotal: double.parse(element[indexOfSubTotal].toString().replaceAll(",", "").replaceAll("٫", ".")).abs(),
                  invRecIsLocal: getProductModelFromName(element[indexOfProductName])!.first.prodIsLocal,
                  invRecTotal: double.parse(element[indexOfTotalWithVat].toString().replaceAll(",", "").replaceAll("٫", ".")).abs(),
                
                  // invRecVat: double.parse(element[indexOfTotalVat].toString().replaceAll("٬", "").replaceAll("٫", ".")) / int.parse(element[indexOfQuantity]),
                  invRecVat: double.parse(element[indexOfTotalWithVat].toString().replaceAll(",", "").replaceAll("٫", ".")).abs()/double.parse(element[indexOfQuantity].toString().replaceAll(",", "")).toInt().abs() - double.parse(element[indexOfSubTotal].toString().replaceAll(",", "").replaceAll("٫", ".")).abs(),
                )
              ]);
        } else {
          var lastCode = int.parse(invMap[element[indexOfInvCode]]!.invRecords!.last.invRecId!) + 1;
          invMap[element[indexOfInvCode]]?.invTotal = double.parse(element[indexOfTotalWithVat].toString().replaceAll(",", "").replaceAll("٫", ".")).abs() + invMap[element[indexOfInvCode]]!.invTotal!;
          invMap[element[indexOfInvCode]]?.invRecords?.add(InvoiceRecordModel(
                prodChoosePriceMethod: Const.invoiceChoosePriceMethodeCustom,
                invRecId: lastCode.toString(),
                invRecQuantity: double.parse(element[indexOfQuantity].toString().replaceAll(",", "")).toInt().abs(),
                invRecProduct: getProductIdFromName(element[indexOfProductName]),
                invRecIsLocal: getProductModelFromName(element[indexOfProductName])!.first.prodIsLocal,
                invRecSubTotal: double.parse(element[indexOfSubTotal].toString().replaceAll(",", "").replaceAll("٫", ".")).abs(),
                invRecTotal: double.parse(element[indexOfTotalWithVat].toString().replaceAll(",", "").replaceAll("٫", ".")).abs(),
                invRecVat: double.parse(element[indexOfTotalWithVat].toString().replaceAll(",", "").replaceAll("٫", ".")).abs()/double.parse(element[indexOfQuantity].toString().replaceAll(",", "")).toInt().abs() - double.parse(element[indexOfSubTotal].toString().replaceAll(",", "").replaceAll("٫", ".")).abs(),
              ));
        }
        //  dateList.add(element[indexOfDate]);
      }

      if (notFoundProduct.isNotEmpty || notFoundStore.isNotEmpty || notFoundAccount.isNotEmpty|| notFoundSeller.isNotEmpty) {
        print(notFoundProduct);
        print(notFoundStore);
        print(notFoundAccount);
        print(notFoundSeller);
         print("notFoundProduct: "+notFoundProduct.length.toString());
         print("notFoundStore: "+notFoundStore.length.toString());
        print("notFoundAccount: "+notFoundAccount.length.toString());

        Get.defaultDialog(
            title: "بعض الحسابات غير موجودة",
            content: SizedBox(
              height: MediaQuery.sizeOf(Get.context!).height - 150,
              width: MediaQuery.sizeOf(Get.context!).width / 2,
              child: ListView(
                shrinkWrap: true,
                children: [
                  if (notFoundAccount.isNotEmpty) Center(child: Text("الحسابات")),
                  for (var e in notFoundAccount) Text(e),
                  SizedBox(
                    height: 30,
                  ),
                  if (notFoundStore.isNotEmpty) Center(child: Text("المستودعات")),
                  for (var e in notFoundStore) Text(e),
                  SizedBox(
                    height: 30,
                  ),
                  if (notFoundSeller.isNotEmpty) Center(child: Text("البائعون")),
                  for (var e in notFoundSeller) Text(e),
                  SizedBox(
                    height: 30,
                  ),
                  if (notFoundProduct.isNotEmpty) Center(child: Text("المواد")),
                  for (var e in notFoundProduct) Text(e),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ));
        return;
      }


      Get.to(() => InvoiceListView(
            invoiceList: invMap.values.toList(),
          ));

      // print(notFoundProduct);
      // print(notFoundStore);
      // print(notFoundAccount);
      // print(invMap.map((key, value) => MapEntry(key, value.toFullJson())));

      // print(dateList);
      // for(var i =0;i<accountList.length;i++){
      //   List<BondRecordModel> recordTemp=[];
      //   for(var j =0;j<accountList[i].length;j++){
      //     if(accountList[i][j]!=''){
      //       recordTemp.add(BondRecordModel(j.toString().padLeft(2, '0'), double.parse(creditList[i][j]), double.parse(debitList[i][j]), getAccountIdFromText(accountList[i][j]), ''));
      //     }
      //   }
      //   GlobalModel model = GlobalModel(bondRecord: recordTemp.toList(),bondId: generateId(RecordType.bond),bondDate:dateList[i] ,bondTotal: totalList[i],bondCode: int.parse(codeList[i]).toString(),bondDescription: "",bondType: Const.bondTypeDaily);
      //   // print(model.toFullJson());
      //   bondList.add(GlobalModel.fromJson(model.toFullJson()));
      //   recordTemp.clear();
      // }
      // print(bondList.map((e) => e.toFullJson()));
      // Get.to(()=>BondListView(
      //   bondList: bondList,
      // ));
      // Get.to(() => ProductListView(
      //   productList: dataList,
      //   rows: row as List<String>,
      // ));
    }
  }

  void pickFile(separator) async {
    var row = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {
    } else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(separator);
      file.removeAt(0);
      print(row);
      print(row.length);
      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }
      List<List<String>> dataList = file.map((e) => e.split(separator)).toList();
      Get.to(() => PreviewView(
            productList: dataList,
            rows: row as List<String>,
          ));
    }
  }

}
