import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/changes_view_model.dart';
import 'package:ba3_business_solutions/controller/cheque_view_model.dart';
import 'package:ba3_business_solutions/controller/entry_bond_view_model.dart';
import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/print_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/model/cheque_rec_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/model/invoice_record_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Const/const.dart';
import '../core/bindings.dart';
import '../model/bond_record_model.dart';
import '../view/main/main_screen.dart';
import '../view/user_management/account_management_view.dart';
import 'cards_view_model.dart';
import 'cost_center_view_model.dart';
import 'database_view_model.dart';
import 'import_view_model.dart';
import 'invoice_view_model.dart';

class GlobalViewModel extends GetxController {
  Map<String, GlobalModel> allGlobalModel = {};
  bool isDrawerOpen = true;
  ProductViewModel productController = Get.find<ProductViewModel>();
  StoreViewModel storeController = Get.find<StoreViewModel>();
  BondViewModel bondViewModel = Get.find<BondViewModel>();
  InvoiceViewModel invoiceViewModel = Get.find<InvoiceViewModel>();
  AccountViewModel accountViewModel = Get.find<AccountViewModel>();
  EntryBondViewModel entryBondViewModel = Get.find<EntryBondViewModel>();
  SellersViewModel sellerViewModel = Get.find<SellersViewModel>();
  ChequeViewModel chequeViewModel = Get.find<ChequeViewModel>();
  bool isEdit = false;
  GlobalViewModel()  {
   initFromLocal();

   //  allGlobalModel = Map.fromEntries(HiveDataBase.globalModelBox.values.map((e) => MapEntry(e.bondId!, e)).toList());
//   Future.sync(() async {
//  for (var i = 0; i < allGlobalModel.length; i++) {
//   print(allGlobalModel.keys.toList()[i]);
//   await HiveDataBase.globalModelBox.delete(allGlobalModel.keys.toList()[i]);
//  }});
//  Future.sync(() async {
//  for (var element in allGlobalModel.values) {
//     if(element.globalType==Const.globalTypeInvoice&&element.invCode!.contains("F-")){
//       print(element.invCode);
//       await HiveDataBase.globalModelBox.delete(element.bondId);
//       // await FirebaseFirestore.instance.collection("2024").doc(element.bondId).delete();
//     }
//     // if(element.bondCode == "9999"){
//     //   // print(element.invCode);
//     //   element.bondCode = "F-13921";
//     //   // await Future.delayed(Duration(milliseconds: 100));
//     //   // print(element.invId);
//     //   // element.bondId = generateId(RecordType.bond);
//     //   await HiveDataBase.globalModelBox.put(element.bondId,element);
//     // }
//   }
//   });
 
  //  FirebaseFirestore.instance.collection("2024").where("bondDate",isGreaterThan:DateTime(2024,07,01).toString(),).count().get().then((value) {
 
  //   // allGlobalModel = Map.fromEntries(HiveDataBase.globalModelBox.values.map((e) => MapEntry(e.bondId!, e)).toList());
  //   //       List<({String? bondCode ,String? bondType })> allbond = allGlobalModel.values.map((e) => (bondCode:e.bondCode,bondType:e.bondType),).toList();

  //   // bondList.removeWhere((element) => allbond.contains((bondCode:element.bondCode,bondType:element.bondType),));
  //  },);
// allGlobalModel = Map.fromEntries(HiveDataBase.globalModelBox.values.map((e) => MapEntry(e.bondId!, e)).toList());
//       for (var i = 0; i < allGlobalModel.length; i++) {
//         MapEntry<String, GlobalModel> value = allGlobalModel.entries.toList()[i];
//         for (var j = 0; j < (value.value.invRecords??[]).length; j++) {
//           print("-"*20);
//           InvoiceRecordModel element = value.value.invRecords![j];
//            if((element.invRecVat!=0&&element.invRecSubTotal!=0)){
//             print(element.toJson());
//               print("");
//               element.invRecQuantity = 1;
//               element.invRecSubTotal = 0;
//               element.invRecTotal = 0;
//               element.invRecVat = 0;
//               //  value.value.invRecords?.removeWhere((_element) => _element.invRecId == element.invRecId,);
//               //  value.value.invRecords?.add(element);
//              print(element.toJson());
//              isEdit =true ;
//             // print(value.value.invCode.toString() + "   "+value.value.bondId.toString() );
//             // print(element.invRecVat);
//             // print(i.toString());
//           }
//             print("-"*20);
//         }
//         if(isEdit){
//          //addInvoiceToFirebase(value.value);
//          // print(value.value.invRecords!.map((e) => e.toJson(),));
//           print("isedit: "+value.value.invCode.toString()+"   "+value.value.bondId.toString());
//           isEdit=false;
//         }
//       }
    
    // if (Get.currentRoute == "/LoginView") {
    //   Get.offAll(() => MainScreen());
    // }
  }
  RxInt count = 0.obs;
  int allcountOfInvoice = 0;

  /// forEach on all item it's [SoSlow].
  Future<void> initFromLocal() async {
    allGlobalModel.clear();
    print("-" * 20);
    print("YOU RUN LONG TIME OPERATION");
    print("-" * 20);
    allGlobalModel = Map.fromEntries(HiveDataBase.globalModelBox.values.map((e) => MapEntry(e.entryBondId!, e)).toList());
     List<({String? bondCode ,String? bondType })> allbond = allGlobalModel.values.map((e) => (bondCode:e.bondCode,bondType:e.bondType),).toList();
    print(allGlobalModel.length);
    // if (!allGlobalModel.isEmpty) {
    if (false) {
      await FirebaseFirestore.instance.collection(Const.globalCollection).get().then((value) async {
        print("start");
        count = 0.obs;
        allcountOfInvoice = value.docs.length;
        update();
        print(value.docs.length);
        for (var element in value.docs) {
          await Future.sync(() async {
            count.value++;
            print(count.toString());
            // for (var element in value.docChanges) {
            if (element.data()?['isDeleted'] != null && element.data()?['isDeleted']) {
              if (HiveDataBase.globalModelBox.keys.contains(element.id)) {
                deleteGlobal(HiveDataBase.globalModelBox.get(element.id)!);
              }
              // } else if (!getNoVAt(element.doc.id)) {
            } else {
                if(element.data()!['bondType'] !=Const.bondTypeInvoice)
             { allGlobalModel[element.id] = GlobalModel.fromJson(element.data());
              allGlobalModel[element.id]?.invRecords = [];
              allGlobalModel[element.id]?.bondRecord = [];
              allGlobalModel[element.id]?.cheqRecords = [];
              if (allGlobalModel[element.id]!.globalType == Const.globalTypeInvoice) {
                await FirebaseFirestore.instance.collection(Const.globalCollection).doc(element.id).collection(Const.invoiceRecordCollection).get().then((value) {
                  allGlobalModel[element.id]?.invRecords = value.docs.map((e) => InvoiceRecordModel.fromJson(e.data())).toList();
                });
              } else if (allGlobalModel[element.id]!.globalType == Const.globalTypeCheque) {
                await FirebaseFirestore.instance.collection(Const.globalCollection).doc(element.id).collection(Const.chequeRecordCollection).get().then((value) {
                  allGlobalModel[element.id]?.cheqRecords = value.docs.map((e) => ChequeRecModel.fromJson(e.data())).toList();
                });
              } else if (allGlobalModel[element.id]!.globalType == Const.globalTypeBond) {
                 await FirebaseFirestore.instance.collection(Const.globalCollection).doc(element.id).collection(Const.bondRecordCollection).get().then((value) {
                  allGlobalModel[element.id]?.bondRecord = value.docs.map((e) => BondRecordModel.fromJson(e.data())).toList();
                });
             }
              }
             HiveDataBase.globalModelBox.put(allGlobalModel[element.id]?.entryBondId, allGlobalModel[element.id]??GlobalModel());
              // updateDataInAll(allGlobalModel[element.id]!);
            }
          });
        }
      });
      if (Get.currentRoute == "/LoginView") {
        Get.offAll(() => MainScreen());
      }
    } else {
      print("start");
      count = 0.obs;
      allcountOfInvoice = allGlobalModel.length;
      update();
     allGlobalModel.forEach((key, value) async {
            count.value++;
          print(count.toString());
          await updateDataInAll(value);
        
      });
      if (Get.currentRoute == "/LoginView") {
        Get.offAll(() => MainScreen());
      }
    }
  }

  changeFreeType(type) async {
    HiveDataBase.setIsFree(type);
    Const.init(isFree: type);
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
    Get.put(IsolateViewModel(), permanent: true);
    Get.put(DataBaseViewModel(), permanent: true);
    Get.put(ImportViewModel(), permanent: true);
    Get.put(CardsViewModel(), permanent: true);
    Get.put(PrintViewModel(), permanent: true);
    Get.offAll(
      () => UserManagement(),
      binding: GetBinding(),
    );
  }

  /////-Add
  Future<void> addGlobalBond(GlobalModel globalModel) async {
    globalModel.bondDate ??= DateTime.now().toString();
    globalModel.globalType = Const.globalTypeBond;
    globalModel.bondId = generateId(RecordType.bond);
    globalModel.entryBondId = generateId(RecordType.entryBond);
    globalModel.entryBondCode=getNextEntryBondCode().toString();
    allGlobalModel[globalModel.entryBondId!] = globalModel;
    // addGlobalToLocal(globalModel);
    addBondToFirebase(globalModel);
    updateDataInAll(globalModel);
    bondViewModel.update();
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), Const.bondsCollection);
    update();
  }

  void addGlobalBondToMemory(GlobalModel globalModel) {
    addGlobalToLocal(globalModel);
    updateDataInAll(globalModel);
    bondViewModel.update();
    update();
  }

  void addGlobalCheque(GlobalModel globalModel) {
    globalModel.globalType = Const.globalTypeCheque;
    globalModel.bondId = generateId(RecordType.bond);
    globalModel.entryBondId = generateId(RecordType.entryBond);
    allGlobalModel[globalModel.entryBondCode!] = globalModel;
    addChequeToFirebase(globalModel);
    updateDataInAll(globalModel);
    chequeViewModel.update();
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), Const.chequesCollection);
    update();
  }

  void addGlobalInvoice(GlobalModel globalModel) {
    GlobalModel _ = correctInvRecord(globalModel);
    UserManagementViewModel userManagementViewModel = Get.find<UserManagementViewModel>();
    if ((userManagementViewModel.allRole[getMyUserRole()]?.roles[Const.roleViewInvoice]?.contains(Const.roleUserAdmin)) ?? false) {
      _.invIsPending = false;
    } else {
      _.invIsPending = true;
    }
    allGlobalModel[_.entryBondId!] = _;
    updateDataInAll(_);
    addInvoiceToFirebase(_);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(_.toFullJson(), Const.invoicesCollection);
   // showEInvoiceDialog(mobileNumber: _.invMobileNumber ?? "", invId: _.bondId!);
    // invoiceViewModel.updateCodeList();
    invoiceViewModel.update();
    update();
  }

  void addGlobalInvoiceToMemory(GlobalModel globalModel) {
    addGlobalToLocal(globalModel);
    updateDataInAll(globalModel);
    invoiceViewModel.update();
    update();
  }

  void addGlobalChequeToMemory(GlobalModel globalModel) {
    addGlobalToLocal(globalModel);
    updateDataInAll(globalModel);
    chequeViewModel.update();
    update();
  }

  void addGlobalToLocal(GlobalModel globalModel) {
    HiveDataBase.globalModelBox.put(globalModel.entryBondId, globalModel);
  }

  ////-Update
  void updateGlobalInvoice(GlobalModel globalModel) {
    GlobalModel _ = correctInvRecord(globalModel);
    addInvoiceToFirebase(_);
    allGlobalModel[globalModel.entryBondId!] = globalModel;
    updateDataInAll(globalModel);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), Const.invoicesCollection);
    update();
  }

  Future<void> updateGlobalBond(GlobalModel globalModel) async {
    allGlobalModel[globalModel.entryBondId!] = globalModel;
    await addBondToFirebase(globalModel);
    bondViewModel.initGlobalBond(globalModel);
    updateDataInAll(globalModel);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), Const.bondsCollection);
    update();
  }

  void updateGlobalCheque(GlobalModel globalModel) {
    allGlobalModel[globalModel.entryBondId!] = globalModel;
    updateDataInAll(globalModel);
    addChequeToFirebase(globalModel);
    chequeViewModel.update();
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), Const.chequesCollection);
    update();
  }

  ////--Delete
  void deleteGlobal(GlobalModel globalModel) {
    entryBondViewModel.deleteBondById(globalModel.entryBondId);
    FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.entryBondId).set({"isDeleted": true}, SetOptions(merge: true));
    deleteGlobalFromLocal(globalModel);
    deleteDataInAll(globalModel);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addRemoveChangeToChanges(globalModel.toFullJson(), Const.globalCollection);
    update();
  }

  void deleteGlobalMemory(GlobalModel globalModel) {
    deleteGlobalFromLocal(globalModel);
    deleteDataInAll(globalModel);
    update();
  }

  void deleteGlobalFromLocal(GlobalModel globalModel) {
    HiveDataBase.globalModelBox.delete(globalModel.entryBondId);
  }

  void deleteAllLocal() {
    HiveDataBase.globalModelBox.deleteFromDisk();
    HiveDataBase.accountModelBox.deleteFromDisk();
    HiveDataBase.storeModelBox.deleteFromDisk();
    HiveDataBase.productModelBox.deleteFromDisk();
    HiveDataBase.lastChangesIndexBox.deleteFromDisk();
    HiveDataBase.constBox.deleteFromDisk();
    HiveDataBase.isNewUser.deleteFromDisk();
  }

  ////-Utils
  GlobalModel correctInvRecord(GlobalModel globalModel) {
    GlobalModel _ = GlobalModel.fromJson(globalModel.toFullJson());
    _.invRecords?.removeWhere((element) => element.invRecId == null);
    _.bondRecord?.removeWhere((element) => element.bondRecId == null);
    _.invDiscountRecord?.removeWhere((element) => element.discountId == null);
    for (var element in _.invRecords ?? []) {
      if (!(element.invRecProduct?.contains("prod") ?? true)) globalModel.invRecords?[globalModel.invRecords!.indexOf(element)].invRecProduct = productController.searchProductIdByName(element.invRecProduct);
    }
    for (BondRecordModel element in _.bondRecord ?? []) {
      if (!(element.bondRecAccount?.contains("acc") ?? true)) globalModel.bondRecord?[globalModel.bondRecord!.indexOf(element)].bondRecAccount = getAccountIdFromText(element.bondRecAccount);
    }
    return _;
  }

  addInvoiceToFirebase(GlobalModel globalModel) async {
    // try {
    //   await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).collection(Const.invoiceRecordCollection).get().then((value) {
    //     for (var element in value.docs) {
    //       element.reference.delete();
    //     }
    //   });
    // } catch (e) {}
    // globalModel.invRecords?.forEach((element) async {
    //   await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).collection(Const.invoiceRecordCollection).doc(element.invRecId).set(element.toJson());
    // });

    // await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).set(globalModel.toJson());
  //  await HiveDataBase.globalModelBox.delete(globalModel.bondId);
      await Future.delayed(Duration(milliseconds: 100));

   await HiveDataBase.globalModelBox.put(globalModel.entryBondId, globalModel);
   print("end " + globalModel.entryBondId.toString()+ "  "+globalModel.invId.toString());
  }

  Future addBondToFirebase(GlobalModel globalModel) async {
    // await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).collection(Const.bondRecordCollection).get().then((value) async {
    //   for (var element in value.docs) {
    //     await element.reference.delete();
    //   }
    // });
    // globalModel.bondRecord?.forEach((element) async {
    //   await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).collection(Const.bondRecordCollection).doc(element.bondRecId).set(element.toJson());
    // });
    // await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).set(globalModel.toJson());
    await Future.delayed(Duration(milliseconds: 100));
     await HiveDataBase.globalModelBox.put(globalModel.entryBondId, globalModel);
    print("end " + globalModel.entryBondId.toString());
    print("----------------------------------------");
  }

  void addChequeToFirebase(GlobalModel globalModel) async {
    await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.entryBondId).collection(Const.chequeRecordCollection).get().then((value) async {
      for (var element in value.docs) {
        await element.reference.delete();
      }
    });
    globalModel.cheqRecords?.forEach((element) async {
      await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.entryBondId).collection(Const.chequeRecordCollection).doc(element.cheqRecEntryBondId).set(element.toJson());
    });
    await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.entryBondId).set(globalModel.toJson());
  }

  updateDataInAll(GlobalModel globalModel) async {
    if (globalModel.globalType == Const.globalTypeInvoice) {
      GlobalModel? filteredGlobalModel = checkFreeZoneProduct(globalModel);
      if (filteredGlobalModel == null) {
        return;
      }
      if (!globalModel.invIsPending!) {
        if (filteredGlobalModel.invType != Const.invoiceTypeAdd&&filteredGlobalModel.invType != Const.invoiceTypeChange) {
         entryBondViewModel.initGlobalInvoiceBond(filteredGlobalModel);
          if(getPatModelFromPatternId(globalModel.patternId).patName=="مبيع") {
            sellerViewModel.postRecord(userId: filteredGlobalModel.invSeller!, invId: filteredGlobalModel.invId, amount: filteredGlobalModel.invTotal!, date: filteredGlobalModel.invDate);
          }
        }
        if (filteredGlobalModel.invType != Const.invoiceTypeChange) {
        accountViewModel.initGlobalAccount(filteredGlobalModel);
         productController.initGlobalProduct(filteredGlobalModel);
        }
        storeController.initGlobalStore(filteredGlobalModel);
      }
      invoiceViewModel.initGlobalInvoice(filteredGlobalModel);
    } else if (globalModel.globalType == Const.globalTypeCheque) {
        entryBondViewModel.initGlobalChequeBond(globalModel);
      chequeViewModel.initGlobalCheque(globalModel);
    } else if (globalModel.globalType == Const.globalTypeBond) {  
      bondViewModel.initGlobalBond(globalModel);
      entryBondViewModel.initGlobalBond(globalModel);
      accountViewModel.initGlobalAccount(globalModel);
    }
  }

  deleteDataInAll(GlobalModel globalModel) {
    if (globalModel.globalType == Const.globalTypeInvoice) {
      invoiceViewModel.deleteGlobalInvoice(globalModel);
      bondViewModel.deleteGlobalBond(globalModel);
      accountViewModel.deleteGlobalAccount(globalModel);
      productController.deleteGlobalProduct(globalModel);
      storeController.deleteGlobalStore(globalModel);
      sellerViewModel.deleteGlobalSeller(globalModel);
    } else if (globalModel.globalType == Const.globalTypeCheque) {
      chequeViewModel.deleteGlobalCheque(globalModel);
    } else if (globalModel.globalType == Const.globalTypeBond) {
      bondViewModel.deleteGlobalBond(globalModel);
      accountViewModel.deleteGlobalAccount(globalModel);
    }
  }

  GlobalModel? checkFreeZoneProduct(GlobalModel filteredGlobalModel) {
    if (HiveDataBase.isFree.get("isFree")!) {
      if(filteredGlobalModel.invCode!.startsWith("F-")){
        return null;
      }
      GlobalModel _ = GlobalModel.fromJson(filteredGlobalModel.toFullJson());
      for (var i = 0; i < _.invRecords!.length; i++) {
        if (_.invRecords![i].invRecIsLocal??true) {
        } else {
          _.invTotal = _.invTotal! - _.invRecords![i].invRecTotal!;
          _.invRecords!.removeAt(i);
        }
      }
      if (_.invRecords!.isEmpty) {
        return null;
      } else {
        return _;
      }
    } else {
      return filteredGlobalModel;
    }
  }
}
