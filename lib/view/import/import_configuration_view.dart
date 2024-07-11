import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
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

  Map<String, RecordType> typeMap = {"حسابات": RecordType.account, "منتجات": RecordType.product};
  
  Map configProduct = {
  'اسم المادة' :'prodName',
  'رمز المادة' :'prodCode',
  // 'اسم المجموعة' :'prodParentId',
  'سعر المستهلك' :'prodCustomerPrice',
  'سعر جملة' :'prodWholePrice',
  'سعر مفرق' :'prodRetailPrice',
  'سعر التكلفة' :'prodCostPrice',
  'اقل سعر مسموح' :'prodMinPrice',
  'باركود المادة' :'prodBarcode',
  'هل يخضع ضريبة' :'prodHasVat',
  'رمز المجموعة' :'prodParentId',
  'نوع المادة' :'prodType',
  };

  Map configAccount = {
    "الاسم": "accName",
    "بيان الحساب": "accComment",
    "النوع": "accType",
    "رمز الحساب": "accCode",
  "نوع الضريبة" : 'accVat',
  "اسم المجموعة" : 'accParentId',
  };

  Map config = {};
  Map setting = {};

  RecordType? type;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
                    }
                    setState(() {});
                  }),
              SizedBox(
                width: 20,
              ),
              Text("النوع"),
            ],
          ),
          if (type == null)
            Expanded(child: SizedBox())
            else
              Expanded(
              child: SizedBox(
                  width: double.infinity,
                  child:Wrap(
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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(config.keys.toList()[index]),
                                    Text("| |"),
                                    Text(" V"),
                                    SizedBox(
                                      height: 30,
                                      width: 300,
                                      child: DropdownButton<int>(

                                          value: setting[config.values.toList()[index]],
                                          items: widget.rows
                                              .map((e) => DropdownMenuItem(
                                                    value: widget.rows.indexOf(e!),
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
            ),
          ElevatedButton(
              onPressed: () async {
                if (type == RecordType.product) {
                  await addProduct();
                } else if (type == RecordType.account) {
                  await addAccount();
                }
                // Get.offAll(() => HomeView());
              },
              child: Text("ending")),
          SizedBox(
            height: 70,
          ),
          Text("مثال"),
          SizedBox(
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

  Future<void> addProduct() async {
    List<ProductModel> finalData = [];
    for (var element in widget.productList) {
      print(element[setting["prodName"]]);
      bool isGroup = !(element[setting['prodType']].removeAllWhitespace=="خدمية"||element[setting['prodType']].removeAllWhitespace=="مستودعية");
      var code = element[setting["prodCode"]].replaceAll(element[setting["prodParentId"]], "");
      var parentId = "L"+element[setting["prodParentId"]];
      var isRoot = element[setting["prodParentId"]].isBlank;
      print("code "+code);
      String chechIsExist = isGroup ?getProductIdFromName(element[setting["prodName"]].replaceAll("- ", "")):getProductIdFromName(element[setting["prodName"]]);
      // print("parentId "+parentId);
      // print("FullCode "+element[setting["prodCode"]]);
      // print("isRoot "+isRoot.toString());
      // print(element[setting['prodType']].removeAllWhitespace);
      // print(element[setting['prodType']].removeAllWhitespace=="مستودعية");
      // print(!(element[setting['prodType']].removeAllWhitespace=="خدمية"||element[setting['prodType']].removeAllWhitespace=="مستودعية"));
      // print("===");
      if(chechIsExist=="") {
        finalData.add(ProductModel(
        prodId: generateId(RecordType.product),
        prodName: element[setting["prodName"]],
        // prodCode: element[setting["prodCode"]],
          prodCode:  code,
        prodBarcode: element[setting["prodBarcode"]],
        prodIsLocal: !element[setting["prodName"]].contains("مستعمل"),
        prodFullCode: "L"+element[setting["prodCode"]],
        // prodGroupCode: element[setting["prodGroupCode"]],
        //todo
        prodCustomerPrice : element[setting['prodCustomerPrice']],
        prodWholePrice : element[setting['prodWholePrice']],
        prodRetailPrice : element[setting['prodRetailPrice']],
        prodCostPrice : element[setting['prodCostPrice']],
        prodMinPrice : element[setting['prodMinPrice']],
       
        prodType : element[setting['prodType']].removeAllWhitespace=="خدمية"?Const.productTypeService:Const.productTypeStore,
        // prodParentId : element[setting['prodParentId']].isBlank!?null:parentId,
        // prodIsParent : element[setting['prodParentId']].isBlank,
        prodParentId :  parentId.isBlank!?null:parentId,
        prodIsParent :parentId.isBlank,
        prodIsGroup: isGroup
      ));
      }
    }
    var i = 0;

    print(finalData.length);
    print("--"*30);
    // for(var i in finalData){
    //   if(i.prodIsGroup!){
    //   print(i.toFullJson());
    //   }
    // }
    // print("--"*30);
    //  for(var i in finalData){
    //   if(getProductIdFromFullName(i.prodFullCode!)!=""){
    //  print(i.prodName!+"|  -  |"+i.prodFullCode!+"    "+getProductNameFromId(getProductIdFromFullName(i.prodFullCode!)));
    // //  await FirebaseFirestore.instance.collection(Const.productsCollection).doc(getProductIdFromFullName(i.prodFullCode!)).delete();
    // //   HiveDataBase.productModelBox.delete(getProductIdFromFullName(i.prodFullCode!));
    // //   await FirebaseFirestore.instance.collection(Const.productsCollection).doc(i.prodId).set(i.toJson());
    // //   HiveDataBase.productModelBox.put(i.prodId, i);
    //   }
    // }
    
    for(var i in finalData){
      print(i.prodName!+"|  -  |"+i.prodFullCode!);
    
    }




    ProductViewModel productViewModel = Get.find<ProductViewModel>();
    for (var element in finalData) {
     i++;
     print(i.toString() + " OF "+finalData.length.toString() );
     await FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.prodId).set(element.toJson());
     HiveDataBase.productModelBox.put(element.prodId, element);
    }
    i = 0;
    for (var index = 0 ;index < finalData.length; index ++ ) {
      ProductModel element = finalData[index];
      i++;
      print(i.toString() + " OF "+finalData.length.toString() );
      if(!element.prodIsParent!){
        FirebaseFirestore.instance.collection(Const.productsCollection).doc(getProductIdFromFullName(element.prodParentId)).update({
          'prodChild': FieldValue.arrayUnion([element.prodId]),
        });
       productViewModel.productDataMap[getProductIdFromFullName(element.prodParentId!)]!.prodChild?.add(element.prodId);
        HiveDataBase.productModelBox.put(getProductIdFromFullName(element.prodParentId!),  productViewModel.productDataMap[getProductIdFromFullName(element.prodParentId!)]!);
        FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.prodId).update({
          "prodParentId":getProductIdFromFullName(element.prodParentId)
        });
        finalData[index].prodParentId = getProductIdFromFullName(element.prodParentId);
        HiveDataBase.productModelBox.put(index, finalData[index]);
       ProductModel prodParentId = getProductModelFromId(getProductIdFromFullName(element.prodParentId))!;
        // if(prodParentId.prodGroupPad==null){
        //   int pad= element.prodFullCode!.replaceAll(prodParentId.prodFullCode!, "").length;
        //   await FirebaseFirestore.instance.collection(Const.productsCollection).doc(prodParentId.prodId).update({
        //     "prodGroupPad":pad
        //   });
        // }
      }
    }
  }

  Future<void> addAccount() async {
    AccountViewModel accountViewModel = Get.find<AccountViewModel>();
    List<AccountModel> finalData = [];
    for (var element in widget.productList) {
      if(getAccountIdFromName(element[setting["accName"]])==null) {
        finalData.add(AccountModel(
        accId: generateId(RecordType.account),
        accName: element[setting["accName"]],
        accCode: element[setting["accCode"]],
        accComment: '',
        // accType: element[setting["accType"]]=="حساب تجميعي"?Const.accountTypeAggregateAccount:element[setting["accType"]]=="حساب ختامي"?Const.accountTypeFinalAccount:Const.accountTypeDefault,
        accType: Const.accountTypeDefault,
        accVat : 'GCC',
        accParentId : element[setting['accParentId']].isEmpty?null:element[setting['accParentId']],
        accIsParent : element[setting['accParentId']].isEmpty,
      ));
      }
    }
    int i =0;
    print(finalData.length);


  for (var element in finalData) {
       print("|"+element.accName!+"|");
    }
    // for (var element in finalData) {
    //   i++;
    //   print(i.toString());
    //   // await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(element.accId).set(element.toJson());
    //   // await accountViewModel.addNewAccount(element, withLogger: false);
    //   await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(element.accId).set(element.toJson());

    // }
    // i=0;
    // for (var element in finalData) {
    //   i++;
    //   print(i.toString());
    //   if(!element.accIsParent! ||element.accParentId!=null){
    //     FirebaseFirestore.instance.collection(Const.accountsCollection).doc(getAccountIdFromText(element.accParentId)).update({
    //       'accChild': FieldValue.arrayUnion([element.accId]),
    //     });
    //     FirebaseFirestore.instance.collection(Const.accountsCollection).doc(element.accId).update({
    //       "accParentId":getAccountIdFromText(element.accParentId)
    //     });
    //   }
    // }
  }
}
