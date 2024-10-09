import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/controller/bond/bond_record_pluto_view_model.dart';
import 'package:ba3_business_solutions/controller/account/account_view_model.dart';
import 'package:ba3_business_solutions/controller/globle/global_view_model.dart';
import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:ba3_business_solutions/view/bonds/pages/bond_details_view.dart';
import 'package:ba3_business_solutions/view/bonds/pages/custom_bond_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../model/bond/bond_record_model.dart';
import '../../core/utils/generate_id.dart';
import '../../view/bonds/widget/bond_record_data_source.dart';
import '../../view/bonds/widget/custom_bond_record_data_source.dart';

class BondViewModel extends GetxController {
  late BondRecordDataSource recordDataSource;
  late DataGridController dataGridController;
  late CustomBondRecordDataSource customBondRecordDataSource;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController debitOrCreditController = TextEditingController();
  String? lastBondOpened;
  GlobalModel bondModel = GlobalModel();
  RxMap<String, GlobalModel> allBondsItem = <String, GlobalModel>{}.obs;
  bool isEdit = false;
  GlobalModel tempBondModel = GlobalModel();
  Map<String, String> codeList = {};
  TextEditingController userAccountController = TextEditingController();

  // BondViewModel() {
  //   getAllBonds();
  // }
  // getAllBonds(GlobalModel globalModel) async {
  //   print("start get bond data");
  //   FirebaseFirestore.instance.collection(Const.bondsCollection).snapshots().listen((QuerySnapshot querySnapshot) {
  //     allBondsItem.clear();
  //     for (var element in querySnapshot.docs) {
  //       allBondsItem[element.id] = GlobalModel.fromJson(element.data());
  //       element.reference.collection(Const.recordCollection).snapshots().listen((value) {
  //         List<BondRecordModel> _ = value.docs.map((e) => BondRecordModel.fromJson(e.data())).toList();
  //         allBondsItem[element.id]?.bondRecord = _;
  //       });
  //     }
  //   });
  //   WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
  //
  //     update();
  //   });
  // }

  initGlobalBond(GlobalModel globalModel) {
    // if(globalModel.bondCode)

    allBondsItem[globalModel.bondId!] = globalModel;
    // tempBondModel=GlobalModel.fromJson(globalModel.toFullJson());
    // initPage();

/*    if (lastBondOpened != null) {
      tempBondModel = GlobalModel.fromJson(allBondsItem[lastBondOpened]?.toFullJson());
      // initPage(tempBondModel.bondType);
    }
    update();*/
    // if(oldBondModel!=null){
    //   tempBondModel = GlobalModel.fromJson(globalModel.toFullJson());
    //   initPage();
    //   update();
    // }
  }

  deleteGlobalBond(GlobalModel globalModel) {
    allBondsItem.removeWhere((key, value) => key == globalModel.bondId);
  }

  // initGlobalInvoiceBond(GlobalModel globalModel) async {
  //   // print("start get bond data");
  //   // FirebaseFirestore.instance.collection(Const.bondsCollection).snapshots().listen((QuerySnapshot querySnapshot) {
  //   //   allBondsItem.clear();
  //   //   for (var element in querySnapshot.docs) {
  //   //     allBondsItem[element.id] = GlobalModel.fromJson(element.data());
  //   //     element.reference.collection(Const.recordCollection).snapshots().listen((value) {
  //   //       List<BondRecordModel> _ = value.docs.map((e) => BondRecordModel.fromJson(e.data())).toList();
  //   //       allBondsItem[element.id]?.bondRecord = _;
  //   //     });
  //   //   }
  //   // });
  //   // WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
  //   //
  //   //   update();
  //   // });
  //   allBondsItem[globalModel.bondId!]=globalModel;
  //   allBondsItem[globalModel.bondId!]?.bondRecord = [];
  //   allBondsItem[globalModel.bondId!]?.originId = globalModel.invId;
  //    allBondsItem[globalModel.bondId!]?.bondType = Const.bondTypeInvoice;
  //   // allBondsItem[globalModel.bondId!]?.bondCode = getNextBondCode(type: Const.bondTypeDaily);
  //   allBondsItem[globalModel.bondId!]?.bondDate ??= globalModel.invDate;
  //   allBondsItem[globalModel.bondId!]?.bondDescription =getGlobalTypeFromEnum(globalModel.patternId!)+" تم التوليد بشكل تلقائي";

  //   int bondRecId=0;
  //   globalModel.invRecords?.forEach((element) {
  //     String dse="${getInvTypeFromEnum(globalModel.invType!)} عدد ${element.invRecQuantity} من ${getProductNameFromId(element.invRecProduct)}";
  //     double totalDiscount = globalModel.invDiscountRecord!.isEmpty?0:globalModel.invDiscountRecord!.where((_)=>(_.discountTotal??0)>0).map((e) => e.discountPercentage!,).reduce((value, element) => value+element,);
  //     double totalAdded = globalModel.invDiscountRecord!.isEmpty?0:globalModel.invDiscountRecord!.where((_)=>(_.addedTotal??0)>0).map((e) => e.addedPercentage!,).reduce((value, element) => value+element,);
  //     if(globalModel.invType==Const.invoiceTypeSales){
  //       allBondsItem[globalModel.bondId!]?.bondRecord?.add(BondRecordModel((bondRecId++).toString(), element.invRecSubTotal!*element.invRecQuantity!-((element.invRecSubTotal!*element.invRecQuantity!)*(totalDiscount==0?0:(totalDiscount/100)))+((element.invRecSubTotal!*element.invRecQuantity!)*(totalAdded==0?0:(totalAdded/100))), 0, allBondsItem[globalModel.bondId!]?.invPrimaryAccount,dse ));
  //       allBondsItem[globalModel.bondId!]?.bondRecord?.add(BondRecordModel((bondRecId++).toString(), 0, element.invRecSubTotal!*element.invRecQuantity!, allBondsItem[globalModel.bondId!]?.invSecondaryAccount, dse));
  //     if(totalDiscount!=0){
  //       for (var model in globalModel.invDiscountRecord!) {
  //         if((model.discountTotal??0)>0){
  //          var discountDes = "الخصم المعطى "+(model.isChooseDiscountTotal! ?"بقيمة "+model.discountTotal.toString():"بنسبة "+model.discountPercentage.toString()+"%");
  //         allBondsItem[globalModel.bondId!]?.bondRecord?.add(BondRecordModel((bondRecId++).toString(), (element.invRecSubTotal!*element.invRecQuantity!)*(model.discountPercentage==0?1:(model.discountPercentage!/100)), 0, model.accountId, discountDes));
  //         }else{
  //          var addedDes = "إضافة المعطى "+(model.isChooseAddedTotal! ?"بقيمة "+model.addedTotal.toString():"بنسبة "+model.addedPercentage.toString()+"%");
  //         allBondsItem[globalModel.bondId!]?.bondRecord?.add(BondRecordModel((bondRecId++).toString(), (element.invRecSubTotal!*element.invRecQuantity!)*(model.addedPercentage==0?1:(model.addedPercentage!/100)), 0, model.accountId, addedDes));
  //         }
  //       }
  //     }
  //     }else{
  //       allBondsItem[globalModel.bondId!]?.bondRecord?.add(BondRecordModel((bondRecId++).toString(), 0,element.invRecSubTotal!*element.invRecQuantity!,  allBondsItem[globalModel.bondId!]?.invSecondaryAccount,dse ));
  //       allBondsItem[globalModel.bondId!]?.bondRecord?.add(BondRecordModel((bondRecId++).toString(),  element.invRecSubTotal!*element.invRecQuantity!,0, allBondsItem[globalModel.bondId!]?.invPrimaryAccount, dse));
  //     }
  //     if(element.invRecVat!=0){
  //       if(globalModel.invType==Const.invoiceTypeSales){
  //       allBondsItem[globalModel.bondId!]?.bondRecord?.add(BondRecordModel((bondRecId++).toString(), element.invRecVat!*element.invRecQuantity!, 0, allBondsItem[globalModel.bondId!]?.invVatAccount, "ضريبة "+dse));
  //       allBondsItem[globalModel.bondId!]?.bondRecord?.add(BondRecordModel((bondRecId++).toString(), 0, element.invRecVat!*element.invRecQuantity!, allBondsItem[globalModel.bondId!]?.invSecondaryAccount,"ضريبة "+dse));
  //     }else{
  //         allBondsItem[globalModel.bondId!]?.bondRecord?.add(BondRecordModel((bondRecId++).toString(), element.invRecVat!*element.invRecQuantity!, 0, allBondsItem[globalModel.bondId!]?.invPrimaryAccount, "ضريبة "+dse));
  //         allBondsItem[globalModel.bondId!]?.bondRecord?.add(BondRecordModel((bondRecId++).toString(), 0, element.invRecVat!*element.invRecQuantity!, allBondsItem[globalModel.bondId!]?.invVatAccount,"ضريبة "+dse));
  //       }
  //     }
  //   });

  //   if(lastBondOpened!=null){
  //     tempBondModel = GlobalModel.fromJson(allBondsItem[lastBondOpened]?.toFullJson());
  //     initPage(tempBondModel.bondType);
  //   }

  //   update();
  // }

  // initAllBonds(querySnapshot) async {
  //   allBondsItem.clear();
  //   for (var element in querySnapshot.docs) {
  //     allBondsItem[element['bondId']] = GlobalModel.fromJson(element.data());
  //     element.reference
  //         .collection(Const.recordCollection)
  //         .snapshots()
  //         .listen((value) {
  //       List<BondRecordModel> _ =
  //           value.docs.map((e) => BondRecordModel.fromJson(e.data())).toList();
  //       allBondsItem[element['bondId']]?.bondRecord = _;
  //     });
  //   }

  // WidgetsFlutterBinding.ensureInitialized()
  //     .waitUntilFirstFrameRasterized
  //     .then((value) {
  //   update();
  // });
  //   //update();
  // }

  // postOneBond(bool isNew, {bool withLogger = false}) async {
  //   bondModel = GlobalModel.fromJson(tempBondModel.toFullJson());
  //   print(tempBondModel.toFullJson());
  //   final accountController = Get.find<AccountViewModel>();
  //   for (var i = 0; i < bondModel.bondRecord!.length; i++) {
  //     if (bondModel.bondRecord?[i].bondRecAccount?.substring(0, 3) != 'acc') {
  //       bondModel.bondRecord?[i].bondRecAccount = accountController.accountList.values.toList().firstWhere((e) => e.accName == bondModel.bondRecord?[i].bondRecAccount).accId;
  //     }
  //   }
  //   if (isNew) {
  //     bondModel.bondId = generateId(RecordType.bond);
  //     tempBondModel.bondId = bondModel.bondId;
  //   }
  //
  //   if (double.parse(bondModel.bondTotal!) != 0 && bondModel.bondType == Const.bondTypeDaily) {
  //     Get.snackbar("خطأ", "خطأ بالمجموع");
  //     return;
  //   } else if (double.parse(bondModel.bondTotal!) == 0 && bondModel.bondType == Const.bondTypeDebit || bondModel.bondType == Const.bondTypeCredit) {
  //     Get.snackbar("خطأ", "فارغ");
  //     return;
  //   }
  //
  //   FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondModel.bondId).set(bondModel.toJson());
  //   bondModel.bondRecord?.forEach((element) async {
  //     print(element.toJson());
  //     FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondModel.bondId).collection(Const.recordCollection).doc(element.bondRecId).set(element.toJson());
  //   });
  //   if (withLogger) logger(newData: bondModel);
  //   accountController.updateInAccount(bondModel);
  //   saveRecordInFirebase(bondModel);
  //   // _allBondsItem[bondModel.bondId!]=  bondModel;
  //   // _allBondsItem.entries.toList().sort((e1, e2) => e1.value.bondId!.compareTo(e2.value.bondId!));
  //   isEdit = false;
  //   update();
  // }
  // updateBond({String? modelKey, bool withLogger = false}) async {
  //   if (withLogger) logger(oldData: allBondsItem[tempBondModel.bondId!], newData: tempBondModel);
  //   allBondsItem[tempBondModel.bondId!] = GlobalModel.fromJson(tempBondModel.toFullJson());
  //   if (bondModel.bondType != Const.bondTypeDaily) {
  //     tempBondModel.bondRecord?.removeWhere((element) => element.bondRecId == "0");
  //   }
  //   final accountController = Get.find<AccountViewModel>();
  //   for (var i = 0; i < bondModel.bondRecord!.length; i++) {
  //     if (bondModel.bondRecord?[i].bondRecAccount?.substring(0, 3) != 'acc') {
  //       bondModel.bondRecord?[i].bondRecAccount = accountController.accountList.values.toList().firstWhere((e) => e.accName == bondModel.bondRecord?[i].bondRecAccount).accId;
  //     }
  //   }
  //   if (double.parse(bondModel.bondTotal!) != 0 && bondModel.bondType == Const.bondTypeDaily) {
  //     Get.snackbar("خطأ", "خطأ بالمجموع");
  //   } else if (double.parse(bondModel.bondTotal!) == 0 && bondModel.bondType == Const.bondTypeDebit || bondModel.bondType == Const.bondTypeCredit) {
  //     Get.snackbar("خطأ", "فارغ");
  //   }
  //   bondModel = GlobalModel.fromJson(allBondsItem[tempBondModel.bondId!]!.toFullJson());
  //   await FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondModel.bondId).collection(Const.recordCollection).get().then((value) {
  //     for (var e in value.docs) {
  //       e.reference.delete();
  //     }
  //   });
  //   FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondModel.bondId).delete();
  //   for (BondRecordModel bondRecord in bondModel.bondRecord!) {
  //     FirebaseFirestore.instance.collection(Const.accountsCollection).doc(bondRecord.bondRecAccount).collection(Const.recordCollection).doc(bondModel.bondId).delete();
  //   }
  //   FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondModel.bondId).set(bondModel.toJson());
  //   bondModel.bondRecord?.forEach((element) async {
  //     print(element.bondRecAccount);
  //     print(element.bondRecId);
  //     FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondModel.bondId).collection(Const.recordCollection).doc(element.bondRecId).set(element.toJson());
  //   });
  //   saveRecordInFirebase(bondModel);
  //   accountController.updateInAccount(bondModel, modelKey: modelKey);
  //   isEdit = false;
  //   update();
  // }
  // deleteOneBonds({String? bondId, bool withLogger = false}) async {
  //   bondId ??= bondModel.bondId;
  //   if (bondId != null) {
  //     bondModel = allBondsItem[bondId]!;
  //   }
  //   print(bondId);
  //   if (withLogger) logger(oldData: bondModel);
  //   for (BondRecordModel bondRecord in bondModel.bondRecord!) {
  //     FirebaseFirestore.instance.collection(Const.accountsCollection).doc(bondRecord.bondRecAccount).collection(Const.recordCollection).doc(bondId).delete();
  //   }
  //   await FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondId).collection(Const.recordCollection).get().then((value) {
  //     for (var e in value.docs) {
  //       e.reference.delete();
  //     }
  //   });
  //   await FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondId).delete();
  //
  //   isEdit = false;
  //   update();
  // }
  // void saveRecordInFirebase(GlobalModel bondModel) async {
  //   Map<String, List> allRecTotal = {};
  //   for (int i = 0; i < bondModel.bondRecord!.length; i++) {
  //     await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(bondModel.bondRecord![i].bondRecAccount).get().then((value) {
  //       if (allRecTotal[value.id] == null) {
  //         allRecTotal[value.id] = [bondModel.bondRecord![i].bondRecDebitAmount! - bondModel.bondRecord![i].bondRecCreditAmount!];
  //       } else {
  //         allRecTotal[value.id]!.add(bondModel.bondRecord![i].bondRecDebitAmount! - bondModel.bondRecord![i].bondRecCreditAmount!);
  //       }
  //     });
  //   }
  //   allRecTotal.forEach((key, value) {
  //     var recCredit = value.reduce((value, element) => value + element);
  //     FirebaseFirestore.instance.collection(Const.accountsCollection).doc(key).collection(Const.recordCollection).doc(bondModel.bondId).set({
  //       "total": recCredit.toString(),
  //       "id": bondModel.bondId,
  //       "account": key,
  //     });
  //   });
  // }

  void restoreOldData() {
    tempBondModel = GlobalModel.fromJson(bondModel.toFullJson());
    update();

    // FirebaseFirestore.instance.collection(ConstRecord.bondsCollection).doc(bondModel.bondId).get().then((value) {
    //   value.reference.collection(ConstRecord.recordCollection).get().then((value1) {
    //     List<BondRecordModel> _ = value1.docs.map((e) => BondRecordModel.fromJson(e.data())).toList();
    //   var newBondModel = GlobalModel.fromJson(value.data()!);
    //   newBondModel.bondRecord=_;
    //   _allBondsItem[bondModel.bondId!]=newBondModel;
    //   update();
    //   });
    // });
  }

  void changeIndexCode({required String code, required String type}) {
    var model = allBondsItem.values.toList().firstWhereOrNull(
        (element) => element.bondCode == code && element.bondType == type);
    if (model == null) {
      Get.snackbar("خطأ", "غير موجود");
    } else {
      tempBondModel = GlobalModel.fromJson(model.toFullJson());
      bondModel = GlobalModel.fromJson(model.toFullJson());
      if (bondModel.bondType == AppConstants.bondTypeDaily ||
          bondModel.bondType == AppConstants.bondTypeStart ||
          bondModel.bondType == AppConstants.bondTypeInvoice) {
        Get.off(() => BondDetailsView(
              oldId: bondModel.bondId,
              bondType: bondModel.bondType!,
            ));
        update();
      } else {
        Get.off(() => CustomBondDetailsView(
              oldId: bondModel.bondId,
              isDebit: bondModel.bondType == AppConstants.bondTypeDebit,
            ));
        update();
      }
    }
    update();
  }

  void deleteBondById(String? bondId) {
    allBondsItem.removeWhere((key, value) => key == bondId);
    // initPage(tempBondModel.bondType);
    update();
  }

/*  void deleteOneRecord(int rowIndex) {
    tempBondModel.bondRecord?.removeAt(rowIndex);
    // updateBond();
    for (var i = 0; i < tempBondModel.bondRecord!.length; i++) {
      tempBondModel.bondRecord?[i].bondRecId = "0$i";
    }
    initTotal();
    initPage(tempBondModel.bondType);
    isEdit = true;
    update();
  }*/
  bool isNew = false;

  initPage({String? oldId, String? type}) {
    final plutoEditViewModel = Get.find<BondRecordPlutoViewModel>();
    initCodeList(type);
    if (oldId != null) {
      tempBondModel = allBondsItem[oldId]!;
      bondModel = allBondsItem[oldId]!;
      codeController.text = tempBondModel.bondCode!;
      dateController.text = tempBondModel.bondDate!.split(" ")[0];
      noteController.text = tempBondModel.bondDescription ?? '';

      if (tempBondModel.bondType == AppConstants.bondTypeCredit) {
        debitOrCreditController.text =
            getAccountNameFromId(tempBondModel.bondRecord?.last.bondRecAccount);
        plutoEditViewModel.getRows(
            tempBondModel.bondRecord
                    ?.where(
                      (element) => (element.bondRecCreditAmount ?? 0) > 0,
                    )
                    .toList() ??
                [],
            type!);
      } else if (tempBondModel.bondType == AppConstants.bondTypeDebit) {
        debitOrCreditController.text =
            getAccountNameFromId(tempBondModel.bondRecord?.last.bondRecAccount);
        plutoEditViewModel.getRows(
            tempBondModel.bondRecord
                    ?.where(
                      (element) => (element.bondRecDebitAmount ?? 0) > 0,
                    )
                    .toList() ??
                [],
            type!);
      } else {
        debitOrCreditController.text = "";
        plutoEditViewModel.getRows(
            tempBondModel.bondRecord?.toList() ?? [], type!);
      }
      isNew = false;
    } else {
      plutoEditViewModel.getRows([], type!);
      tempBondModel = GlobalModel();
      codeController.text = getNextBondCode(type: type);
      dateController.text = '';
      noteController.text = '';

      debitOrCreditController.text = '';
      isNew = true;
    }
    tempBondModel.bondType = type;

    // newCodeController.text = (int.parse(bondController.allBondsItem.values.lastOrNull?.bondCode ?? "0") + 1).toString();
    // while (bondController.allBondsItem.values.toList().map((e) => e.bondCode).toList().contains(newCodeController.text)) {
    //
    // }
    WidgetsFlutterBinding.ensureInitialized()
        .waitUntilFirstFrameRasterized
        .then(
      (value) {
        update();
      },
    );
  }

  void initTotal() {
    double debit = 0;
    double credit = 0;
    tempBondModel.bondRecord?.forEach((element) {
      debit = debit + (element.bondRecDebitAmount ?? 0);
      credit = credit + (element.bondRecCreditAmount ?? 0);
    });
    tempBondModel.bondTotal = (debit - credit).toStringAsFixed(2);
  }

  // Future<void> fastAddBond({required String entryBondId,String? bondId,String? oldBondCode, String? originId, required double total, required List<BondRecordModel> record,String? bondDate,String?bondType}) async {
  //   tempBondModel = GlobalModel();
  //   bondModel = GlobalModel();
  //   tempBondModel.bondRecord = record;
  //   tempBondModel.originId = originId;
  //    if (entryBondId == null) {
  //     tempBondModel.entryBondId = generateId(RecordType.entryBond);
  //   } else {
  //     tempBondModel.entryBondId = entryBondId;
  //   }
  //   if (bondId == null) {
  //     tempBondModel.bondId = generateId(RecordType.bond);
  //   } else {
  //     tempBondModel.bondId = bondId;
  //     bondModel.bondId = bondId;
  //   }
  //   tempBondModel.bondTotal = total.toString();
  //   tempBondModel.bondType = bondType;
  //   tempBondModel.bondType ??= Const.bondTypeDaily;
  //   tempBondModel.globalType=Const.globalTypeBond;
  //   var bondCode = "";
  //   if (!isEdit) {
  //     // String bondId = generateId(RecordType.bond);
  //     bondCode = (int.parse(allBondsItem.values.lastOrNull?.bondCode ?? "0") + 1).toString();
  //     while (allBondsItem.values.toList().map((e) => e.bondCode).toList().contains(bondCode)) {
  //       bondCode = (int.parse(bondCode) + 1).toString();
  //     }
  //   }
  //   if(oldBondCode==null){
  //     tempBondModel.bondCode = bondCode;
  //   }else{
  //     tempBondModel.bondCode = oldBondCode;
  //   }
  //   tempBondModel.bondDate=bondDate;
  //   var globalController = Get.find<GlobalViewModel>();
  //  await globalController.updateGlobalBond(tempBondModel);

  //   // postOneBond(false);
  // }

  Future<void> fastAddBondToFirebase(
      {required String entryBondId,
      String? amenCode,
      String? bondId,
      String? bondDes,
      String? oldBondCode,
      String? originId,
      required double total,
      required List<BondRecordModel> record,
      String? bondDate,
      String? bondType}) async {
    tempBondModel = GlobalModel();
    tempBondModel.bondRecord = record;
    tempBondModel.originId = originId;
    tempBondModel.originAmenId = amenCode;
    if (entryBondId == "") {
      tempBondModel.entryBondId = generateId(RecordType.entryBond);
    } else {
      tempBondModel.entryBondId = entryBondId;
    }
    if (bondId == null) {
      tempBondModel.bondId = generateId(RecordType.bond);
    } else {
      tempBondModel.bondId = bondId;
    }
    tempBondModel.bondTotal = total.toString();
    tempBondModel.bondType = bondType;
    tempBondModel.bondDescription = bondDes;
    tempBondModel.bondType ??= AppConstants.bondTypeDaily;
    tempBondModel.globalType = AppConstants.globalTypeBond;

    if (oldBondCode == null) {
      var bondCode = "";
      if (!isEdit) {
        // String bondId = generateId(RecordType.bond);
        bondCode =
            (int.parse(allBondsItem.values.lastOrNull?.bondCode ?? "0") + 1)
                .toString();
        while (allBondsItem.values
            .toList()
            .map((e) => e.bondCode)
            .toList()
            .contains(bondCode)) {
          bondCode = (int.parse(bondCode) + 1).toString();
        }
      }
      tempBondModel.bondCode = bondCode;
    } else {
      tempBondModel.bondCode = oldBondCode;
    }
    tempBondModel.bondDate = bondDate;
    tempBondModel.bondDate ??= DateTime.now().toString().split(" ")[0];
    var globalController = Get.find<GlobalViewModel>();

    await globalController.addBondToFirebase(tempBondModel);
  }

  // void fastAddBondAddToModel({required String entryBondId,String? bondId,String? oldBondCode, String? originId, required double total, required List<BondRecordModel> record,String? bondDate,String?bondType}) {
  //   tempBondModel = GlobalModel();
  //   bondModel = GlobalModel();
  //   tempBondModel.globalType=Const.globalTypeBond;
  //   tempBondModel.bondRecord = record;
  //   tempBondModel.originId = originId;
  //    if (entryBondId == null) {
  //     tempBondModel.entryBondId = generateId(RecordType.entryBond);
  //   } else {
  //     tempBondModel.entryBondId = entryBondId;
  //   }
  //   if (bondId == null) {
  //     tempBondModel.bondId = generateId(RecordType.bond);
  //   } else {
  //     tempBondModel.bondId = bondId;
  //     bondModel.bondId = bondId;
  //   }
  //   tempBondModel.bondTotal = total.toString();
  //   tempBondModel.bondType = bondType ??Const.bondTypeDaily;
  //   var bondCode = "";
  //   if (!isEdit) {
  //     // String bondId = generateId(RecordType.bond);
  //    bondCode=getNextBondCode(type:tempBondModel.bondType );
  //     //TODO add_bondid_to_cheqoe_model_to_save_it_while_edit
  //     // invoiceModel.bondCode = bondCode;
  //   }
  //   if(oldBondCode==null){
  //     tempBondModel.bondCode = bondCode;
  //   }else{
  //     tempBondModel.bondCode = oldBondCode;
  //   }
  //   tempBondModel.bondDate=bondDate;
  //   tempBondModel.bondDate??=DateTime.now().toString().split(" ")[0];
  //   // var globalController = Get.find<GlobalViewModel>();
  //   // globalController.updateGlobalBond(tempBondModel);
  //   allBondsItem[tempBondModel.bondId!]=tempBondModel;
  //   initPage(tempBondModel.bondType);
  //   // postOneBond(false);
  // }

  initCodeList(type) {
    codeList = {};
    for (var element in allBondsItem.values) {
      if ((element.bondType!) == type) {
        codeList[element.bondCode ?? '0'] = element.bondId!;
      }
    }

    codeList = Map.fromEntries(codeList.entries.toList()
      ..sort(
        (a, b) {
          if (a.key.startsWith("F") && b.key.startsWith("F")) {
            return int.parse((a.key).split("F-")[1])
                .compareTo(int.parse((b.key).split("F-")[1]));
          } else if (a.key.startsWith("F")) {
            return int.parse((a.key).split("F-")[1])
                .compareTo(int.parse(b.key));
          } else if (b.key.startsWith("F")) {
            return int.parse((a.key))
                .compareTo(int.parse((b.key).split("F-")[1]));
          } else {
            return int.parse(a.key).compareTo(int.parse(b.key));
          }
        },
      ));
  }

  getBondByCode(String bondType, bondCode) {
    List<GlobalModel> bond = allBondsItem.values
        .where((element) =>
            element.globalType == AppConstants.globalTypeBond &&
            element.bondType == bondType &&
            element.bondCode == bondCode)
        .toList();
    if (bond.isNotEmpty) {
      initPage(oldId: bond.first.bondId!, type: bond.first.bondType!);
    } else {
      Get.snackbar("خطأ رقم السند", "رقم السند غير موجود",
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ));
      codeController.text = tempBondModel.bondCode ?? "";
    }

    update();
  }

  bondNextOrPrev(String bondType, bool isPrev) {
    List<GlobalModel> bond = allBondsItem.values
        .where((element) =>
            element.globalType == AppConstants.globalTypeBond &&
            element.bondType == bondType)
        .toList()
        .reversed
        .toList();
    // log(bond.map((e) => [e.bondCode.toString(),e.bondId.toString()],).toList().toString());
    bond.sort(
      (a, b) {
        if (a.bondCode!.startsWith("F") && b.bondCode!.startsWith("F")) {
          return int.parse((a.bondCode ?? "F-0").split("F-")[1])
              .compareTo(int.parse((b.bondCode ?? "F-0").split("F-")[1]));
        } else if (a.bondCode!.startsWith("F")) {
          return int.parse((a.bondCode ?? "F-0").split("F-")[1])
              .compareTo(int.parse(b.bondCode ?? "0"));
        } else if (b.bondCode!.startsWith("F")) {
          return int.parse((a.bondCode ?? "0"))
              .compareTo(int.parse((b.bondCode ?? "F-0").split("F-")[1]));
        } else {
          return int.parse(a.bondCode ?? "0")
              .compareTo(int.parse(b.bondCode ?? "0"));
        }
      },
    );
    int currentPosition = bond.indexOf(bond
            .where(
              (element) => element.bondCode == codeController.text,
            )
            .firstOrNull ??
        bond.last);

    if (isPrev) {
      if (currentPosition != 0) {
        if (bond
            .where(
              (element) => element.bondCode == codeController.text,
            )
            .isNotEmpty) {
          initPage(
              oldId: bond[currentPosition - 1].bondId!,
              type: bond[currentPosition - 1].bondType!);
        } else {
          initPage(oldId: bond.last.bondId!, type: bond.last.bondType!);
        }
      }
    } else {
      if (currentPosition < bond.length - 1) {
        initPage(
            oldId: bond[currentPosition + 1].bondId!,
            type: bond[currentPosition + 1].bondType!);
      }
    }
    update();
  }

  prevBond() {
    /* initCodeList(tempBondModel.bondType!);
    var index = codeList.values.toList().indexOf(tempBondModel.bondId!);
    if (codeList.values.toList().first == codeList.values.toList()[index]) {
    } else {
      tempBondModel = GlobalModel.fromJson(allBondsItem[codeList.values.toList()[index - 1]]?.toFullJson());
      bondModel = GlobalModel.fromJson(allBondsItem[codeList.values.toList()[index - 1]]?.toFullJson());
      if (bondModel.bondType == Const.bondTypeDaily || bondModel.bondType == Const.bondTypeStart || bondModel.bondType == Const.bondTypeInvoice) {
        Get.off(() => BondDetailsView(
              oldId: bondModel.bondId,
              bondType: bondModel.bondType!,
            ));
        update();
        initPage(tempBondModel.bondType);
      } else {
        Get.off(() => CustomBondDetailsView(
              oldId: bondModel.bondId,
              isDebit: bondModel.bondType == Const.bondTypeDebit,
            ));
        initPage(tempBondModel.bondType);
        update();
      }
    }*/
  }

  firstBond() {
    /*   initCodeList(tempBondModel.bondType!);
    var index = codeList.values.toList().indexOf(tempBondModel.bondId!);
    if (codeList.values.toList().first == codeList.values.toList()[index]) {
    } else {
      tempBondModel = GlobalModel.fromJson(allBondsItem[codeList.values.toList().first]?.toFullJson());
      bondModel = GlobalModel.fromJson(allBondsItem[codeList.values.toList().first]?.toFullJson());
      if (bondModel.bondType == Const.bondTypeDaily || bondModel.bondType == Const.bondTypeStart || bondModel.bondType == Const.bondTypeInvoice) {
        Get.off(() => BondDetailsView(
              oldId: bondModel.bondId,
              bondType: bondModel.bondType!,
            ));
        update();
        initPage(tempBondModel.bondType);
      } else {
        Get.off(() => CustomBondDetailsView(
              oldId: bondModel.bondId,
              isDebit: bondModel.bondType == Const.bondTypeDebit,
            ));
        initPage(tempBondModel.bondType);
        update();
      }
    }*/
  }

  nextBond() {
/*    var index = codeList.values.toList().indexOf(tempBondModel.bondId!);
    if (codeList.values.toList().last == codeList.values.toList()[index]) {
    } else {
      tempBondModel = GlobalModel.fromJson(allBondsItem[codeList.values.toList()[index + 1]]?.toFullJson());
      bondModel = GlobalModel.fromJson(allBondsItem[codeList.values.toList()[index + 1]]?.toFullJson());
      if (bondModel.bondType == Const.bondTypeDaily || bondModel.bondType == Const.bondTypeStart || bondModel.bondType == Const.bondTypeInvoice) {
        Get.off(() => BondDetailsView(
              oldId: bondModel.bondId,
              bondType: bondModel.bondType!,
            ));
        initPage(tempBondModel.bondType);
        update();
      } else {
        Get.off(() => CustomBondDetailsView(
              oldId: bondModel.bondId,
              isDebit: bondModel.bondType == Const.bondTypeDebit,
            ));
        initPage(tempBondModel.bondType);
        update();
      }
    }*/
  }

  lastBond() {
    /*  var index = codeList.values.toList().indexOf(tempBondModel.bondId!);
    if (codeList.values.toList().last == codeList.values.toList()[index]) {
    } else {
      tempBondModel = GlobalModel.fromJson(allBondsItem[codeList.values.toList().last]?.toFullJson());
      bondModel = GlobalModel.fromJson(allBondsItem[codeList.values.toList().last]?.toFullJson());
      if (bondModel.bondType == Const.bondTypeDaily || bondModel.bondType == Const.bondTypeStart || bondModel.bondType == Const.bondTypeInvoice) {
        Get.off(() => BondDetailsView(
              oldId: bondModel.bondId,
              bondType: bondModel.bondType!,
            ));
        initPage(tempBondModel.bondType);
        update();
      } else {
        Get.off(() => CustomBondDetailsView(
              oldId: bondModel.bondId,
              isDebit: bondModel.bondType == Const.bondTypeDebit,
            ));
        initPage(tempBondModel.bondType);
        update();
      }
    }*/
  }

  String getNextBondCode({String? type}) {
    initCodeList(type ?? (tempBondModel.bondType!));
    int _ = 0;
    if (codeList.isEmpty) {
      return "0";
    } else {
      if (codeList.keys.last.startsWith("F")) {
        _ = int.parse(codeList.keys.last.split("F-")[1]);
      } else {
        _ = int.parse(codeList.keys.last);
      }
      while (codeList.containsKey(_.toString())) {
        _++;
      }
    }
    return _.toString();
  }

  String? checkValidate() {
    var _;
    tempBondModel.bondRecord?.forEach((element) {
      if (element.bondRecAccount == '' ||
          element.bondRecAccount == null ||
          element.bondRecId == null ||
          (element.bondRecCreditAmount == 0 &&
              element.bondRecDebitAmount == 0)) {
        // print("empty");
        _ = "الحقول فارغة";
      } else {
        // print("ok");
      }
    });
    if (_ != null) return _;
    if ((tempBondModel.bondType == AppConstants.bondTypeDaily ||
            tempBondModel.bondType == AppConstants.bondTypeStart) &&
        double.parse(tempBondModel.bondTotal!) != 0) {
      return "خطأ بالمجموع";
    } else if ((tempBondModel.bondType != AppConstants.bondTypeDaily &&
            tempBondModel.bondType != AppConstants.bondTypeStart) &&
        double.parse(tempBondModel.bondTotal!) == 0) {
      return "خطأ بالمجموع";
    }
    if (tempBondModel.bondCode == null ||
        int.tryParse(tempBondModel.bondCode!) == null) {
      return "الرمز فارغ";
    }
    return null;
  }
}
// String getNextBondCode(){
//   var bondController = Get.find<BondViewModel>();
//   if(bondController.allBondsItem.values.isEmpty){
//     return "1";
//   }
//   List codeList=bondController.allBondsItem.values.toList().map((e) => e.bondCode).toList();
//   String code=codeList.last;
//   code =(int.parse(code)+1).toString();
//   while (codeList.contains(code)) {
//     code =(int.parse(code)+1).toString();
//   }
//   return code;
// }
