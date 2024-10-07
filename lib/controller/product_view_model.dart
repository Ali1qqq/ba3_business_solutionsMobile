import 'dart:io';
import 'package:ba3_business_solutions/controller/changes_view_model.dart';
import 'package:ba3_business_solutions/controller/invoice_view_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ba3_business_solutions/model/product_record_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import '../Const/const.dart';
import '../model/invoice_record_model.dart';
import '../model/product_model.dart';
import '../model/product_tree.dart';
import '../utils/logger.dart';
import '../view/products/widget/product_record_data_source.dart';

class ProductViewModel extends GetxController {
  // RxMap<String, List<ProductRecordModel>> productRecordMap = <String, List<ProductRecordModel>>{}.obs;
  RxMap<String, ProductModel> productDataMap = <String, ProductModel>{}.obs;
  late ProductRecordDataSource recordDataSource;

  ProductModel? productModel;

  ProductViewModel() {
    getAllProduct();
  }

  initGlobalProduct(GlobalModel globalModel) async {
    // Future<void> saveInvInProduct(List<InvoiceRecordModel> record, invId, type,date) async {
    Map<String, List> allRecTotal = {};
    bool isPay = globalModel.invType == Const.invoiceTypeBuy || globalModel.invType == Const.invoiceTypeAdd;
    int correctQuantity = isPay ? 1 : -1;
    for (int i = 0; i < globalModel.invRecords!.length; i++) {
      if (globalModel.invRecords![i].invRecId != null) {
        if (allRecTotal[globalModel.invRecords![i].invRecProduct] == null) {
          allRecTotal[globalModel.invRecords![i].invRecProduct!] = [(correctQuantity * globalModel.invRecords![i].invRecQuantity!)];
        } else {
          allRecTotal[globalModel.invRecords![i].invRecProduct]!.add((correctQuantity * globalModel.invRecords![i].invRecQuantity!));
        }
      }
    }
    allRecTotal.forEach((key, value) {
      var recCredit = value.reduce((value, element) => value + element);
      if (productDataMap[key] != null) {
        bool isStoreProduct = productDataMap[key]!.prodType == Const.productTypeStore;
        InvoiceRecordModel element = globalModel.invRecords!.firstWhere((element) => element.invRecProduct == key);
        // FirebaseFirestore.instance.collection(Const.productsCollection).doc(key).collection(Const.recordCollection).doc(globalModel.invId).set(); //prodRecSubVat
        if (productDataMap[key]?.prodRecord == null) {
          productDataMap[key]?.prodRecord = [
            ProductRecordModel(globalModel.invId, globalModel.invType, key, (isStoreProduct ? recCredit : "0").toString(), element.invRecId, element.invRecTotal.toString(), element.invRecSubTotal.toString(), globalModel.invDate, element.invRecVat.toString(), globalModel.invStorehouse)
          ];
        } else {
          productDataMap[key]?.prodRecord?.removeWhere((element) => element.invId == globalModel.invId);
          productDataMap[key]
              ?.prodRecord
              ?.add(ProductRecordModel(globalModel.invId, globalModel.invType, key, (isStoreProduct ? recCredit : "0").toString(), element.invRecId, element.invRecTotal.toString(), element.invRecSubTotal.toString(), globalModel.invDate, element.invRecVat.toString(), globalModel.invStorehouse));
        }
      }
      //WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
      //   update();
      // initModel();
      // initPage();
      // go(lastIndex);
      // });
    });
  }

  double getAvreageBuy(ProductModel productModel) {
    InvoiceViewModel invoiceViewModel = Get.find<InvoiceViewModel>();
    double avg = 0;
    int count = 0;
    for (ProductRecordModel element in productModel.prodRecord ?? []) {
      GlobalModel globalModel = invoiceViewModel.invoiceModel[element.invId!]!;
      count = (int.parse(element.prodRecQuantity ?? "0")) + count;
      if (globalModel.invType == Const.invoiceTypeBuy) {
        avg = ((double.parse(element.prodRecSubTotal ?? "0") * int.parse(element.prodRecQuantity ?? "0")) + ((count - int.parse(element.prodRecQuantity ?? "0")) * avg)) / count;
      }
    }
    return avg;
  }

  void deleteGlobalProduct(GlobalModel globalModel) {
    globalModel.invRecords?.forEach((element) {
      productDataMap[element.invRecProduct]?.prodRecord?.removeWhere((element) => element.invId == globalModel.invId);
    });
    // WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
    update();
    initModel();
    initPage();
    go(lastIndex);
    //});
  }



  List<ProductModel> searchOfProductByText(query,bool withGroup) {

    List<ProductModel> productsForSearch = [];
     query = replaceArabicNumbersWithEnglish(query);
    String query2 = '';
    String query3 = '';

    if (query.contains(" ")) {
      query3 = query.split(" ")[0];
      query2 = query.split(" ")[1];
    } else {
      query3 = query;
      query2 = query;
    }
    productsForSearch = productDataMap.values.where((element) {
      if( HiveDataBase.getWithFree()) {
        return  !(element.prodName?.startsWith("F")??true);
      } else {
        return true;
      }
    },).toList().where((item) {
      bool prodName = item.prodName.toString().toLowerCase().contains(query3.toLowerCase()) && item.prodName.toString().toLowerCase().contains(query2.toLowerCase());
      // bool prodCode = item.prodCode.toString().toLowerCase().contains(query.toLowerCase());
      bool prodCode = item.prodFullCode.toString().toLowerCase().contains(query.toLowerCase());
      bool prodBarcode = item.prodBarcode.toString().toLowerCase().contains(query.toLowerCase());
      //bool prodId = item.prodId.toString().toLowerCase().contains(query.toLowerCase());
      return (prodName || prodCode || prodBarcode) && item.prodIsGroup==withGroup;
    }).toList();

    return productsForSearch.toList();
  }
/*  List<ProductModel> searchOfProductGroupByText(query) {

    List<ProductModel> productsForSearch = [];
     query = replaceArabicNumbersWithEnglish(query);
    String query2 = '';
    String query3 = '';
    if (query.contains(" ")) {
      query3 = query.split(" ")[0];
      query2 = query.split(" ")[1];
    } else {
      query3 = query;
      query2 = query;
    }

    productsForSearch = productDataMap.values.where((element) => element.prodChild?.isNotEmpty??false,).where((element) {
      if( HiveDataBase.getIsNunFree()) {
        return  !(element.prodName?.startsWith("F")??true);
      } else {
        return true;
      }
    },).toList().where((item) {
      bool prodName = item.prodName.toString().toLowerCase().contains(query3.toLowerCase()) && item.prodName.toString().toLowerCase().contains(query2.toLowerCase());
      // bool prodCode = item.prodCode.toString().toLowerCase().contains(query.toLowerCase());
      bool prodCode = item.prodFullCode.toString().toLowerCase().contains(query.toLowerCase());
      bool prodBarcode = item.prodBarcode.toString().toLowerCase().contains(query.toLowerCase());
      //bool prodId = item.prodId.toString().toLowerCase().contains(query.toLowerCase());
      return (prodName || prodCode || prodBarcode) && !item.prodIsGroup!;
    }).toList();

    return productsForSearch.toList();
  }*/



  void getAllProduct() async {
    if (HiveDataBase.productModelBox.values.isEmpty) {

      FirebaseFirestore.instance.collection(Const.productsCollection).get().then((value) async {
        productDataMap.clear();
        for (var element in value.docs) {
          HiveDataBase.productModelBox.put(element.id, ProductModel.fromJson(element.data()));
          productDataMap[element.id] = ProductModel.fromJson(element.data());
        }
        // WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
        update();
        initModel();
        initPage();
        go(lastIndex);
        // });
      });
    } else {
      for (var element in HiveDataBase.productModelBox.values.toList()) {
        productDataMap[element.prodId!] = element;
      }
      if (HiveDataBase.isFree.get("isFree")!) {
        // productDataMap.values.where((element) => !element.prodIsGroup!&&(HiveDataBase.isFree.get("isFree")! ? element.prodIsLocal!: true)).toList();
        productDataMap = Map.fromEntries(productDataMap.entries
                .where(
                  (element) => element.value.prodIsLocal ?? false,
                )
                .toList())
            .obs;
      }
      //  WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
      // correct();
      update();
      initModel();
      initPage();
      go(lastIndex);
      // for (var i =0;i< productDataMap.values.toList().length;i++){
      //   ProductModel product =  productDataMap.values.toList()[i];
      //   if(product.prodIsLocal == null){
      //     product.prodIsLocal = true;
      //      HiveDataBase.productModelBox.put(product.prodId, product);
      //       FirebaseFirestore.instance.collection(Const.productsCollection).doc(product.prodId).set(product.toJson());
      //   }
      // }
      //  for (var i =0;i< productDataMap.values.toList().length;i++){
      //   ProductModel product =  productDataMap.values.toList()[i];
      //   if(product.prodCode == "L0505163"){
      //     product.prodCode = "1";
      //     product.prodFullCode = "L0501";
      //     HiveDataBase.productModelBox.put(product.prodId, product);
      //     FirebaseFirestore.instance.collection(Const.productsCollection).doc(product.prodId).set(product.toJson());
      //   }
      // }
      // });
      // for (var i =0;i< productDataMap.values.toList().length;i++){
      //   ProductModel product =  productDataMap.values.toList()[i];
      //   if(product.prodCustomerPrice!.contains("٫") ||
      //       product.prodRetailPrice!.contains("٫")||
      //       product.prodMinPrice!.contains("٫")||
      //       product.prodCostPrice!.contains("٫")||
      //       product.prodWholePrice!.contains("٫")) {
      //     product.prodCustomerPrice = (product.prodCustomerPrice)!.split("٫")[0];
      //     product.prodRetailPrice = (product.prodRetailPrice)!.split("٫")[0];
      //     product.prodMinPrice = (product.prodMinPrice)!.split("٫")[0];
      //     product.prodCostPrice = (product.prodCostPrice)!.split("٫")[0];
      //     product.prodWholePrice = (product.prodWholePrice)!.split("٫")[0];
      //      updateProduct(product);
      //   }
      // }
    }
    //  for(MapEntry<String, ProductModel> entry in productDataMap.entries.toList()){
    //     if(entry.value.prodName! == "USED ACER"){
    //       productDataMap[entry.key]!.prodCode = "70";
    //       productDataMap[entry.key]!.prodFullCode = "L070";
    //       HiveDataBase.productModelBox.put(entry.key, productDataMap[entry.key]!);
    //       FirebaseFirestore.instance.collection(Const.productsCollection).doc(entry.key).set(productDataMap[entry.key]!.toJson());
    //     }
    //      if(entry.value.prodName! == "RENPHO"){
    //       productDataMap[entry.key]!.prodCode = "71";
    //       productDataMap[entry.key]!.prodFullCode = "L071";
    // HiveDataBase.productModelBox.put(entry.key, productDataMap[entry.key]!);
    // FirebaseFirestore.instance.collection(Const.productsCollection).doc(entry.key).set(productDataMap[entry.key]!.toJson());
    //     }
    //   }
  }

// Future<void> correct () async {
//   int i =0 ;
//   for (var index = 0 ;index < productDataMap.length; index ++ ) {
//         ProductModel element = productDataMap.values.toList()[index];
//         // if(element.prodFullCode == "F003540"){
//         //   print(element.toJson());
//         //   print(productDataMap[element.prodParentId]!.toJson());
//         // //  if(element.prodName!.contains("SKINARMA IPHONE 15 PRO KIRA")){
//         // //     element.prodIsGroup = false;
//         // productDataMap[element.prodParentId]!.prodChild!.add(element.prodId);
//         //     HiveDataBase.productModelBox.put(element.prodParentId,  productDataMap[element.prodParentId]!);
//         // //   await FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.prodId).update(element.toJson());
//         // //  }
//         // }
//         // if(
//         //   (double.tryParse(element.prodMinPrice??"0")==null||
//         //   double.tryParse(element.prodCostPrice??"0")==null||
//         //   double.tryParse(element.prodWholePrice??"0")==null||
//         //   double.tryParse(element.prodRetailPrice??"0")==null||
//         //   double.tryParse(element.prodCustomerPrice??"0")==null
//         //   )&&(element.prodMinPrice!="" &&element.prodCostPrice!="" &&element.prodWholePrice!="" &&element.prodRetailPrice!="" &&element.prodCustomerPrice!="")){
//         //   print(element.prodName.toString()+"| "+element.prodMinPrice.toString()+" "+element.prodCostPrice.toString()+" "+element.prodWholePrice.toString()+" "+element.prodRetailPrice.toString()+" "+element.prodCustomerPrice.toString());
//         //     element.prodMinPrice = double.parse( element.prodMinPrice!.replaceAll(",", "").replaceAll("\"", "")).toString();
//         //     element.prodCostPrice = double.parse( element.prodCostPrice!.replaceAll(",", "").replaceAll("\"", "")).toString();
//         //     element.prodWholePrice = double.parse( element.prodWholePrice!.replaceAll(",", "").replaceAll("\"", "")).toString();
//         //     element.prodRetailPrice = double.parse( element.prodRetailPrice!.replaceAll(",", "").replaceAll("\"", "")).toString();
//         //     element.prodCustomerPrice = double.parse( element.prodCustomerPrice!.replaceAll(",", "").replaceAll("\"", "")).toString();
//         //   print(element.prodName.toString()+"| "+element.prodMinPrice.toString()+" "+element.prodCostPrice.toString()+" "+element.prodWholePrice.toString()+" "+element.prodRetailPrice.toString()+" "+element.prodCustomerPrice.toString());
//         //   HiveDataBase.productModelBox.put(element.prodId,  element);
//         //   await FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.prodId).update(element.toJson());
//         // }
//           //      if(!element.prodName!.contains("مستعمل")&&!element.prodIsLocal!&&!element.prodName!.contains("F-")){
//           //       print(i.toString() );
//           //       i++;
//           //       print(element.prodName);
//           //      element.prodName="F-"+element.prodName!;
//           //  HiveDataBase.productModelBox.put(element.prodId , element);
//
//           // await FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.prodId).update(element.toJson());
//           //   }
//       //   if(!(element.prodParentId?.contains("prod")??true)){
//       //       //  print(element.prodName);
//       //       //  print(element.toJson());
//       //       if(!element.prodIsParent!){
//       //         element.prodParentId = 'L'+element.prodParentId!;
//       //         element.prodFullCode = 'L'+element.prodFullCode!;
//       //          print(element.prodName);
//       //        print(element.toJson());
//       //   FirebaseFirestore.instance.collection(Const.productsCollection).doc(getProductIdFromFullName(element.prodParentId)).update({
//       //     'prodChild': FieldValue.arrayUnion([element.prodId]),
//       //   });
//       //  productDataMap[getProductIdFromFullName(element.prodParentId!)]!.prodChild?.add(element.prodId);
//       //   HiveDataBase.productModelBox.put(getProductIdFromFullName(element.prodParentId!),  productDataMap[getProductIdFromFullName(element.prodParentId!)]!);
//       //   FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.prodId).update({
//       //     "prodParentId":getProductIdFromFullName(element.prodParentId)
//       //   });
//       //   productDataMap[element.prodId]!.prodParentId = getProductIdFromFullName(element.prodParentId);
//       //   HiveDataBase.productModelBox.put(element.prodId,  productDataMap[element.prodId]!);
//       // }
//       //   }
//
//        // i++;
//       // print(i.toString() + " OF "+productDataMap.values.toList().length.toString() );
//
//     }
//     // for (var i =0;i< productDataMap.values.toList().length;i++){
//     //     ProductModel product =  productDataMap.values.toList()[i];
//     //     if(product.prodFullCode == "L0505163"){
//     //       product.prodCode = "1";
//     //       product.prodFullCode = "L0501";
//     //       HiveDataBase.productModelBox.put(product.prodId, product);
//     //       FirebaseFirestore.instance.collection(Const.productsCollection).doc(product.prodId).set(product.toJson());
//     //     }
//     //   }
// }
  String getNextProductCode({String? perantId}) {
    int code = 0;
    if (productDataMap.isEmpty) {
      return "00";
    }
    if (perantId != null) {
      List<String?>? childIds = productDataMap[perantId]?.prodChild?.map((e) => productDataMap[e]?.prodCode).toList();
      if (childIds != null && childIds.isNotEmpty) {
        return (int.parse(childIds.last!) + 1).toString().padLeft(productDataMap[perantId]!.prodGroupPad ?? 2, "0");
      } else {
        return "0".padLeft(productDataMap[perantId]!.prodGroupPad ?? 2, "0");
      }
    } else {
      List<String?>? parentIds = productDataMap.values.toList().where((element) => element.prodIsParent!).map((e) => e.prodCode).toList();
      if (parentIds.isNotEmpty) {
        return ((int.tryParse(parentIds.last!) ?? 0) + 1).toString().padLeft(2, "0");
      }
    }
    return code.toString();
  }

  int padNumber = 1;

  String getFullCodeOfProduct(String accID) {
    if (productDataMap[accID]!.prodIsParent!) {
      String code = productDataMap[accID]!.prodCode!.padLeft(padNumber, "0");
      return code;
    } else {
      // if(productDataMap[accID] == null){
      //   print(accID);
      //    print("object");
      // }
      // if(productDataMap[productDataMap[accID]!.prodParentId!] == null){
      //   print(productDataMap[accID]!.toJson()!);
      //   print("object");
      // }
      int? pad = productDataMap[productDataMap[accID]!.prodParentId!]!.prodGroupPad;
      String code = productDataMap[accID]!.prodCode!.padLeft(pad ?? padNumber, "0");
      var perCode = getFullCodeOfProduct(productDataMap[accID]!.prodParentId!);
      return perCode + code;
    }
  }

  void createProduct(ProductModel editProductModel, {withLogger = false}) async {
    var fullCode = '';
    if (editProductModel.prodParentId == null) {
      fullCode = editProductModel.prodCode!;
    } else {
      fullCode = productDataMap[editProductModel.prodParentId]!.prodFullCode! + editProductModel.prodCode!.padLeft(productDataMap[editProductModel.prodParentId]!.prodGroupPad ?? padNumber, "0");
    }
    ProductModel? productModel = productDataMap.values.toList().firstWhereOrNull((element) => element.prodFullCode == fullCode);
    if (productModel != null) {
      Get.snackbar("فحص المطاييح", "هذا المطيح مستخدم من قبل");
      return;
    }
    editProductModel.prodFullCode = fullCode;
    editProductModel.prodId = generateId(RecordType.product);
    editProductModel.prodIsGroup ??= false;
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();

    if (editProductModel.prodParentId == null) {
      editProductModel.prodIsParent = true;
    } else {
      FirebaseFirestore.instance.collection(Const.productsCollection).doc(editProductModel.prodParentId).update({
        'prodChild': FieldValue.arrayUnion([editProductModel.prodId]),
      });
      if (productDataMap[editProductModel.prodParentId]?.prodChild == null) {
        productDataMap[editProductModel.prodParentId]?.prodChild = [editProductModel.prodId];
        HiveDataBase.productModelBox.put(editProductModel.prodParentId,getProductModelFromId(editProductModel.prodParentId)!..prodChild=[editProductModel.prodId]);

      } else {
        HiveDataBase.productModelBox.put(editProductModel.prodParentId,getProductModelFromId(editProductModel.prodParentId)!..prodChild!.add(editProductModel.prodId));
        productDataMap[editProductModel.prodParentId]?.prodChild?.add(editProductModel.prodId);
      }
      changesViewModel.addChangeToChanges(productDataMap[editProductModel.prodParentId]!.toFullJson(), Const.productsCollection);
      editProductModel.prodIsParent = false;
    }
    if (withLogger) logger(newData: editProductModel);
    await FirebaseFirestore.instance.collection(Const.productsCollection).doc(editProductModel.prodId).set(editProductModel.toJson());
    HiveDataBase.productModelBox.put(editProductModel.prodId,editProductModel);
    changesViewModel.addChangeToChanges(editProductModel.toFullJson(), Const.productsCollection);
    Get.snackbar("فحص المطاييح", ' تم اضافة المطيح');
  }

  addProductToMemory(Map json) {
    print("addProductToMemory");
    ProductModel productModel = ProductModel.fromJson(json);
    List<ProductRecordModel> oldDate = [];
    if (productDataMap[productModel.prodId!] != null) {
      oldDate = productDataMap[productModel.prodId!]!.prodRecord!;
    }
    productModel.prodRecord = oldDate;
    productDataMap[productModel.prodId!] = productModel;
    HiveDataBase.productModelBox.put(productModel.prodId, productModel);
    update();
    initModel();
    initPage();
    go(lastIndex);
  }

  void updateProduct(ProductModel editProductModel, {withLogger = false}) {
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    var fullCode = '';
    if (editProductModel.prodParentId == null) {
      fullCode = editProductModel.prodCode!;
    } else {
      fullCode = productDataMap[editProductModel.prodParentId]!.prodFullCode! + editProductModel.prodCode!.padLeft(productDataMap[editProductModel.prodParentId]!.prodGroupPad ?? padNumber, "0");
    }
    ProductModel? productModel = productDataMap.values.toList().firstWhereOrNull((element) => element.prodFullCode == fullCode);
    if (productModel != null && editProductModel.prodId != productModel.prodId) {
      Get.snackbar("فحص المطاييح", "هذا المطيح مستخدم من قبل");
      return;
    }
    editProductModel.prodFullCode = fullCode;
    if (withLogger) logger(oldData: productDataMap[editProductModel.prodId], newData: editProductModel);
    editProductModel.prodIsGroup ??= false;
    if (editProductModel.prodParentId == null) {
      editProductModel.prodIsParent = true;
    } else {
      FirebaseFirestore.instance.collection(Const.productsCollection).doc(editProductModel.prodParentId).update({
        'prodChild': FieldValue.arrayUnion([editProductModel.prodId]),
      });

      if (productDataMap[editProductModel.prodParentId]?.prodChild == null) {
        productDataMap[editProductModel.prodParentId]?.prodChild = [editProductModel.prodId];
        HiveDataBase.productModelBox.put(editProductModel.prodParentId,getProductModelFromId(editProductModel.prodParentId)!..prodChild=[editProductModel.prodId]);

      } else {
        productDataMap[editProductModel.prodParentId]?.prodChild?.add(editProductModel.prodId);
        HiveDataBase.productModelBox.put(editProductModel.prodParentId,getProductModelFromId(editProductModel.prodParentId)!..prodChild!.add(editProductModel.prodId));

      }
      changesViewModel.addChangeToChanges(productDataMap[editProductModel.prodParentId]!.toFullJson(), Const.productsCollection);
      editProductModel.prodIsParent = false;
    }
    FirebaseFirestore.instance.collection(Const.productsCollection).doc(editProductModel.prodId).update(editProductModel.toJson());
    HiveDataBase.productModelBox.put(editProductModel.prodId,editProductModel);

    changesViewModel.addChangeToChanges(editProductModel.toFullJson(), Const.productsCollection);
    update();
  }

  int getCountOfProduct(ProductModel productModel) {
    List<ProductRecordModel> allRec = [];

    allRec.addAll(productModel.prodRecord ?? []);
    productModel.prodChild?.forEach((element) {
      allRec.addAll(productDataMap[element]?.prodRecord ?? []);
    });
    if (allRec.isEmpty) return 0;
    int _ = allRec.map((e) => int.parse(e.prodRecQuantity!)).toList().reduce((value, element) => value + element);
    return _;
  }

  Future<void> deleteProduct({withLogger = false}) async {
    if (withLogger) logger(oldData: productModel);
    if (productModel?.prodParentId != null) {
      await FirebaseFirestore.instance.collection(Const.productsCollection).doc(productModel!.prodParentId).update({
        'prodChild': FieldValue.arrayRemove([productModel!.prodId]),
      });
    }
    FirebaseFirestore.instance.collection(Const.productsCollection).doc(productModel?.prodId).delete();
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addRemoveChangeToChanges(productModel!.toFullJson(), Const.productsCollection);
    productModel == null;

    update();
  }

  void removeProductFromMemory(Map json) {
    ProductModel productModel = ProductModel.fromJson(json);
    if (productModel.prodParentId != null) {
      productDataMap[productModel.prodParentId]?.prodChild?.remove(productModel.prodId);
      HiveDataBase.productModelBox.put(productModel.prodParentId, productDataMap[productModel.prodParentId]!);
    }
    productDataMap.remove(productModel.prodId);
    HiveDataBase.productModelBox.delete(productModel.prodId);
    update();
    initModel();
    initPage();
    go(lastIndex);
  }

  void initProductPage(ProductModel editedProduct) {
    recordDataSource = ProductRecordDataSource(productModel: editedProduct);
  }

  String searchProductIdByName(name) {
    return productDataMap.values.toList().firstWhere((element) => element.prodName == name).prodId!;
  }

  //--=-=-==-==--=-=-=-==-==-=-=-=-=-=-=-=-=-=-=-=-=--=-=-==-=-=--=-

  String? editItem;
  TextEditingController? editCon;

  String? lastIndex;

  List<ProductTree> allProductTree = [];

  TreeController<ProductTree>? treeController;

  void initModel() {
    allProductTree.clear();
    List<ProductModel> rootList = productDataMap.values.toList().where((element) => element.prodIsParent ?? false).toList();
    for (var element in rootList) {
      allProductTree.add(addToModel(element));
    }
  }

  ProductTree addToModel(ProductModel element) {
    // var a = (element.prodChild?.where((e) => productDataMap[e] == null).toList());
    // if(a!.isNotEmpty!){
    //   print(a);
    //   print( element.prodIsLocal);
    //   print( element.prodName);
    //   print( element.prodChild);
    //   //  element.prodChild?.map((e) => ).toList();
    // //   FirebaseFirestore.instance.collection(Const.productsCollection).doc(a.first).delete();
    // //   HiveDataBase.productModelBox.delete(a.first);
    // //   productDataMap[element.prodId]!.prodChild!.remove(a.first);
    // //     FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.prodId).set(productDataMap[element.prodId]!.toJson());
    // //   HiveDataBase.productModelBox.put (element.prodId, productDataMap[element.prodId]!);
    // }
    element.prodChild?.removeWhere((e) => productDataMap[e] == null);
    var list = element.prodChild?.map((e) => addToModel(productDataMap[e]!)).toList();
    // if(list!.length>99){
    //   padNumber=2;
    // }
    productDataMap[element.prodId]?.prodFullCode = getFullCodeOfProduct(element.prodId!);
    ProductTree model = ProductTree.fromJson({"name": element.prodName}, element.prodId, list ?? []);
    return model;
  }

  initPage() {
    treeController = TreeController<ProductTree>(
      roots: allProductTree,
      childrenProvider: (ProductTree node) => node.list,
    );
    update();
  }

  void setupParentList(String parent) {
    allPer.add(productDataMap[parent]!.prodId);
    if (productDataMap[parent]!.prodParentId != null) {
      setupParentList(productDataMap[parent]!.prodParentId!);
    }
  }

  var allPer = [];

  void go(String? parent) {
    if (parent != null) {
      allPer.clear();
      setupParentList(parent);
      var allper = allPer.reversed.toList();
      List<ProductTree> _ = treeController!.roots.toList();
      for (var i = 0; i < allper.length; i++) {
        if (_.isNotEmpty) {
          treeController?.expand(_.firstWhere((element) => element.id == allper[i]));
          _ = _.firstWhereOrNull((element) => element.id == allper[i])?.list ?? [];
        }
      }
    }
  }

  void startRenameChild(String? id) {
    editItem = id;
    editCon = TextEditingController(text: productDataMap[id]!.prodName!);
    update();
  }

  void endRenameChild() {
    FirebaseFirestore.instance.collection(Const.productsCollection).doc(editItem).update({
      "prodName": editCon?.text,
    });
    editItem = null;
    update();
  }

  Future<void> exportProduct(String? oldKey) async {
    List<List> data = [
      ["اسم المادة", "الفاتورة", "العدد", "التاريخ"]
    ];
    List<ProductRecordModel> allRec = [];
    ProductModel _ = productDataMap[oldKey]!;
    allRec.addAll(_.prodRecord ?? []);
    _.prodChild?.forEach((element) {
      allRec.addAll(productDataMap[element]?.prodRecord ?? []);
    });
    allRec.forEach((ProductRecordModel value) {
      data.add([getProductNameFromId(value.prodRecProduct), value.prodType, value.prodRecQuantity, value.prodRecDate]);
    });
    String csv = const ListToCsvConverter().convert(data);
    String? saveData;
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      saveData = await FilePicker.platform.saveFile(fileName: getProductNameFromId(oldKey) + " " + DateTime.now().toString().split(" ")[0] + ".csv");
    } else {
      Directory documents = await getApplicationDocumentsDirectory();
      saveData = (documents.path + "/" + getProductNameFromId(oldKey) + " " + DateTime.now().toString().split(" ")[0] + ".csv");
    }

    if (saveData != null) {
      File file = File(saveData);
      file.writeAsString(csv).then((File file) {
        print('CSV file created: ${file.absolute.path}');
      }).catchError((e) {
        print('Error: $e');
      });
    }
  }

  void createFolderDialog() {
    var nameCon = TextEditingController();
    String? prodParentId;
    String? rootName;
    List<String> rootFolder = productDataMap.values.toList().where((element) => element.prodIsParent! && element.prodIsGroup!).map((e) => e.prodId!).toList();
    Map<String, List<String>> allParent = {};
    Map<String, String> dropDownList = {};
    Get.defaultDialog(
        title: "اختر الطريق",
        content: SizedBox(
          height: Get.height / 2,
          width: Get.height / 2,
          child: StatefulBuilder(builder: (context, setstate) {
            return ListView(
              children: [
                SizedBox(
                  height: 35,
                  width: double.infinity,
                  child: TextFormField(
                    controller: nameCon,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButton(
                    value: rootName,
                    items: rootFolder.map((e) => DropdownMenuItem(value: e, child: Text(getProductNameFromId(e)))).toList(),
                    onChanged: (_) {
                      prodParentId = _;
                      rootName = _;
                      Iterable<ProductModel> a = productDataMap.values.toList().where((element) => element.prodParentId == _ && element.prodIsGroup!);
                      if (a.isNotEmpty) {
                        allParent[_!] = a.toList().map((e) => e.prodId!).toList();
                      }
                      setstate(() {});
                    }),
                for (List<String> element in allParent.values)
                  DropdownButton(
                      value: dropDownList[element.toString()],
                      items: element.map((e) => DropdownMenuItem(value: e, child: Text(getProductNameFromId(e)))).toList(),
                      onChanged: (_) {
                        prodParentId = _;
                        dropDownList[element.toString()] = _!;
                        Iterable<ProductModel> a = productDataMap.values.toList().where((element) => element.prodParentId == _ && element.prodIsGroup!);
                        if (a.isNotEmpty) {
                          allParent[_] = a.toList().map((e) => e.prodId!).toList();
                        }
                        setstate(() {});
                      }),
              ],
            );
          }),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                addFolder(nameCon.text, prodParentId: prodParentId);
                Get.back();
              },
              child: const Text("إضافة")),
          ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("إلغاء")),
        ]);
  }

  void addFolder(name, {String? prodParentId}) {
    int code = 0;
    if (prodParentId == null) {
      code = productDataMap.values.toList().where((element) => element.prodIsParent!).map((e) => (int.tryParse(e.prodCode!) ?? 0)).toList().last + 1;
    } else {
      Iterable<ProductModel> a = productDataMap.values.toList().where((element) => element.prodParentId == prodParentId);
      if (a.isNotEmpty) {
        code = a.map((e) => int.parse(e.prodCode!)).toList().last + 1;
      }
    }
    var prodModel = ProductModel(prodIsGroup: true, prodIsParent: prodParentId == null, prodParentId: prodParentId, prodName: name, prodCode: code.toString(), prodId: generateId(RecordType.product));
    if (prodParentId != null) {
      FirebaseFirestore.instance.collection(Const.productsCollection).doc(prodParentId).update({
        'prodChild': FieldValue.arrayUnion([prodModel.prodId]),
      });
    }
    productDataMap[prodParentId]!.prodChild!.add(prodModel.prodId);
    FirebaseFirestore.instance.collection(Const.productsCollection).doc().set(prodModel.toJson());
    HiveDataBase.productModelBox.put(prodModel.prodId, prodModel);
    HiveDataBase.productModelBox.put(prodParentId, productDataMap[prodParentId]!);
  }
}

String getProductIdFromFullName(name) {
  if (name != null && name != " " && name != "") {
    return Get.find<ProductViewModel>().productDataMap.values.toList().cast<ProductModel?>().firstWhereOrNull((element) => element?.prodFullCode == name)?.prodId ?? "";
  } else {
    return "";
  }
}

String? getProductIdFromName(name) {
  if (name != null && name != " " && name != "") {
    return Get.find<ProductViewModel>().productDataMap.values.toList().cast<ProductModel?>().firstWhereOrNull((element) => element?.prodName == name || element?.prodCode == name)?.prodId ;
  } else {
    return null;
  }
}

List<ProductModel>? getProductsModelFromName(name) {
  if (name != null && name != " " && name != "") {
    return Get.find<ProductViewModel>()
        .productDataMap
        .values
        .toList()
        .where((element) => !element.prodIsGroup! && (element.prodName!.toLowerCase().contains(name.toLowerCase()) || element.prodFullCode!.toLowerCase().contains(name.toLowerCase()) || element.prodBarcode!.toLowerCase().contains(name.toLowerCase())))
        .toList();
  }
  return null;
}
ProductModel? getProductModelFromName(name) {
  if (name != null && name != " " && name != "") {
    return Get.find<ProductViewModel>()
        .productDataMap
        .values
        .toList()
        .where((element) => !element.prodIsGroup! && (element.prodName!.toLowerCase().contains(name.toLowerCase()) || element.prodFullCode!.toLowerCase().contains(name.toLowerCase()) || element.prodBarcode!.toLowerCase().contains(name.toLowerCase())))
        .firstOrNull;
  }
  return null;
}

String getProductNameFromId(id) {
  if (id != null && id != " " && id != "") {
    if (Get.find<ProductViewModel>().productDataMap[id] == null) {
      return "";
    }
    return Get.find<ProductViewModel>().productDataMap[id]!.prodName!;
  } else {
    return "";
  }
}

ProductModel? getProductModelFromId(id) {
  if (id.runtimeType == InvoiceRecordModel) {
    return Get.find<ProductViewModel>().productDataMap[(id as InvoiceRecordModel).invRecProduct!];
  } else if (id != null && id != " " && id != "") {
    if (Get.find<ProductViewModel>().productDataMap[id] == null) {
      return null;
    }
    return Get.find<ProductViewModel>().productDataMap[id]!;
  } else {
    return null;
  }
}

String replaceArabicNumbersWithEnglish(String input) {
  return input.replaceAllMapped(RegExp(r'[٠-٩]'), (Match match) {
    return String.fromCharCode(match.group(0)!.codeUnitAt(0) - 0x0660 + 0x0030);
  });
}
