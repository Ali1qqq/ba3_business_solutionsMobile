import 'package:ba3_business_solutions/Widgets/CustomerPlutoEditView.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/model/AccountCustomer.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/account_tree.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:ba3_business_solutions/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Const/const.dart';
import '../model/account_record_model.dart';
import '../model/entry_bond_record_model.dart';
import '../utils/generate_id.dart';
import '../view/accounts/widget/account_record_data_source.dart';
import '../view/accounts/widget/account_view_data_grid_source.dart';
import 'changes_view_model.dart';

class AccountViewModel extends GetxController {
  // RxMap<String, RxList<AccountRecordModel>> allAccounts = <String, RxList<AccountRecordModel>>{}.obs;
  late AccountRecordDataSource accountRecordDataSource;
  late AccountRecordDataSource recordDataSource;
  RxMap<String, AccountModel> accountList = <String, AccountModel>{}.obs;
  late DataGridController dataGridController;

  // final CollectionReference _accountCollectionRef = FirebaseFirestore.instance.collection(Const.accountsCollection);
  late DataGridController dataViewGridController;
  late AccountViewDataGridSource recordViewDataSource;
  List<AccountModel> aggregateList = [];
  double total = 0.0;

  AccountViewModel() {
    getAllAccount();
  }

  List<String> aminCods = [];

  initGlobalAccount(GlobalModel globalModel, {String? oldAccountKey, List<String>? accountsId}) async {
    String? type;
    String? date;
    if (globalModel.globalType == Const.globalTypeBond) {
      type = globalModel.bondType!;
      date = globalModel.bondDate!;
    } else if (globalModel.globalType == Const.globalTypeInvoice) {
      type = globalModel.patternId!;
      date = globalModel.invDate!;
    } else if (globalModel.globalType == Const.globalTypeCheque) {
      type = globalModel.cheqType!;
      date = globalModel.cheqDate!;
    } else {
      type = Const.bondTypeStart;
      date = globalModel.invDueDate;
    }
    List<EntryBondRecordModel>? currentEntry = globalModel.entryBondRecord!
        .where(
          (element) => accountsId?.contains(element.bondRecAccount) ?? false,
        )
        .toList();

    for (int i = 0; i < currentEntry.length; i++) {
      var recCredit = currentEntry[i].bondRecDebitAmount! - currentEntry[i].bondRecCreditAmount!;
      accountList[accountsId!.last]!.accRecord.add(
            AccountRecordModel(globalModel.invId ?? globalModel.bondId ?? globalModel.entryBondId, currentEntry[i].bondRecAccount!, recCredit.toString(), 0, type, date, type.startsWith("pat") ? globalModel.invCode : globalModel.bondCode,
                (accountList[accountsId.last]!.accRecord.lastOrNull?.subBalance ?? 0) + recCredit, currentEntry[i].bondRecDebitAmount, currentEntry[i].bondRecCreditAmount!),
          );
    }
  }

  initAccBalanceFromBond(GlobalModel globalModel, {List<String>? accountsId}) async {
    List<EntryBondRecordModel>? currentEntry = globalModel.entryBondRecord!
        .where(
          (element) => accountsId!.contains(element.bondRecAccount),
        )
        .toList();
    if (accountsId!.contains(globalModel.cheqPrimeryAccount)) {
      accountList[accountsId.last]!.finalBalance = accountList[accountsId.last]!.finalBalance! + double.parse(globalModel.cheqAllAmount!);
    }
    for (int i = 0; i < currentEntry.length; i++) {
      var recCredit = currentEntry[i].bondRecDebitAmount! - currentEntry[i].bondRecCreditAmount!;
      accountList[accountsId.last]!.finalBalance = accountList[accountsId.last]!.finalBalance! + recCredit;
    }
  }

  initDueInv(GlobalModel globalModel, {List<String>? accountsId}) async {
    if (accountsId!.contains(globalModel.invPrimaryAccount)) {
      if (accountList[accountsId.last]!.finalBalance! > globalModel.invTotal!) {
        accountList[accountsId.last]!.accRecord.add(
              AccountRecordModel(globalModel.invId, globalModel.invPrimaryAccount!, globalModel.invTotal!.toString(), 0, globalModel.patternId, globalModel.invDate, globalModel.invCode, 0, 0, globalModel.invTotal!),
            );
      } else {
        accountList[accountsId.last]!.accRecord.add(
              AccountRecordModel(globalModel.invId, globalModel.invPrimaryAccount!, globalModel.invTotal!.toString(), accountList[accountsId.last]!.finalBalance! > 0 ? globalModel.invTotal! - accountList[accountsId.last]!.finalBalance! : globalModel.invTotal!, globalModel.patternId,
                  globalModel.invDueDate, globalModel.invCode, (accountList[accountsId.last]!.accRecord.lastOrNull?.subBalance ?? 0) + globalModel.invTotal!, 0, globalModel.invTotal!),
            );
      }
      accountList[accountsId.last]!.finalBalance = accountList[accountsId.last]!.finalBalance! - globalModel.invTotal!;
    }
  }

  void setDueAccount(String accountKey) {
    if (accountList[accountKey]!.accRecord.length > 1) {
      double accountBalance = getBalance(accountKey);
      if (accountBalance == 0) {
        for (var i = 0; i < accountList[accountKey]!.accRecord.length; i++) {
          accountList[accountKey]!.accRecord[i].isPaidStatus = Const.paidStatusFullUsed;
        }
      }
      if (accountBalance == 0) {
        for (var i = 0; i < accountList[accountKey]!.accRecord.length; i++) {
          accountList[accountKey]!.accRecord[i].isPaidStatus = Const.paidStatusFullUsed;
        }
      } else if (accountBalance > 0) {
        for (var i = 0; i < accountList[accountKey]!.accRecord.length; i++) {
          accountList[accountKey]!.accRecord[i].isPaidStatus = Const.paidStatusFullUsed;
        }
      } else if (accountBalance < 0) {
        double _ = 0;
        bool isFound = false;
        for (var i = 0; i < accountList[accountKey]!.accRecord.length; i++) {
          AccountRecordModel element = accountList[accountKey]!.accRecord.reversed.toList()[i];
          element.isPaidStatus = null;
          if (double.parse(element.total!) < 0) {
            _ = double.parse(element.total!).abs() + _;
          }
          if (double.parse(element.total!) > 0) {
            element.isPaidStatus = Const.paidStatusFullUsed;
            element.paid = double.parse(element.total!);
          } else {
            if (accountBalance.abs() <= _ && !isFound) {
              if (_ - accountBalance.abs() > 0) {
                element.isPaidStatus = Const.paidStatusSemiUsed;
                element.paid = _ - accountBalance.abs();
              } else {
                element.isPaidStatus = Const.paidStatusNotUsed;
              }
              isFound = true;
            } else {
              if (isFound) {
                element.isPaidStatus = Const.paidStatusFullUsed;
              } else {
                element.isPaidStatus = Const.paidStatusNotUsed;
                element.paid = accountBalance;
              }
            }
          }
        }
      }
    }
  }

  bool isLoadingBond = false;

  List<AccountRecordModel> currentViewAccount = [];
  double searchValue = 0.0;
  double debitValue = 0.0;
  double creditValue = 0.0;

  Future<void> getAllBondForAccount(List<String> modeKey, List<String> allDate) async {
    accountList[modeKey.last]?.accRecord.clear();
    GlobalViewModel globalViewModel = Get.find<GlobalViewModel>();
    List<GlobalModel> globalModels = globalViewModel.allGlobalModel.values.where((element) => (allDate.contains(element.bondDate?.split(" ")[0]) || allDate.contains(element.invDate?.split(" ")[0])) || allDate.contains(element.cheqDate?.split(" ")[0])).toList();
    for (var globalModel in globalModels) {
      initGlobalAccount(globalModel, accountsId: modeKey);
    }

    // searchValue = accountList[modeKey.last]?.accRecord.lastOrNull?.subBalance ?? 0;
    debitValue = accountList[modeKey.last]?.accRecord.fold(
              0.0,
              (previousValue, element) => element.debit! + previousValue!,
            ) ??
        0;
    creditValue = accountList[modeKey.last]?.accRecord.fold(
              0.0,
              (previousValue, element) => element.credit! + previousValue!,
            ) ??
        0;
    searchValue = debitValue - creditValue;
  }

  double getAllDusAccount(List<String> modeKey) {
    double dues = 0;
    accountList[modeKey.last]!.finalBalance = 0;
    accountList[modeKey.last]?.accRecord.clear();
    GlobalViewModel globalViewModel = Get.find<GlobalViewModel>();
    List<GlobalModel> globalBondAndCheck = globalViewModel.allGlobalModel.values.where((element) => element.globalType != Const.globalTypeInvoice).toList();
    List<GlobalModel> globalInvoice = globalViewModel.allGlobalModel.values.where((element) => element.invPayType == Const.invPayTypeDue).toList();
    for (var globalModel in globalBondAndCheck) {
      initAccBalanceFromBond(globalModel, accountsId: modeKey);
    }
    for (var globalModel in globalInvoice) {
      initDueInv(globalModel, accountsId: modeKey);
    }
    dues = accountList[modeKey.last]?.finalBalance ?? 0.0;
    // print(accountList[modeKey.last]?.finalBalance);
    return dues;
  }

/*  void _clearAccountRecords(List<String> modeKey) {
    for (var element in modeKey) {
      accountList[element]!.accRecord.clear();
    }
  }*/

  void deleteGlobalAccount(GlobalModel globalModel) {
    globalModel.bondRecord?.forEach((element) {
      accountList[element.bondRecAccount]?.accRecord.removeWhere((e) => e.id == globalModel.entryBondId || e.id == globalModel.invId || e.id == globalModel.bondId);
      // calculateBalance(element.bondRecAccount!);
    });
    // initAccountViewPage();
    // update();
    // if (lastAccountOpened != null) {
    //   initAccountPage(lastAccountOpened!);
    //   update();
    // }
  }

  initAccountViewPage() {
    dataViewGridController = DataGridController();
    recordViewDataSource = AccountViewDataGridSource(accountList);
    //update();
  }

  getAllAccount() {
    accountList.clear();
    if (HiveDataBase.accountModelBox.isEmpty) {
      print("THE ACCOUNT IS READ FROM FIREBASE");
      print("-" * 500);

      FirebaseFirestore.instance.collection(Const.accountsCollection).get().then((value) {
        RxMap<String, List<AccountRecordModel>> oldAccountList = <String, List<AccountRecordModel>>{}.obs;
        accountList.forEach((key, value) {
          oldAccountList[key] = value.accRecord;
        });
        accountList.clear();
        for (var element in value.docs) {
          HiveDataBase.accountModelBox.put(element.id, AccountModel.fromJson(element.data()));
          accountList[element.id] = AccountModel.fromJson(element.data());
          accountList[element.id]?.accRecord = oldAccountList[element.id] ?? [];
        }
        initModel();
        initPage();
      });
    } else {
      for (var element in HiveDataBase.accountModelBox.values) {
        if (element.accId == null) {
        } else {
          accountList[element.accId!] = element;
          accountList[element.accId!]!.accRecord.clear();
        }
      }
      initModel();
      initPage();
      go(lastIndex);
    }
  }

  addAccountToMemory(Map json) {
    AccountModel accountModel = AccountModel.fromJson(json);
    List<AccountRecordModel> oldData = [];
    if (accountList[accountModel.accId!] != null) {
      oldData = accountList[accountModel.accId!]!.accRecord;
    }
    accountModel.accRecord = oldData;
    accountList[accountModel.accId!] = accountModel;
    HiveDataBase.accountModelBox.put(accountModel.accId, accountModel);

    update();
    initModel();
    initPage();
    go(lastIndex);
  }

  void removeAccountFromMemory(Map json) {
    AccountModel accountModel = AccountModel.fromJson(json);
    accountList.remove(accountModel.accId);
    HiveDataBase.accountModelBox.delete(accountModel.accId);
    update();
    initModel();
    initPage();
    go(lastIndex);
  }

  String? lastAccountOpened;

  // void getAllAccounts({oldKey}) async {
  //   FirebaseFirestore.instance.collection(Const.accountsCollection).snapshots().listen((value) async {
  //     // for (var element in value.docs) {
  //     //   element.reference.collection(Const.recordCollection).snapshots().listen((value0) {
  //     //     allAccounts[element.id] = <AccountRecordModel>[].obs;
  //     //     for (var element0 in value0.docs) {
  //     //       allAccounts[element.id]?.add(AccountRecordModel.fromJson(element0.data()));
  //     //     }
  //     //     calculateBalance(element.id);
  //     //     if(lastAccountOpened!=null)initAccountPage(lastAccountOpened);
  //     //     update();
  //     //   });
  //     // }
  //
  //     update();
  //   });
  // }

  initAccountPage(modeKey) {
    lastAccountOpened = modeKey;
    if (accountList[modeKey]!.accAggregateList.isNotEmpty) {
      aggregateList.assignAll(accountList[modeKey]!.accAggregateList.map((e) => getAccountModelFromId(e)!));
    }
    dataGridController = DataGridController();
    recordDataSource = AccountRecordDataSource(accountRecordModel: (accountList[modeKey]?.accRecord ?? []), accountModel: accountList[modeKey]!);
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then(
      (value) {
        update();
      },
    );
  }

  ///----------------------------

  addNewAccount(AccountModel accountModel, {bool withLogger = false}) async {
    if (accountList.values.toList().map((e) => e.accCode).toList().contains(accountModel.accCode)) {
      Get.snackbar("فحص المطاييح", "هذا المطيح مستخدم من قبل");
      return;
    }
    String id = generateId(RecordType.account);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    accountModel.accId ??= id;
    accountModel.accCustomer = Get.find<CustomerPlutoEditViewModel>().handleSaveAll(accountModel.accId!);

    if (accountModel.accParentId == null) {
      accountModel.accIsParent = true;
    } else {
      FirebaseFirestore.instance.collection(Const.accountsCollection).doc(accountModel.accParentId).update({
        'accChild': FieldValue.arrayUnion([accountModel.accId]),
      });
      if (!accountList[accountModel.accParentId!]!.accChild.contains(accountModel.accId)) {
        accountList[accountModel.accParentId!]!.accChild.add(accountModel.accId);
        await changesViewModel.addChangeToChanges(accountModel.toFullJson(), Const.accountsCollection);
      }
      accountModel.accIsParent = false;
    }
    for (var i = 0; i < accountModel.accAggregateList.length; i++) {
      if (!accountModel.accAggregateList[i].toString().startsWith('acc')) {
        accountModel.accAggregateList[i] = accountList.values.toList().firstWhere((e) => e.accName == accountModel.accAggregateList[i]).accId;
      }
    }
    accountModel.accAggregateList.assignAll(aggregateList.map((e) => e.accId));
    // if (withLogger) logger(newData: accountModel);
    await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(accountModel.accId).set(accountModel.toJson());

    await changesViewModel.addChangeToChanges(accountModel.toFullJson(), Const.accountsCollection);
    accountList[accountModel.accId!] = accountModel;
    Get.snackbar("", " تم اضافة الحساب");
    // recordViewDataSource.updateDataGridSource();
    // accountRecordDataSource.updateDataGridSource();
    saveToHive(accountModel);
    go(lastIndex);
  }

  // Future<void> updateInAccount(GlobalModel model, {String? modelKey}) async {
  //   Map<String, int> oldIndex = {};
  //   accountList.forEach((key, value) {
  //     for (var element in value.accRecord.toList()) {
  //       if (element.id == model.bondId) {
  //         oldIndex[key] = accountList[key]!.accRecord.indexWhere((element) => element.id == model.bondId);
  //         FirebaseFirestore.instance.collection(Const.accountsCollection).doc(key).collection(Const.recordCollection).doc(model.bondId).delete();
  //       }
  //     }
  //   });
  //
  //   var con = Get.find<BondViewModel>();
  //   con.saveRecordInFirebase(model);
  //   if (modelKey != null) {
  //     calculateBalance(modelKey);
  //     initAccountPage(modelKey);
  //   }
  //   update();
  // }
  getBalanceForPrimary(List<String> accounts) {
    for (var account in accounts) {
      getBalance(account);
    }
    update();
  }

  double getBalance(String userId) {
    double total = 0;
    accountList[userId]?.accRecord.clear();
    GlobalViewModel globalViewModel = Get.find<GlobalViewModel>();
    for (var globalModel in globalViewModel.allGlobalModel.values.toList()) {
      initGlobalAccount(globalModel, accountsId: [userId]);
    }

    debitValue = accountList[userId]?.accRecord.fold(
              0.0,
              (previousValue, element) => element.debit! + previousValue!,
            ) ??
        0;
    creditValue = accountList[userId]?.accRecord.fold(
              0.0,
              (previousValue, element) => element.credit! + previousValue!,
            ) ??
        0;

    total = debitValue - creditValue;
    return total;
  }

  int getCount(userId) {
    int _ = 0;
    if (accountList[userId]!.accRecord.isNotEmpty) {
      _ = accountList[userId]!.accRecord.length;
    }
    return _;
  }

  String getLastCode() {
    List<int> allCode = accountList.values
        .where(
          (element) => (!element.accCode!.contains("F")),
        )
        .map((e) => int.parse(e.accCode!))
        .toList();
    int _ = 0;
    if (accountList.isEmpty) {
      return "0";
    } else {
      _ = int.parse(accountList.values.last.accCode!.replaceAll("F-", "")) + 1;
      while (allCode.contains(_)) {
        _++;
      }
      return _.toString();
    }
  }

  void calculateBalance(String modelKey) {
    double all = 0;
    if (accountList[modelKey] == null) {}
    for (AccountRecordModel element in accountList[modelKey]!.accRecord) {
      try {
        // all += double.parse(element.total!.toString());
        int? itemIndex = accountList[modelKey]!.accRecord.indexOf(element);
        accountList[modelKey]!.accRecord[itemIndex].balance = all + double.parse(element.total!.toString());
        all = (accountList[modelKey]!.accRecord[itemIndex].balance)!;
      } finally {}
    }
  }

  computeTotal(List<AccountRecordModel> billsTotal) {
    total = 0.0;
    for (int i = 0; i < billsTotal.length; i++) {
      total = total + double.parse(billsTotal[i].total!);
    }
  }

  buildSorce(String modelKey) {
    accountRecordDataSource = AccountRecordDataSource(accountRecordModel: accountList[modelKey]!.accRecord, accountModel: accountList[modelKey]!);
    dataGridController = DataGridController();
    computeTotal(accountList[modelKey]!.accRecord);
  }

  bildAry(String modelKey) {
    accountRecordDataSource = AccountRecordDataSource(accountRecordModel: accountList[modelKey]!.accRecord, accountModel: accountList[modelKey]!);
    dataGridController = DataGridController();
    computeTotal(accountList[modelKey]!.accRecord);
    update();
  }

  clear(List<TextEditingController> controllers) {
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].clear();
      update();
    }
  }

  Future<void> updateAccount(AccountModel editProductModel, {withLogger = false}) async {
    // if (withLogger) logger(oldData: accountList[editProductModel.accId]!, newData: editProductModel);
    editProductModel.accCustomer = Get.find<CustomerPlutoEditViewModel>().handleSaveAll(editProductModel.accId!);

    if (accountList[editProductModel.accId]?.accParentId != null) {
      await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(accountList[editProductModel.accId]?.accParentId).update({
        'accChild': FieldValue.arrayRemove([editProductModel.accId]),
      });
    }
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();

    if (accountList[editProductModel.accId]?.accParentId != null) {
      await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(accountList[editProductModel.accId]?.accParentId).update({
        'accChild': FieldValue.arrayRemove([editProductModel.accId]),
      });
      if (accountList[editProductModel.accParentId!]!.accChild.contains(editProductModel.accId)) {
        accountList[editProductModel.accParentId!]!.accChild.remove(editProductModel.accId);
        await changesViewModel.addChangeToChanges(editProductModel.toFullJson(), Const.accountsCollection);
      }
    }
    if (editProductModel.accParentId == null) {
      editProductModel.accIsParent = true;
    } else {
      FirebaseFirestore.instance.collection(Const.accountsCollection).doc(editProductModel.accParentId).update({
        'accChild': FieldValue.arrayUnion([editProductModel.accId]),
      });
      if (!accountList[editProductModel.accParentId!]!.accChild.contains(editProductModel.accId)) {
        accountList[editProductModel.accParentId!]!.accChild.add(editProductModel.accId);
        await changesViewModel.addChangeToChanges(editProductModel.toFullJson(), Const.accountsCollection);
      }
      editProductModel.accIsParent = false;
    }
    FirebaseFirestore.instance.collection(Const.accountsCollection).doc(editProductModel.accId).update(editProductModel.toJson());

    changesViewModel.addChangeToChanges(editProductModel.toFullJson(), Const.accountsCollection);
    saveToHive(editProductModel);
    update();
  }

  Future<void> deleteAccount(AccountModel accountModel, {withLogger = false}) async {
    if (withLogger) logger(oldData: accountList[accountModel.accId]!);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();

    if (accountList[accountModel.accId]?.accParentId != null) {
      await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(accountList[accountModel.accId]?.accParentId).update({
        'accChild': FieldValue.arrayRemove([accountModel.accId]),
      });

      if (accountList[accountModel.accParentId!]!.accChild.contains(accountModel.accId)) {
        accountList[accountModel.accParentId!]!.accChild.remove(accountModel.accId);
        await changesViewModel.addChangeToChanges(accountModel.toFullJson(), Const.accountsCollection);
      }
    }
    await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(accountModel.accId).delete();

    changesViewModel.addRemoveChangeToChanges(accountModel.toFullJson(), Const.accountsCollection);
    accountList.removeWhere((key, value) => key == accountModel.accId);
    // initAccountViewPage();
    // Get.back();
    update();
    initModel();
    initPage();
    go(lastIndex);
  }

  void addAccountRecord({bondId, accountId, amount, type, date, code}) {
    accountList[accountId]?.accRecord.removeWhere((element) => element.id == bondId);
    accountList[accountId]?.accRecord.add(AccountRecordModel(bondId, accountId, amount, 0, type, date, code, 0, 0, 0));
    calculateBalance(accountId);
    if (lastAccountOpened != null) {
      initAccountPage(lastAccountOpened!);
    }
    update();
  }

  void deleteAccountRecordById(bondId, accountId) {
    accountList[accountId]?.accRecord.removeWhere((element) => element.id == bondId);
    calculateBalance(accountId);
    if (lastAccountOpened != null) {
      initAccountPage(lastAccountOpened!);
    }
    update();
  }

  //----=--=-=--=-=-==-==-=-=-==-=-=-==-=-=-=-=-=-=-=-=-=-=/-

  String? editItem;
  TextEditingController? editCon;

  var lastIndex;
  List<AccountTree> allCost = [];

  TreeController<AccountTree>? treeController;

  // void getAllCostCenter({String? goto}) {
  //   FirebaseFirestore.instance.collection(Const.accountsCollection).snapshots().listen((value) async {
  //     costCenterModelList.clear();
  //
  //     for (var element in value.docs) {
  //       print(element.data());
  //       costCenterModelList[element.id] = AccountModel.fromJson(element.data(), element.id);
  //     }
  //     // initModel();
  //     // initPage();
  //     // go(lastIndex);
  //     // update();
  //   });
  // }

  void initModel() {
    allCost.clear();
    List<AccountModel> rootList = accountList.values.toList().where((element) => element.accIsParent ?? false).toList();
    for (var element in rootList) {
      // allCost.add(addToModel(element));
    }
  }

  AccountTree addToModel(AccountModel element) {
    var list = element.accChild.map((e) => addToModel(accountList[e]!)).toList();
    AccountTree model = AccountTree.fromJson({"name": element.accName}, element.accId, list);
    return model;
  }

  initPage() {
    treeController = TreeController<AccountTree>(
      roots: allCost,
      childrenProvider: (AccountTree node) => node.list,
    );
    update();
  }

  void setupParentList(parent) {
    allPer.add(accountList[parent]!.accId);
    if (accountList[parent]!.accParentId != null) {
      setupParentList(accountList[parent]!.accParentId);
    }
  }

  var allPer = [];

  void go(String? parent) {
    if (parent != null) {
      allPer.clear();
      setupParentList(parent);
      var allper = allPer.reversed.toList();
      List<AccountTree> _ = treeController!.roots.toList();
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
    editCon = TextEditingController(text: accountList[id]!.accName!);
    update();
  }

  void endRenameChild() {
    FirebaseFirestore.instance.collection(Const.accountsCollection).doc(editItem).update({
      "accName": editCon?.text,
    });
    editItem = null;
    update();
  }

  List<AccountModel> searchAccount(String text) {
    List<AccountModel> accountFound = [];
    if (int.tryParse(text) != null) {
      accountFound = accountList.values.where(
        (element) {
          return element.accCode == text;
        },
      ).toList();
    } else {
      accountFound = accountList.values.where(
        (element) {
          return element.accName == text;
        },
      ).toList();
    }
    if (accountFound.isEmpty) {
      accountFound = accountList.values.where(
        (element) {
          return (element.accName?.toLowerCase().contains(text.toLowerCase()) ?? false) || (element.accCode?.contains(text) ?? false);
        },
      ).toList();
    }

    return accountFound;
  }

  void setBalance(List<AccountModel> currentPageData) {
    for (var element in currentPageData) {
      HiveDataBase.accountModelBox.put(element.accId, element..finalBalance = getBalance(element.accId!));
    }
  }

  saveToHive(AccountModel editProductModel) {
    HiveDataBase.accountModelBox.put(editProductModel.accId, editProductModel);
    for (AccountCustomer element in editProductModel.accCustomer ?? []) {
      HiveDataBase.accountCustomerBox.put(element.customerAccountId, element);
    }
  }
}

String getAccountIdFromText(text) {
  var accountController = Get.find<AccountViewModel>();
  if (text != null && text != " " && text != "") {
    AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == text || element.accCode == text);
    if (_ == null) {
      return '';
    } else {
      return _.accId!;
    }
  } else {
    return '';
  }
}

AccountModel? getAccountIdFromName(text) {
  var accountController = Get.find<AccountViewModel>();
  if (text != null && text != " " && text != "") {
    AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == text);
    return _;
  } else {
    print("empty");
    return null;
  }
}

List<AccountModel> getAccountModelsFromName(text) {
  var accountController = Get.find<AccountViewModel>();
  if (text != null && text != " " && text != "") {
    List<AccountModel> _ = accountController.accountList.values.toList().where((element) => element.accName!.contains(text) || element.accCode!.contains(text)).toList();
    if (_.isEmpty) {
      print("empty");
      return [];
    } else {
      return _;
    }
  } else {
    print("empty");
    return [];
  }
}

AccountModel? getAccountModelFromName(text) {
  var accountController = Get.find<AccountViewModel>();
  if (text != null && text != " " && text != "") {
    return accountController.accountList.values.toList().where((element) => element.accName == text).toList().firstOrNull;
  } else {
    print("empty");
    return null;
  }
}

String getAccountNameFromId(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<AccountViewModel>().accountList[id]?.accName ?? "$id";
  } else {
    return "";
  }
}

double getAccountBalanceFromId(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<AccountViewModel>().getBalance(id);
  } else {
    return 0;
  }
}

AccountModel? getAccountModelFromId(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<AccountViewModel>().accountList[id]!;
  } else {
    return null;
  }

  // /--------------------------------------------------------------
}

Future<String> getAccountComplete(text) async {
  var _ = '';
  List accountPickList = [];
  Get.find<AccountViewModel>().accountList.forEach((key, value) {
    accountPickList.addIf(value.accType == Const.accountTypeDefault && (value.accCode!.toLowerCase().contains(text.toLowerCase()) || value.accName!.toLowerCase().contains(text.toLowerCase())), value.accName!);
  });
  // print(accountPickList.length);
  if (accountPickList.length > 1) {
    await Get.defaultDialog(
      title: "Chose form dialog",
      content: SizedBox(
        width: 500,
        height: 500,
        child: ListView.builder(
          itemCount: accountPickList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                _ = accountPickList[index];
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(8),
                width: 500,
                child: Center(
                  child: Text(
                    accountPickList[index],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  } else if (accountPickList.length == 1) {
    _ = accountPickList[0];
  } else {
    Get.snackbar("فحص المطاييح", "هذا المطيح غير موجود من قبل");
  }
  return _;
}

Future<AccountModel?> getAccountCompleteID(_text) async {
  AccountModel? _;
  List<AccountModel> accountPickList = [];
  String text = _text ?? "";
  Get.find<AccountViewModel>().accountList.forEach((key, value) {
    accountPickList.addIf(value.accType == Const.accountTypeDefault && (value.accCode!.toLowerCase().contains(text.toLowerCase()) || value.accName!.toLowerCase().contains(text.toLowerCase())), value);
  });
  // print(accountPickList.length);
  if (accountPickList.length > 1) {
    await Get.defaultDialog(
      title: "Chose form dialog",
      content: SizedBox(
        width: 500,
        height: 500,
        child: ListView.builder(
          itemCount: accountPickList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                _ = accountPickList[index];
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(8),
                width: 500,
                child: Center(
                  child: Text(
                    accountPickList[index].accName.toString(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  } else if (accountPickList.length == 1) {
    _ = accountPickList[0];
  } else {
    Get.snackbar("فحص المطاييح", "هذا المطيح غير موجود من قبل");
  }
  return _;
}
