import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/model/AccountCustomer.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/cheque_rec_model.dart';
import 'package:ba3_business_solutions/model/entry_bond_record_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportConfigurationView extends StatefulWidget {
  final List<List<String>> productList;
  final List<String> rows;

  const ImportConfigurationView({super.key, required this.productList, required this.rows});

  @override
  State<ImportConfigurationView> createState() => _ImportConfigurationViewState();
}

//  return {
//       'accId': accId,
//       'accName': accName,
//       'accComment': accComment,
//       'accType': accType,
//       'accCode': accCode,
//       'accVat': accVat,
//     };
class _ImportConfigurationViewState extends State<ImportConfigurationView> {
  Map<String, RecordType> typeMap = {
    "حسابات": RecordType.account,
    "مواد": RecordType.product,
    "شيكات": RecordType.cheque,
  };

  Map configProduct = {
    'اسم المادة': 'prodName',
    'رمز المادة': 'prodCode',
    // 'اسم المجموعة' :'prodParentId',
    'سعر المستهلك': 'prodCustomerPrice',
    'سعر جملة': 'prodWholePrice',
    'سعر مفرق': 'prodRetailPrice',
    'سعر التكلفة': 'prodCostPrice',
    'اقل سعر مسموح': 'prodMinPrice',
    'باركود المادة': 'prodBarcode',
    'رمز المجموعة': 'prodParentId',
    'نوع المادة': 'prodType',
  };

  Map configAccount = {
    "الحساب": "accName",
    "رمز الحساب": "accCode",
    "الحساب الرئيسي": 'accParentId',
    "اسم حساب الزبون": 'customerAccountName',
    "رقم البطاقة": 'customerCardNumber',
    "الترميز الضريبي": 'customerVAT',
  };

  Map configCheque = {
    // "الاسم": "cheqName",
    "المبلغ": "cheqAllAmount",
    // "": "cheqRemainingAmount",
    // "الحساب ": "cheqPrimeryAccount",
    "الحساب المقابل": "cheqSecoundryAccount",
    "رثم الورقة": "cheqNum",
    "تاريخ الورقة": "cheqDate",
    "تاريخ الاستحقاق": "cheqDateDue",
    "حالة الورقة": "cheqStatus",
    "اسم النمط": "cheqType",
    // "": "cheqBankAccount"
  };

  Map config = {};
  Map setting = {};

  RecordType? type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<RecordType>(
                  value: type,
                  items: typeMap.keys.map((e) => DropdownMenuItem(value: typeMap[e], child: Text(e.toString()))).toList(),
                  onChanged: (_) {
                    type = _;
                    if (_ == RecordType.product) {
                      config = configProduct;
                    } else if (_ == RecordType.account) {
                      config = configAccount;
                    } else if (_ == RecordType.cheque) {
                      config = configCheque;
                    }
                    setState(() {});
                  }),
              const SizedBox(
                width: 20,
              ),
              const Text("النوع"),
            ],
          ),
          if (type != null)
            SizedBox(
                width: Get.width,
                child: Wrap(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // mainAxisSize: MainAxisSize.max,
                  children: List.generate(
                      config.keys.toList().length,
                      (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 120,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(config.keys.toList()[index]),
                                  const Text("| |"),
                                  const Text(" V"),
                                  SizedBox(
                                    height: 30,
                                    width: 300,
                                    child: DropdownButton<int>(
                                        value: setting[config.values.toList()[index]],
                                        items: widget.rows
                                            .map((e) => DropdownMenuItem(
                                                  value: widget.rows.indexOf(e),
                                                  child: Text(e.toString()),
                                                ))
                                            .toList(),
                                        onChanged: (_) {
                                          // print(widget.rows.indexOf(_!));
                                          setting[config.values.toList()[index]] = _;
                                          print(setting);
                                          setState(() {});
                                        }),
                                  )
                                ],
                              ),
                            ),
                          )),
                )),
          ElevatedButton(
              onPressed: () async {
                if (type == RecordType.product) {
                  await addProductFree();
                } else if (type == RecordType.account) {
                  await addAccount();
                } else if (type == RecordType.cheque) {
                  await addCheque();
                }
                // Get.offAll(() => HomeView());
              },
              child: const Text("ending")),
          const SizedBox(
            height: 70,
          ),
          const Text("مثال"),
          const SizedBox(
            height: 70,
          ),
          SizedBox(
              height: 80,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(
                    widget.rows.length,
                    (index) => Column(
                          children: [Text(widget.rows[index]), Text(widget.productList[0][index])],
                        )),
              ))
        ],
      ),
    );
  }

  Future<void> addProductFree() async {
    List<ProductModel> finalData = [];
    for (var element in widget.productList) {
      //print(element[setting["prodName"]]);
      bool isGroup = !(element[setting['prodType']].removeAllWhitespace == "خدمية" || element[setting['prodType']].removeAllWhitespace == "مستودعية");
      var code = element[setting["prodCode"]].replaceAll(element[setting["prodParentId"]], "");
      var parentId = "F" + element[setting["prodParentId"]];
      // var isRoot = element[setting["prodParentId"]].isBlank;
      // print("code "+code);
      String? chechIsExist = isGroup ? getProductIdFromName("F-" + element[setting["prodName"]].replaceAll("- ", "")) : getProductIdFromName("F-" + element[setting["prodName"]]);
      // print("parentId "+parentId);
      // print("FullCode "+element[setting["prodCode"]]);
      // print("isRoot "+isRoot.toString());
      // print(element[setting['prodType']].removeAllWhitespace);
      // print(element[setting['prodType']].removeAllWhitespace=="مستودعية");
      // print(!(element[setting['prodType']].removeAllWhitespace=="خدمية"||element[setting['prodType']].removeAllWhitespace=="مستودعية"));
      // print("===");
      if (chechIsExist == "" || chechIsExist == null) {
        finalData.add(ProductModel(
            prodId: generateId(RecordType.product),
            prodName: "F-" + element[setting["prodName"]],
            // prodCode: element[setting["prodCode"]],
            prodCode: code,
            prodBarcode: element[setting["prodBarcode"]],
            // prodIsLocal: !element[setting["prodName"]].contains("مستعمل"),
            prodIsLocal: false,
            prodFullCode: "F" + element[setting["prodCode"]],
            // prodGroupCode: element[setting["prodGroupCode"]],
            //todo
            prodCustomerPrice: element[setting['prodCustomerPrice']],
            prodWholePrice: element[setting['prodWholePrice']],
            prodRetailPrice: element[setting['prodRetailPrice']],
            prodCostPrice: element[setting['prodCostPrice']],
            prodMinPrice: element[setting['prodMinPrice']],
            prodType: element[setting['prodType']].removeAllWhitespace == "خدمية" ? Const.productTypeService : Const.productTypeStore,
            // prodParentId : element[setting['prodParentId']].isBlank!?null:parentId,
            // prodIsParent : element[setting['prodParentId']].isBlank,
            prodParentId: parentId.isBlank! ? null : parentId,
            prodIsParent: parentId.isBlank,
            prodIsGroup: isGroup));
      }
    }
    var i = 0;

    print(finalData.length);
    print("--" * 30);
    for (var i in finalData) {
      if (i.prodIsGroup!) {
        print(i.toFullJson());
      }
    }
    print("--" * 30);
//  for(var i in finalData){

//       print(i.prodName!+"|  -  |"+i.prodFullCode!+"|  -  |"+i.prodId!+"|  |"+getProductIdFromFullName(i.prodParentId).toString());
//     }

    /// FIX DUPLICATE ON PRODACT FULL CODE
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  for(var a in finalData){
    //   if(getProductIdFromFullName(a.prodFullCode!)!=""){
    //    ProductModel _ = getProductModelFromId(getProductIdFromFullName(a.prodFullCode!))!;
    //  print(a.prodName!+"|  -  |"+a.prodFullCode!+"    "+_.prodName!);
    //   _.prodName  = a.prodName;
    //   print(a.prodName!+"|  -  |"+a.prodFullCode!+"    "+_.prodName!);
    //   await FirebaseFirestore.instance.collection(Const.productsCollection).doc(_.prodId).set(_.toJson());
    //   HiveDataBase.productModelBox.put(_.prodId, _);
    //   }
    // }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // ProductViewModel productViewModel = Get.find<ProductViewModel>();
    for (var element in finalData) {
      i++;
      print(i.toString() + " OF " + finalData.length.toString());

      ///FireBse Todo
      await FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.prodId).set(element.toJson());
      HiveDataBase.productModelBox.put(element.prodId, element);
    }
    // i = 0;
    // for (var index = 0 ;index < finalData.length; index ++ ) {
    //   ProductModel element = finalData[index];
    //   i++;
    //   print(i.toString() + " OF "+finalData.length.toString() );
    //   if(!element.prodIsParent!){
    //     FirebaseFirestore.instance.collection(Const.productsCollection).doc(getProductIdFromFullName(element.prodParentId)).update({
    //       'prodChild': FieldValue.arrayUnion([element.prodId]),
    //     });
    //    productViewModel.productDataMap[getProductIdFromFullName(element.prodParentId!)]!.prodChild?.add(element.prodId);
    //     HiveDataBase.productModelBox.put(getProductIdFromFullName(element.prodParentId!),  productViewModel.productDataMap[getProductIdFromFullName(element.prodParentId!)]!);
    //     FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.prodId).update({
    //       "prodParentId":getProductIdFromFullName(element.prodParentId)
    //     });
    //     finalData[index].prodParentId = getProductIdFromFullName(element.prodParentId);
    //     HiveDataBase.productModelBox.put(index, finalData[index]);
    //    ProductModel prodParentId = getProductModelFromId(getProductIdFromFullName(element.prodParentId))!;
    //     // if(prodParentId.prodGroupPad==null){
    //     //   int pad= element.prodFullCode!.replaceAll(prodParentId.prodFullCode!, "").length;
    //     //   await FirebaseFirestore.instance.collection(Const.productsCollection).doc(prodParentId.prodId).update({
    //     //     "prodGroupPad":pad
    //     //   });
    //     // }
    //   }
    // }
  }

  Future<void> addProduct() async {
    List<ProductModel> finalData = [];
    for (var element in widget.productList) {
      //print(element[setting["prodName"]]);
      bool isGroup = !(element[setting['prodType']].removeAllWhitespace == "خدمية" || element[setting['prodType']].removeAllWhitespace == "مستودعية");
      var code = element[setting["prodCode"]].replaceAll(element[setting["prodParentId"]], "");
      var parentId = element[setting["prodParentId"]];
      // var isRoot = element[setting["prodParentId"]].isBlank;
      // print("code "+code);
      String? chechIsExist = isGroup ? getProductIdFromName(element[setting["prodName"]].replaceAll("- ", "")) : getProductIdFromName(element[setting["prodName"]]);
      // print("parentId "+parentId);
      // print("FullCode "+element[setting["prodCode"]]);
      // print("isRoot "+isRoot.toString());
      // print(element[setting['prodType']].removeAllWhitespace);
      // print(element[setting['prodType']].removeAllWhitespace=="مستودعية");
      // print(!(element[setting['prodType']].removeAllWhitespace=="خدمية"||element[setting['prodType']].removeAllWhitespace=="مستودعية"));
      // print("===");
      if (chechIsExist == "" || chechIsExist == null) {
        finalData.add(ProductModel(
            prodId: generateId(RecordType.product),
            prodName: element[setting["prodName"]],
            // prodCode: element[setting["prodCode"]],
            prodCode: code,
            prodBarcode: element[setting["prodBarcode"]],
            // prodIsLocal: !element[setting["prodName"]].contains("مستعمل"),
            prodIsLocal: true,
            prodFullCode: "L${element[setting["prodCode"]]}",
            // prodGroupCode: element[setting["prodGroupCode"]],
            //todo
            prodCustomerPrice: element[setting['prodCustomerPrice']],
            prodWholePrice: element[setting['prodWholePrice']],
            prodRetailPrice: element[setting['prodRetailPrice']],
            prodCostPrice: element[setting['prodCostPrice']],
            prodMinPrice: element[setting['prodMinPrice']],
            prodType: element[setting['prodType']].removeAllWhitespace == "خدمية" ? Const.productTypeService : Const.productTypeStore,
            // prodParentId : element[setting['prodParentId']].isBlank!?null:parentId,
            // prodIsParent : element[setting['prodParentId']].isBlank,
            prodParentId: parentId.isBlank! ? null : getProductIdFromFullName("L" + parentId),
            prodIsParent: parentId.isBlank,
            prodIsGroup: isGroup));
      }
    }
    var i = 0;

    print(finalData.length);
    print("--" * 30);
    for (var i in finalData) {
      print(i.toFullJson());
    }
    print("--" * 30);
//  for(var i in finalData){

//       print(i.prodName!+"|  -  |"+i.prodFullCode!+"|  -  |"+i.prodId!+"|  |"+getProductIdFromFullName(i.prodParentId).toString());
//     }

    /// FIX DUPLICATE ON PRODACT FULL CODE
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  for(var a in finalData){
    //   if(getProductIdFromFullName(a.prodFullCode!)!=""){
    //    ProductModel _ = getProductModelFromId(getProductIdFromFullName(a.prodFullCode!))!;
    //  print(a.prodName!+"|  -  |"+a.prodFullCode!+"    "+_.prodName!);
    //   _.prodName  = a.prodName;
    //   print(a.prodName!+"|  -  |"+a.prodFullCode!+"    "+_.prodName!);
    //   await FirebaseFirestore.instance.collection(Const.productsCollection).doc(_.prodId).set(_.toJson());
    //   HiveDataBase.productModelBox.put(_.prodId, _);
    //   }
    // }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // ProductViewModel productViewModel = Get.find<ProductViewModel>();
    for (var element in finalData) {
      i++;
      print("$i OF ${finalData.length}");
      print(element.toJson());
      await FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.prodId).set(element.toJson());
      HiveDataBase.productModelBox.put(element.prodId, element);
      print(element.prodParentId);
      if (element.prodParentId != null && element.prodParentId != '') {
        ProductModel parentModel = getProductModelFromId(element.prodParentId!)!;
        parentModel.prodChild?.add(element.prodId);
        HiveDataBase.productModelBox.put(parentModel.prodId, parentModel);
        FirebaseFirestore.instance.collection(Const.productsCollection).doc(parentModel.prodId).update({
          'prodChild': FieldValue.arrayUnion([element.prodId]),
        });
      }
    }

    // i = 0;
    // for (var index = 0 ;index < finalData.length; index ++ ) {
    //   ProductModel element = finalData[index];
    //   i++;
    //   print(i.toString() + " OF "+finalData.length.toString() );
    //   if(!element.prodIsParent!){
    //     FirebaseFirestore.instance.collection(Const.productsCollection).doc(getProductIdFromFullName(element.prodParentId)).update({
    //       'prodChild': FieldValue.arrayUnion([element.prodId]),
    //     });
    //    productViewModel.productDataMap[getProductIdFromFullName(element.prodParentId!)]!.prodChild?.add(element.prodId);
    //     HiveDataBase.productModelBox.put(getProductIdFromFullName(element.prodParentId!),  productViewModel.productDataMap[getProductIdFromFullName(element.prodParentId!)]!);
    //     FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.prodId).update({
    //       "prodParentId":getProductIdFromFullName(element.prodParentId)
    //     });
    //     finalData[index].prodParentId = getProductIdFromFullName(element.prodParentId);
    //     HiveDataBase.productModelBox.put(index, finalData[index]);
    //    ProductModel prodParentId = getProductModelFromId(getProductIdFromFullName(element.prodParentId))!;
    //     // if(prodParentId.prodGroupPad==null){
    //     //   int pad= element.prodFullCode!.replaceAll(prodParentId.prodFullCode!, "").length;
    //     //   await FirebaseFirestore.instance.collection(Const.productsCollection).doc(prodParentId.prodId).update({
    //     //     "prodGroupPad":pad
    //     //   });
    //     // }
    //   }
    // }
  }

  Future<void> addAccount() async {
    // AccountViewModel accountViewModel = Get.find<AccountViewModel>();
    List<AccountModel> finalData = [];
    for (var element in widget.productList) {
      if (element[setting["accCode"]] != '') {
        bool accIsParent = element[setting['accParentId']].isEmpty;
        if (accIsParent) {
          finalData.add(AccountModel(
            accId: getAccountIdFromText(element[setting["accName"]].replaceAll("-", "")),
            accName: (element[setting["accName"]].replaceAll("-", "")),
            accCode: element[setting["accCode"]].replaceAll("-", ""),
            accComment: '',
            accType: Const.accountTypeDefault,
            accVat: 'GCC',
            accParentId: accIsParent ? null : getAccountIdFromText(element[setting['accParentId']]),
            accIsParent: accIsParent,
          ));
        } else {
          finalData
              .where(
                (e) => e.accId == getAccountIdFromText(element[setting['accParentId']]),
              )
              .first
              .accChild
              .add(getAccountIdFromText(element[setting["accName"]].replaceAll("-", "")));
          finalData.add(AccountModel(
            accId: getAccountIdFromText(element[setting["accName"]].replaceAll("-", "")),
            accName: (element[setting["accName"]].replaceAll("-", "")),
            accCode: element[setting["accCode"]].replaceAll("-", ""),
            accComment: '',
            accType: Const.accountTypeDefault,
            accVat: 'GCC',
            accParentId: getAccountIdFromText(element[setting['accParentId']]),
            accIsParent: accIsParent,
          ));
        }
      } else {
        // print(element[setting["accName"]]);
        if (finalData.last.accCustomer == null) {
          finalData.last.accCustomer = [
            AccountCustomer(
              customerAccountId: generateId(RecordType.accCustomer),
              customerAccountName: element[setting["accName"]],
              customerCardNumber: element[setting["customerCardNumber"]],
              customerVAT: element[setting["customerVAT"]],
              mainAccount: finalData.last.accId,
            )
          ];
        } else {
          finalData.last.accCustomer!.add(AccountCustomer(
            customerAccountId: generateId(RecordType.accCustomer),
            customerAccountName: element[setting["accName"]],
            customerCardNumber: element[setting["customerCardNumber"]],
            customerVAT: element[setting["customerVAT"]],
            mainAccount: finalData.last.accId,
          ));
        }
      }
    }
    print(finalData.length);
    int i = 0;
    // await FirebaseFirestore.instance.collection(Const.accountsCollection).doc("set").set({"s":"s"});
    for (var element in finalData) {
      i++;

      print( i);

      await HiveDataBase.accountModelBox.put(element.accId, element);
      for(AccountCustomer customer in element.accCustomer??[]){
        await HiveDataBase.accountCustomerBox.put(customer.customerAccountId, customer);

      }
      await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(element.accId).set(element.toJson(), SetOptions(merge: true));
/*      HiveDataBase.accountModelBox.put(element.accId, element);
 request.time < timestamp.date(2030, 12, 4)
      if (!element.accIsParent! || element.accParentId != null) {
        FirebaseFirestore.instance.collection(Const.accountsCollection).doc(element.accParentId).update({
          'accChild': FieldValue.arrayUnion([element.accId]),
        });*/
      // FirebaseFirestore.instance.collection(Const.accountsCollection).doc(element.accId).update({
      //   "accParentId":getAccountIdFromText(element.accParentId)
      // });
      // }
    }
  }

  Future<void> addCheque() async {
    List<GlobalModel> finalData = [];
    var cheqCode = 0;
    for (var i = 0; i < widget.productList.length; i++) {
      List<String> element = widget.productList[i];
      cheqCode++;
      String cheqId = generateId(RecordType.cheque);

      await Future.delayed(const Duration(milliseconds: 100));
      String cheqType = element[setting["cheqType"]].removeAllWhitespace == "شيكات مدفوعة".removeAllWhitespace ? Const.chequeTypePay : Const.chequeTypePay;
      String cheqStatus = element[setting["cheqStatus"]].removeAllWhitespace == "مدفوعة".removeAllWhitespace ? Const.chequeStatusPaid : Const.chequeStatusNotPaid;
      // print(element[setting["cheqPrimeryAccount"]].replaceAll("-", ""));
      // print(element[setting["cheqPrimeryAccount"]]);
      String cheqPrimeryAccount = getAccountIdFromText("اوراق الدفع");
      // print(element[setting["cheqSecoundryAccount"]].toString().split("-")[1]);
      // print(element[setting["cheqSecoundryAccount"]].toString().split("-")[0]);

      String cheqSecoundryAccount = getAccountIdFromText(element[setting["cheqSecoundryAccount"]].toString().replaceAll("-", ""));
      if (cheqSecoundryAccount == '') {
        print(element[setting["cheqSecoundryAccount"]]);
      }
      String cheqBankAccount = getAccountIdFromText("المصرف");
      String des = "سند قيد مولد من شيك رقم $cheqCode";
      print(element[setting["cheqAllAmount"]].replaceAll(",", ""));
      double cheqAllAmount = double.parse(element[setting["cheqAllAmount"]].replaceAll(",", ""));
      int year = int.parse(element[setting["cheqDate"]].toString().split("-")[2]);
      int min = int.parse(element[setting["cheqDate"]].toString().split("-")[1]);
      int sec = int.parse(element[setting["cheqDate"]].toString().split("-")[0]);
      int yearDue = int.parse(element[setting["cheqDateDue"]].toString().split("-")[2]);
      int minDue = int.parse(element[setting["cheqDateDue"]].toString().split("-")[1]);
      int secDue = int.parse(element[setting["cheqDateDue"]].toString().split("-")[0]);
      DateTime cheqDate = DateTime(year, min, sec);
      DateTime cheqDateDue = DateTime(yearDue, minDue, secDue);
      finalData.add(GlobalModel(
        cheqAllAmount: cheqAllAmount.toString(),
        cheqBankAccount: cheqBankAccount,
        cheqCode: cheqCode.toString(),
        cheqDate: cheqDate.toString(),
        cheqDeuDate: cheqDateDue.toString(),
        entryBondId: generateId(RecordType.entryBond),
        cheqId: cheqId,
        cheqName: "${element[setting["cheqType"]]}رقم الورقة ${element[setting["cheqNum"]]}",
        cheqPrimeryAccount: cheqPrimeryAccount,
        cheqSecoundryAccount: cheqSecoundryAccount,
        entryBondRecord: [
          EntryBondRecordModel("01", cheqAllAmount, 0, cheqPrimeryAccount, des),
          EntryBondRecordModel("02", 0, cheqAllAmount, cheqSecoundryAccount, des),
        ],
        cheqRemainingAmount: cheqStatus == Const.chequeStatusPaid ? "0" : cheqAllAmount.toString(),
        cheqStatus: cheqStatus,
        cheqType: cheqType,
        globalType: Const.globalTypeCheque,
      ));
    }
    print(finalData.length);
    for (var element in finalData) {
      print(element.toFullJson());

      HiveDataBase.globalModelBox.put(element.cheqId, element);
    }
  }
}
