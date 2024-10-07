import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/entry_bond_view_model.dart';
import 'package:ba3_business_solutions/model/cheque_rec_model.dart';
import 'package:ba3_business_solutions/model/entry_bond_record_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/view/cheques/widget/all_cheques_view_data_grid_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Const/const.dart';
import '../utils/generate_id.dart';
import 'global_view_model.dart';

class ChequeViewModel extends GetxController {
  RxMap<String, GlobalModel> allCheques = <String, GlobalModel>{}.obs;
  late AllChequesViewDataGridSource chequeRecordViewDataSource;
  late DataGridController dataViewGridController;
  late AllChequesViewDataGridSource recordViewDataSource;
  var accountController = Get.find<AccountViewModel>();
  var entryBondController = Get.find<EntryBondViewModel>();
  GlobalModel? initModel;
  GlobalModel? chequeModel;

  ChequeViewModel() {
    getAllCheques();
    initChequeViewPage();
  }

  ///checked
  initChequeViewPage() {
    dataViewGridController = DataGridController();
    recordViewDataSource = AllChequesViewDataGridSource(allCheques);
    //update();
  }

  void getAllCheques() async {
/*    FirebaseFirestore.instance.collection(Const.chequesCollection).get().then((value) async {
      print("Listen from fire base Get all cheques");
      allCheques.clear();
      for (var element in value.docs) {
        element.reference.collection(Const.recordCollection).snapshots().listen((value0) async {
          allCheques[element.id]?.cheqRecords = [];
          var _ = value0.docs.map((e) => ChequeRecModel.fromJson(e.data())).toList();
          allCheques[element.id] = GlobalModel.fromJson(element.data());
          allCheques[element.id]?.cheqId=element.id;
          allCheques[element.id]?.cheqRecords=_;
          initChequeViewPage();
          update();
        });
      }
      update();
    });*/
  }
  ///checked
  void initGlobalCheque(GlobalModel globalModel) {
/*    if (allCheques.containsKey(globalModel.cheqId)) {
      allCheques[globalModel.cheqId]?.cheqRecords?.forEach((element) {
        if (entryBondController.allEntryBonds.containsKey(element.cheqRecEntryBondId)) {
          entryBondController.allEntryBonds.remove(element.cheqRecEntryBondId);
        }
      });
    }*/
    allCheques[globalModel.cheqId!] = globalModel;
  }

  ///checked
  deleteGlobalCheque(GlobalModel globalModel) async {
    allCheques.removeWhere((key, value) => key == globalModel.cheqId);
    // globalModel.cheqRecords?.forEach((element) {
    //   entryBondController.deleteBondById(element.cheqRecEntryBondId);
    //   accountController.deleteAccountRecordById(element.cheqRecEntryBondId, element.cheqRecPrimeryAccount);
    //   accountController.deleteAccountRecordById(element.cheqRecEntryBondId, element.cheqRecSecoundryAccount);
    // });
    initChequeViewPage();
    update();
  }

  ///checked
  addCheque(GlobalModel globalModel) async {
    print(globalModel.toFullJson());
    await FirebaseFirestore.instance.collection(Const.chequesCollection).doc(globalModel.cheqId).set(globalModel.toFullJson());
    entryBondController.allEntryBonds[globalModel.entryBondId!]=globalModel;
    allCheques[globalModel.cheqId!]=globalModel;
    // GlobalViewModel globalController = Get.find<GlobalViewModel>();
    // globalController.addGlobalCheque(globalModel);
    initModel=globalModel;
    update();
  }

/*  Future<void> updateCheque(GlobalModel globalModel) async {
    await deleteGlobalCheque(initModel!).then((value) async {
      if (!initModel!.cheqPrimeryAccount!.contains("acc")) initModel!.cheqPrimeryAccount = getAccountIdFromText(initModel!.cheqPrimeryAccount);
      if (!initModel!.cheqSecoundryAccount!.contains("acc")) initModel!.cheqSecoundryAccount = getAccountIdFromText(initModel!.cheqSecoundryAccount);
      if (withLogger) logger(oldData: allCheques[initModel?.cheqId]!, newData: initModel);
      await FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).delete();
      var initBond = initModel!.cheqRecords?.where((element) => element.cheqRecType == Const.chequeRecTypeInit).first;
      initModel!.cheqRecords?.remove(initBond);
      // await addCheque(oldId: initModel?.cheqId, oldEntryBondId: initBond?.cheqRecEntryBondId);
      initModel!.cheqRecords?.forEach((element) {
        if (element.cheqRecType == Const.chequeRecTypeAllPayment) {
          payAllAmount(oldEntryBondId: element.cheqRecEntryBondId, ispayEdit: true);
        }
        if (element.cheqRecType == Const.chequeRecTypePartPayment) {
          payAmount(element.cheqRecAmount, oldEntryBondId: element.cheqRecEntryBondId, ispayEdit: true);
        }

        // addRecord(element);
      });

      initChequeViewPage();
      update();
    });
  }*/
  // Future<void> deleteCheque({withLogger = false}) async {
  //   var id = initModel?.cheqId;
  //   if (withLogger) logger(oldData: allCheques[id]!);
  //   for (var element in initModel!.cheqRecords!) {
  //     await updateDeleteRecord(element.cheqRecBondId, isPayEdit: true);
  //   }
  //   // initModel!.cheqRecords = [];
  //   await FirebaseFirestore.instance.collection(Const.chequesCollection).doc(id).delete();
  //   // initModel?.cheqRecords?.forEach((element) async {
  //   //   await FirebaseFirestore.instance.collection(Const.chequesCollection).doc(id).collection(Const.recordCollection).doc(element.cheqRecBondId).delete();
  //   // });
  //   print("finish delete");
  //   print("---------------------------------------");
  //   //allCheques.remove(id);
  //   initChequeViewPage();
  //   update();
  //   //Get.back();
  // }
  // Future<void> updateGlobalCheque() async {
  //   if (!initModel!.cheqPrimeryAccount!.contains("acc")) initModel!.cheqPrimeryAccount = getAccountIdFromText(initModel!.cheqPrimeryAccount);
  //   if (!initModel!.cheqSecoundryAccount!.contains("acc")) initModel!.cheqSecoundryAccount = getAccountIdFromText(initModel!.cheqSecoundryAccount);
  //   //if (withLogger) logger(oldData: allCheques[initModel?.cheqId]!, newData: initModel);
  //   var initBond = initModel!.cheqRecords?.where((element) => element.cheqRecType == Const.chequeRecTypeInit).first;
  //   initModel!.cheqRecords?.remove(initBond);
  //   await addCheque(oldId: initModel?.cheqId, oldBondId: initBond?.cheqRecBondId);
  //   initModel!.cheqRecords?.forEach((element) {
  //     if (element.cheqRecType == Const.chequeRecTypeAllPayment) {
  //       payAllAmount(oldBondId: element.cheqRecBondId, ispayEdit: true);
  //     }
  //     if (element.cheqRecType == Const.chequeRecTypePartPayment) {
  //       payAmount(element.cheqRecAmount, oldBondId: element.cheqRecBondId, ispayEdit: true);
  //     }
  //     // addRecord(element);
  //   });
  //
  //   var globalController = Get.find<GlobalViewModel>();
  //   globalController.updateGlobalCheque(initModel!);
  //   //FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).collection(Const.recordCollection).doc(bondId).set(recMap.toJson());
  //   initChequeViewPage();
  //   update();
  // }

  ///checked
  Future<void> updateDeleteRecord(id, {type, required bool isPayEdit}) async {
    if (type != null) {
      initModel?.cheqStatus = type;
    }

    ChequeRecModel _ = initModel!.cheqRecords!.where((element) => element.cheqRecEntryBondId == id).first;
    initModel?.cheqRecords?.removeWhere((element) => element.cheqRecEntryBondId == id);

    var globalController = Get.find<GlobalViewModel>();
    globalController.deleteDataInAll(entryBondController.allEntryBonds[id]!);
    globalController.updateGlobalCheque(initModel!);

    // bondController.deleteGlobalBond(GlobalModel(bondId:id ));
    update();
  }

  ///checked
  List<String> _accountPickList = [];
  Future<String> getAccountComplete(text, type) async {
    _accountPickList = [];
    var _;
    accountController.accountList.forEach((key, value) {
      _accountPickList.addIf((value.accCode!.toLowerCase().contains(text.toLowerCase()) || value.accName!.toLowerCase().contains(text.toLowerCase())) && value.accType == type, value.accName!);
    });
    if (_accountPickList.length > 1) {
      await Get.defaultDialog(
        title: "اختر احد الحسابات",
        content: SizedBox(
          width: Get.height / 2,
          height: Get.height / 2,
          child: ListView.builder(
            itemCount: _accountPickList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  update();
                  Get.back();
                  _ = _accountPickList[index];
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(8),
                  width: 500,
                  child: Center(
                    child: Text(
                      _accountPickList[index],
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      return _;
    } else if (_accountPickList.length == 1) {
      return _accountPickList[0];
    } else {
      Get.snackbar("فحص المطاييح", "هذا المطيح غير موجود من قبل");
      return "";
    }
  }

  ///checked
  bool checkAccountComplete(text, type) {
    _accountPickList = [];
    var _;
    accountController.accountList.forEach((key, value) {
      _accountPickList.addIf((value.accCode!.toLowerCase().contains(text.toLowerCase()) || value.accName!.toLowerCase().contains(text.toLowerCase())) && value.accType == type, value.accName!);
    });
    if (_accountPickList.length == 1) {
      if (text == _accountPickList.first) {
        return true;
      }
    }
    return false;
  }

  ///checked
  void payAllAmount({String? oldEntryBondId, required bool ispayEdit}) {
    initModel?.cheqStatus = Const.chequeStatusPaid;
    allCheques[initModel?.cheqId]?.cheqStatus = Const.chequeStatusPaid;

    FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).update({"cheqStatus": Const.chequeStatusPaid});
    var entryBondId = oldEntryBondId ?? generateId(RecordType.entryBond);
    entryBondController.fastAddBondAddToModel(globalModel: GlobalModel(entryBondId: entryBondId, originId: initModel!.cheqId!, cheqAllAmount: initModel!.cheqAllAmount!, bondType: Const.bondTypeInvoice),record: [
      EntryBondRecordModel("00", double.parse(initModel!.cheqAllAmount!), 0, initModel?.cheqType == Const.chequeTypeCatch ? initModel!.cheqBankAccount! : initModel!.cheqSecoundryAccount!, "تم التوليد من الشيكات", invId: initModel?.cheqId),
      EntryBondRecordModel("01", 0, double.parse(initModel!.cheqAllAmount!), initModel?.cheqType == Const.chequeTypeCatch ? initModel!.cheqSecoundryAccount! : initModel!.cheqBankAccount!, "تم التوليد من الشيكات", invId: initModel?.cheqId),
    ]);
    ChequeRecModel recMap = ChequeRecModel(
      cheqRecEntryBondId: entryBondId,
      cheqRecAmount: initModel!.cheqAllAmount!,
      cheqRecType: Const.chequeRecTypeAllPayment,
      cheqRecId: initModel?.cheqId,
      cheqRecChequeType: initModel?.cheqType,
      cheqRecPrimeryAccount: initModel!.cheqSecoundryAccount,
      cheqRecSecoundryAccount: initModel!.cheqBankAccount,
    );
    // var recMap = {
    //   "cheqRecBondId": bondId,
    //   "cheqRecAmount": initModel!.cheqAllAmount!,
    //   "cheqRecType": Const.chequeRecTypeAllPayment,
    // };
    initModel?.cheqRecords?.removeWhere((element) => element.cheqRecEntryBondId == entryBondId);
    allCheques[initModel?.cheqId]?.cheqRecords?.removeWhere((element) => element.cheqRecEntryBondId == entryBondId);
    // if (!ispayEdit) {
    initModel?.cheqRecords?.add(ChequeRecModel.fromJson(recMap.toJson()));
    allCheques[initModel?.cheqId]?.cheqRecords?.add(ChequeRecModel.fromJson(recMap.toJson()));
    // }
    var globalController = Get.find<GlobalViewModel>();
    globalController.updateGlobalCheque(initModel!);
    //initModel?.cheqRecords?.add(ChequeRecModel.fromJson(recMap.toJson()));
    // FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).collection(Const.recordCollection).doc(bondId).set(recMap.toJson());
    initChequeViewPage();
    update();
  }

  void payAmount(amount, {String? oldEntryBondId, required bool ispayEdit}) {
    String status;
    print("_________________________");
    List<ChequeRecModel?>? payment_list = initModel?.cheqRecords?.cast<ChequeRecModel?>().where((element) => element?.cheqRecType == Const.chequeRecTypePartPayment).toList();
    if (payment_list != null && payment_list.isNotEmpty) {
      if (!ispayEdit && payment_list.map((e) => double.parse(e!.cheqRecAmount!)).toList().reduce((value, element) => value + element) + double.parse(amount) == double.parse(initModel!.cheqAllAmount!)) {
        initModel?.cheqStatus = Const.chequeStatusPaid;
        status = Const.chequeStatusPaid;
      } else if (ispayEdit && payment_list.map((e) => double.parse(e!.cheqRecAmount!)).toList().reduce((value, element) => value + element) == double.parse(initModel!.cheqAllAmount!)) {
        initModel?.cheqStatus = Const.chequeStatusPaid;
        status = Const.chequeStatusPaid;
      } else if (!ispayEdit && payment_list.map((e) => double.parse(e!.cheqRecAmount!)).toList().reduce((value, element) => value + element) + double.parse(amount) > double.parse(initModel!.cheqAllAmount!)) {
        return;
      } else if (double.parse(amount) == double.parse(initModel!.cheqAllAmount!)) {
        initModel?.cheqStatus = Const.chequeStatusPaid;
        status = Const.chequeStatusPaid;
      } else {
        initModel?.cheqStatus = Const.chequeStatusNotAllPaid;
        status = Const.chequeStatusNotAllPaid;
      }
    } else if (double.parse(amount) == double.parse(initModel!.cheqAllAmount!)) {
      initModel?.cheqStatus = Const.chequeStatusPaid;
      status = Const.chequeStatusPaid;
    } else if (double.parse(amount) > double.parse(initModel!.cheqAllAmount!)) {
      print("error " * 20);
      return;
    } else {
      initModel?.cheqStatus = Const.chequeStatusNotAllPaid;
      status = Const.chequeStatusNotAllPaid;
    }
    print(amount + "  " + initModel!.cheqAllAmount!);
    print("_________________________");
    FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).update({"cheqStatus": status});
    var entryBondId = oldEntryBondId ?? generateId(RecordType.entryBond);
    entryBondController.fastAddBondAddToModel(globalModel : GlobalModel(entryBondId: entryBondId, originId: initModel!.cheqId!, cheqAllAmount: initModel!.cheqAllAmount!, bondType: Const.bondTypeInvoice), record: [
      EntryBondRecordModel("00", double.parse(amount), 0, initModel?.cheqType == Const.chequeTypeCatch ? initModel!.cheqBankAccount! : initModel!.cheqSecoundryAccount!, "تم التوليد من الشيكات", invId: initModel?.cheqId),
      EntryBondRecordModel("01", 0, double.parse(amount), initModel?.cheqType == Const.chequeTypeCatch ? initModel!.cheqSecoundryAccount! : initModel!.cheqBankAccount!, "تم التوليد من الشيكات", invId: initModel?.cheqId),
    ]);
    // var recMap = {
    //   "cheqRecBondId": bondId,
    //   "cheqRecAmount": amount,
    //   "cheqRecType": Const.chequeRecTypePartPayment,
    // };
    ChequeRecModel recMap = ChequeRecModel(
      cheqRecEntryBondId: entryBondId,
      cheqRecAmount: amount,
      cheqRecType: Const.chequeRecTypePartPayment,
      cheqRecId: initModel?.cheqId,
      cheqRecChequeType: initModel?.cheqType,
      cheqRecPrimeryAccount: initModel!.cheqSecoundryAccount,
      cheqRecSecoundryAccount: initModel!.cheqBankAccount,
    );
    if (!ispayEdit) {
      initModel?.cheqRecords?.add(ChequeRecModel.fromJson(recMap.toJson()));
    }
    var globalController = Get.find<GlobalViewModel>();
    globalController.updateGlobalCheque(initModel!);
    // FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).collection(Const.recordCollection).doc(bondId).set(recMap.toJson());
    initChequeViewPage();
    update();
  }

  // addRecord(ChequeRecModel model) {
  //   bondController.fastAddBondAddToModel(bondId: model.cheqRecBondId, originId: model!.cheqRecId!, total: double.parse(model!.cheqRecAmount!), record: [
  //     BondRecordModel("00", double.parse(model!.cheqRecAmount!), 0, model?.cheqRecChequeType == Const.chequeTypeCatch ? model!.cheqRecPrimeryAccount! : model!.cheqRecSecoundryAccount!, "تم التوليد من الشيكات", invId: model?.cheqRecId),
  //     BondRecordModel("01", 0, double.parse(model!.cheqRecAmount!), model?.cheqRecChequeType == Const.chequeTypeCatch ? model!.cheqRecSecoundryAccount! : model!.cheqRecPrimeryAccount!, "تم التوليد من الشيكات", invId: model?.cheqRecId),
  //   ]);
  //   //initModel?.cheqRecords?.add(model);
  //   FirebaseFirestore.instance.collection(Const.chequesCollection).doc(model?.cheqRecId).collection(Const.recordCollection).doc(model.cheqRecBondId).set(model.toJson());
  // }

  prevCheq() {
    var index = allCheques.keys.toList().indexOf(initModel!.cheqId!);
    if (allCheques.keys.toList().first == allCheques.keys.toList()[index]) {
    } else {
      initModel = GlobalModel.fromJson(allCheques.values.toList()[index - 1].toFullJson());
      update();
    }
  }

  nextCheq() {
    var index = allCheques.keys.toList().indexOf(initModel!.cheqId!);
    if (allCheques.keys.toList().last == allCheques.keys.toList()[index]) {
    } else {
      initModel = GlobalModel.fromJson(allCheques.values.toList()[index + 1].toFullJson());
      update();
    }
  }

  void changeIndexCode({required String code}) {
    var model = allCheques.values.toList().firstWhereOrNull((element) => element.cheqCode == code);
    if (model == null) {
      Get.snackbar("error", "not found");
    } else {
      initModel = GlobalModel.fromJson(model.toFullJson());
      update();
    }
  }
}
