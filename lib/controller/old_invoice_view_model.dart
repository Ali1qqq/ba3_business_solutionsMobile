// import 'package:ba3_business_solutions/Const/const.dart';
// import 'package:ba3_business_solutions/controller/bond_view_model.dart';
// import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
// import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
// import 'package:ba3_business_solutions/controller/store_view_model.dart';
// import 'package:ba3_business_solutions/controller/product_view_model.dart';
// import 'package:ba3_business_solutions/controller/user_management_model.dart';
// import 'package:ba3_business_solutions/model/Pattern_model.dart';
// import 'package:ba3_business_solutions/model/bond_record_model.dart';
// import 'package:ba3_business_solutions/model/invoice_record_model.dart';
// import 'package:ba3_business_solutions/model/product_model.dart';
// import 'package:ba3_business_solutions/utils/generate_id.dart';
// import 'package:ba3_business_solutions/view/invoices/invoice_view.dart';
// import 'package:ba3_business_solutions/view/invoices/widget/all_invoice_data_sorce.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import '../model/global_model.dart';
// import '../model/product_record_model.dart';
// import '../utils/logger.dart';
// import '../view/invoices/widget/invoice_record_source.dart';
// import 'account_view_model.dart';
// import 'package:qr/qr.dart';
// class InvoiceViewModel extends GetxController {
//   final CollectionReference _invoicesCollectionRef = FirebaseFirestore.instance.collection(Const.invoicesCollection);
//   final CollectionReference _accountCollectionRef = FirebaseFirestore.instance.collection(Const.accountsCollection);
//   final CollectionReference _bondCollectionRef = FirebaseFirestore.instance.collection(Const.bondsCollection);
//
//   var accountController = Get.find<AccountViewModel>();
//   var bondController = Get.find<BondViewModel>();
//   var productController = Get.find<ProductViewModel>();
//   var patternController = Get.find<PatternViewModel>();
//   var storeViewController = Get.find<StoreViewModel>();
//   var sellerViewController = Get.find<SellersViewModel>();
//
//   List<String> _invIdList = [];
//
//   List<String> get invIdList => _invIdList;
//
//   List<String> _invCodeList = [];
//
//   List<String> get invCodeList => _invCodeList;
//
//   List<String> _patternList = [];
//
//   List<String> get patternList => _patternList;
//
//   List<PatternModel> _pattern = [];
//
//   List<PatternModel> get pattern => _pattern;
//
//   String _typeBill = "";
//
//   String get typeBill => _typeBill;
//   RxMap<String, GlobalModel> _invoiceModel = <String, GlobalModel>{}.obs;
//
//   RxMap<String, GlobalModel> get invoiceModel => _invoiceModel;
//
//   List<InvoiceRecordModel> _invoiceRecordModel = [];
//
//   List<InvoiceRecordModel> get invoiceRecordModel => _invoiceRecordModel;
//
//   ValueNotifier<bool> get loading => _loading;
//   ValueNotifier<bool> _loading = ValueNotifier(false);
//
//   Map<String, String> _accountList = {};
//
//   Map<String, String> get accountList => _accountList;
//
//   List<String> _accountPickList = [];
//
//   List<String> get accountPickList => _accountPickList;
//
//   List<String> _storePickList = [];
//
//   List<String> get storePickList => _storePickList;
//
//   TextEditingController _primaryAccountController = TextEditingController();
//
//   TextEditingController get primaryAccountController => _primaryAccountController;
//
//   TextEditingController _secondaryAccountController = TextEditingController();
//   TextEditingController sellerController = TextEditingController();
//   String? dateController;
//
//   TextEditingController get secondaryAccountController => _secondaryAccountController;
//
//   TextEditingController _invCodeController = TextEditingController();
//
//   TextEditingController get invCodeController => _invCodeController;
//
//   TextEditingController storeController = TextEditingController();
//   TextEditingController billIDController = TextEditingController();
//   TextEditingController noteController = TextEditingController();
//   TextEditingController bondIdController = TextEditingController();
//   TextEditingController mobileNumberController = TextEditingController();
//   final DataGridController dataGridController = DataGridController();
//   late GlobalModel initModel;
//
//   double _total = 0.0;
//
//   double get total => _total;
//
//   late List<InvoiceRecordModel> records;
//   late InvoiceRecordSource invoiceRecordSource;
//
//   late allInvoiceDataGridSource invoiceAllDataGridSource;
//
//   List<String> nextPrevList = [];
//
//   onCellTap(RowColumnIndex rowColumnIndex) {
//     if (rowColumnIndex.rowIndex + 1 == records.length) {
//       records.add(InvoiceRecordModel(prodChoosePriceMethod:Const.invoiceChoosePriceMethodeDefault));
//       invoiceRecordSource.buildDataGridRows(records, getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat);
//       invoiceRecordSource.updateDataGridSource();
//     }
//   }
//
//   changeSecAccount() {
//     //invoiceRecordSource.buildDataGridRows(records, getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat);
//     invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
//     invoiceRecordSource.updateDataGridSource();
//     print(invoiceRecordSource.accountVat);
//     update();
//   }
//
//   // searchUser(String user) {
//   //
//   //   accountController.allAccounts.forEach((key, value) {
//   //     for (int i = 0; i < value.length; i++) {
//   //       value[i].account = user;
//   //     }
//   //   });
//   // }
//
//   InvoiceViewModel() {
//     getAllInvoices();
//     initAllInvoice();
//   }
//
//   initAllInvoice() {
//     invoiceAllDataGridSource = allInvoiceDataGridSource(invoiceModel);
//     invoiceAllDataGridSource.updateDataGridSource();
//     update();
//   }
//
//   getAllInvoices() async {
//     _invoicesCollectionRef.snapshots().listen((value) {
//       _invoiceModel.clear();
//       for (int i = 0; i < value.docs.length; i++) {
//         value.docs[i].reference.collection("invRecord").snapshots().listen((value0) {
//           List<InvoiceRecordModel> _ = [];
//           for (var element in value0.docs) {
//             _.add(InvoiceRecordModel.fromJson(element.data()));
//           }
//           _invoiceModel[value.docs[i]['invId']] = GlobalModel.fromJson(value.docs[i].data() as Map<String, dynamic>);
//           _invoiceModel[value.docs[i]['invId']]?.invRecords = _;
//           invoiceAllDataGridSource.updateDataGridSource();
//           update();
//         });
//       }
//     });
//   }
//
//   computeTotal(List<InvoiceRecordModel> records) {
//     int quantity = 0;
//     double subtotals = 0.0;
//     _total = 0.0;
//     for (var record in records) {
//       if (record.invRecQuantity != null && record.invRecSubTotal != null) {
//         quantity = record.invRecQuantity!;
//         subtotals = record.invRecSubTotal!;
//         record.invRecTotal = quantity * (subtotals + record.invRecVat!);
//         _total += quantity * (subtotals + record.invRecVat!);
//         update();
//       }
//     }
//     print(_total);
//   }
//
//   double computeAllTotal() {
//     int quantity = 0;
//     double subtotals = 0.0;
//     _total = 0.0;
//     for (var record in records) {
//       if (record.invRecQuantity != null && record.invRecSubTotal != null) {
//         quantity = record.invRecQuantity!;
//         subtotals = record.invRecSubTotal!;
//         _total += quantity * (subtotals + record.invRecVat!);
//       }
//     }
//     return _total;
//   }
//
//   double computeVatTotal() {
//     int quantity = 0;
//     _total = 0.0;
//     for (var record in records) {
//       if (record.invRecQuantity != null && record.invRecSubTotal != null) {
//         quantity = record.invRecQuantity!;
//         _total += quantity * record.invRecVat!;
//       }
//     }
//     return _total;
//   }
//
//   double computeWithoutVatTotal() {
//     int quantity = 0;
//     double subtotals = 0.0;
//     _total = 0.0;
//     for (var record in records) {
//       if (record.invRecQuantity != null && record.invRecSubTotal != null) {
//         quantity = record.invRecQuantity!;
//         subtotals = record.invRecSubTotal!;
//         _total += quantity * (subtotals);
//       }
//     }
//     return _total;
//   }
//
//   List<InvoiceRecordModel> getInvoiceRecords(String billId) {
//     List<InvoiceRecordModel> rec = [];
//     List<InvoiceRecordModel> rawData = invoiceModel[billId]!.invRecords!;
//     List<Map<String, dynamic>> data = [];
//     for (var item in rawData) {
//       data.add(item.toJson());
//     }
//     for (var item in data) {
//       if (item["invRecId"] != null) {
//         String prodName = productController.productDataMap[item["invRecProduct"]]!.prodName!;
//         rec.add(InvoiceRecordModel(
//           invRecQuantity: item["invRecQuantity"],
//           invRecProduct: prodName,
//           invRecId: item["invRecId"],
//           invRecSubTotal: item["invRecSubTotal"],
//           invRecTotal: item["invRecTotal"],
//           invRecVat: item["invRecVat"],
//         ));
//       }
//     }
//     return rec;
//   }
//
//   addInvoice(GlobalModel invoiceModel, List<InvoiceRecordModel> record) async {
//     await _invoicesCollectionRef.doc(invoiceModel.invId).set(invoiceModel.toJson());
//     int i = 0;
//     do {
//       if (record[i].invRecId != null) {
//         await _invoicesCollectionRef.doc(invoiceModel.invId).collection("invRecord").doc(record[i].invRecId).set({
//           'invRecId': record[i].invRecId,
//           'invRecProduct': record[i].invRecProduct,
//           'invRecQuantity': record[i].invRecQuantity,
//           'invRecSubTotal': record[i].invRecSubTotal,
//           'invRecTotal': invoiceModel.invTotal,
//           'invRecVat': record[i].invRecVat,
//         });
//       }
//       i++;
//     } while (i < record.length);
//   }
//
//
//     addBills(GlobalModel invoiceModel, List<InvoiceRecordModel> record, isEdit, {bool withLogger = false}) async {
//
//     print("Start ADD${invoiceModel.invId}");
//     if (!invoiceModel.invPrimaryAccount!.contains("acc")) invoiceModel.invPrimaryAccount = getAccountIdFromText(invoiceModel.invPrimaryAccount);
//     if (!invoiceModel.invSecondaryAccount!.contains("acc")) invoiceModel.invSecondaryAccount = getAccountIdFromText(invoiceModel.invSecondaryAccount);
//     if (!invoiceModel.invSeller!.contains("seller")) invoiceModel.invSeller = getSellerIdFromText(invoiceModel.invSeller);
//     if (!invoiceModel.invStorehouse!.contains("store")) invoiceModel.invStorehouse = getStoreIdFromText(invoiceModel.invStorehouse);
//     for (var element in record) {
//       if (!(element.invRecProduct?.contains("prod") ?? true)) record[record.indexOf(element)].invRecProduct = productController.searchProductIdByName(element.invRecProduct);
//     }
//     if (!invCodeList.contains(invoiceModel.invCode)) {
//       bondController.tempBondModel = GlobalModel();
//       bondController.bondModel = GlobalModel();
//       bondController.tempBondModel.bondRecord = [];
//       bondController.tempBondModel.originId = invoiceModel.invId;
//       bondController.tempBondModel.bondTotal = "0.00";
//       bondController.tempBondModel.bondType = Const.bondTypeDaily;
//       bondController.tempBondModel.bondId = invoiceModel.originId;
//       if (!isEdit) {
//         String bondId = generateId(RecordType.bond);
//         bondController.tempBondModel.bondId = bondId;
//         invoiceModel.originId = bondId;
//         var bondCode = (int.parse(bondController.allBondsItem.values.lastOrNull?.bondCode ?? "0") + 1).toString();
//         while (bondController.allBondsItem.values.toList().map((e) => e.bondCode).toList().contains(bondCode)) {
//           bondCode = (int.parse(bondCode) + 1).toString();
//         }
//         invoiceModel.bondCode = bondCode;
//       }
//       bondController.tempBondModel.bondCode = invoiceModel.bondCode;
//       // productController.saveInvInProduct(record, invoiceModel.invId, invoiceModel.invType);
//       storeViewController.saveInvInStore(record, invoiceModel.invId, invoiceModel.invType,invoiceModel.invStorehouse);
//       bool isHasVat = patternController.patternModel[invoiceModel.patternId]!.patHasVat!;
//       switch (invoiceModel.invType) {
//         case Const.invoiceTypeSales:
//           {
//             await addInvoiceRecordToAccount(-1 * invoiceModel.invTotal!, invoiceModel.invPrimaryAccount!, invoiceModel.originId!);
//             await addInvoiceRecordToAccount(invoiceModel.invTotal!, invoiceModel.invSecondaryAccount!, invoiceModel.originId!);
//             await addInvoice(invoiceModel, record);
//             sellerViewController.postRecord(userId: invoiceModel.invSeller!, invId: invoiceModel.invId, amount: invoiceModel.invTotal!, date: dateController);
//             productController.saveInvInProduct(record, invoiceModel.invId, invoiceModel.invType,invoiceModel.invDate);
//             print("end ADD${invoiceModel.invId}");
//             if (isHasVat && computeVatTotal().toStringAsFixed(2) != "0.00") {
//               bondController.tempBondModel.bondRecord!.add(BondRecordModel("02", computeVatTotal(), 0, patternController.patternModel[invoiceModel.patternId]!.patVatAccount, "ضريبة القيمة المضافة", invId: invoiceModel.originId!));
//               bondController.tempBondModel.bondRecord!.add(BondRecordModel("03", 0, computeVatTotal(), invoiceModel.invSecondaryAccount, "ضريبة القيمة المضافة", invId: invoiceModel.originId!));
//             }
//           }
//           break;
//         case Const.invoiceTypeBuy:
//           {
//             await addInvoiceRecordToAccount(invoiceModel.invTotal!, invoiceModel.invPrimaryAccount!, invoiceModel.invId!);
//             await addInvoiceRecordToAccount(-1 * invoiceModel.invTotal!, invoiceModel.invSecondaryAccount!, invoiceModel.invId!);
//             await addInvoice(invoiceModel, record);
//             productController.saveInvInProduct(record, invoiceModel.invId, invoiceModel.invType,invoiceModel.invDate);
//             if (isHasVat && computeVatTotal().toStringAsFixed(2) != "0.00") {
//               bondController.tempBondModel.bondRecord!.add(BondRecordModel("02", 0, computeVatTotal(), patternController.patternModel[invoiceModel.patternId]!.patVatAccount, "ضريبة القيمة المضافة", invId: invoiceModel.originId!));
//               bondController.tempBondModel.bondRecord!.add(BondRecordModel("03", computeVatTotal(), 0, invoiceModel.invSecondaryAccount, "ضريبة القيمة المضافة", invId: invoiceModel.originId!));
//             }
//           }
//           break;
//         // case "due sales":
//         //   {
//         //     await addInvoiceRecordToAccount(-1 * invoiceModel.invTotal!, invoiceModel.invPrimaryAccount!, invoiceModel.originId!);
//         //     await addInvoiceRecordToAccount(invoiceModel.invTotal!, invoiceModel.invSecondaryAccount!, invoiceModel.originId!);
//         //     await addInvoice(invoiceModel, record);
//         //     productController.saveInvInProduct(record, invoiceModel.invId, invoiceModel.invType);
//         //     print("end ADD${invoiceModel.invId}");
//         //   }
//         //   break;
//       }
//
//       if (withLogger) {
//         logger(newData: invoiceModel);
//       }
//
//       invoiceAllDataGridSource.updateDataGridSource();
//       bondController.postOneBond(false);
//       print(invoiceModel.invId!);
//       buildInvInit(true, invoiceModel.invId!);
//      // showEInvoiceDialog(mobileNumber: invoiceModel.invMobileNumber!, invId: invoiceModel.invId!);
//       update();
//       print("end ADD${invoiceModel.invId}");
//     } else {
//       Get.snackbar("رقم الفاتورة موجود يا عكروت", "اختار غير رقم يا مطيح");
//     }
//   }
//
//   addInvoiceRecordToAccount(double amount, String account, String billId,) async {
//     print("Start addInvoiceRecordToAccount  account: $account  billId: $billId total: $total");
//     if (amount < 0) {
//       bondController.tempBondModel.bondRecord!.add(BondRecordModel("00", computeWithoutVatTotal(), 0, account, "تم توليده من الفاتورة", invId: billId));
//     } else {
//       bondController.tempBondModel.bondRecord!.add(BondRecordModel("01", 0, computeWithoutVatTotal(), account, "تم توليده من الفاتورة", invId: billId));
//     }
//     print("End addInvoiceRecordToAccount  account: $account  billId: $billId total: $total");
//   }
//
//   updateInvoice(GlobalModel initalModle, GlobalModel invoiceModel, List<InvoiceRecordModel> record, String bondId, {bool withLogger = false}) async {
//     print("start update");
//     record.forEach((element) {
//       if (!(element.invRecProduct?.contains("prod") ?? true)) record[record.indexOf(element)].invRecProduct = productController.searchProductIdByName(element.invRecProduct);
//     });
//     if (invoiceModel.invCode != initalModle.invCode) {
//       if (!invCodeList.contains(invoiceModel.invCode)) {
//         await deleteBills(initalModle);
//         invoiceModel.originId = initalModle.originId;
//         invoiceModel.bondCode = initalModle.bondCode;
//         invoiceModel.invId = initalModle.invId;
//         invoiceModel.invCode = initalModle.invCode;
//         invoiceModel.invRecords = record;
//         if (withLogger) {
//           logger(newData: invoiceModel, oldData: initalModle);
//         }
//         await addBills(invoiceModel, record, true);
//       } else {
//         Get.snackbar("رقم الفاتورة موجود يا عكروت", "اختار غير رقم يا مطيح");
//       }
//     } else {
//       await deleteBills(initalModle);
//       invoiceModel.originId = initalModle.originId;
//       invoiceModel.bondCode = initalModle.bondCode;
//       invoiceModel.invId = initalModle.invId;
//       invoiceModel.invCode = initalModle.invCode;
//       invoiceModel.invRecords = record;
//       invCodeList.clear();
//       if (withLogger) {
//         logger(newData: invoiceModel, oldData: initalModle);
//       }
//       await addBills(invoiceModel, record, true);
//     }
//     getInvCode();
//     update();
//   }
//
//   deleteBills(GlobalModel invoiceModel, {bool withLogger = false}) async {
//     print("Start Delete Invoice  deleteBills(GlobalModel ${invoiceModel.toJson()} ");
//     invoiceModel.invRecords?.forEach((element) {
//       if (!(element.invRecProduct?.contains("prod") ?? true)) invoiceModel.invRecords?[invoiceModel.invRecords!.indexOf(element)].invRecProduct = productController.searchProductIdByName(element.invRecProduct);
//     });
//     if (withLogger) {
//       logger(newData: invoiceModel);
//     }
//     productController.deleteInvFromProduct(invoiceModel.invRecords ?? [], invoiceModel.invId!);
//     sellerViewController.deleteRecord(userId: invoiceModel.invSeller!, invId: invoiceModel.invId);
//     storeViewController.deleteRecord(storeId: invoiceModel.invStorehouse!, invId: invoiceModel.invId);
//     await deleteInvoice(invoiceModel.invId!, invoiceModel.originId!);
//     await removeBondFromAccount(invoiceModel.invPrimaryAccount!, invoiceModel.originId!);
//     await removeBondFromAccount(invoiceModel.invSecondaryAccount!, invoiceModel.originId!);
//     invoiceAllDataGridSource.updateDataGridSource();
//     update();
//     print("End Delete Invoice  deleteBills(GlobalModel ${invoiceModel.toJson()} ");
//   }
//
//   deleteInvoice(String billId, String bondId) async {
//     await _invoicesCollectionRef.doc(billId).collection('invRecord').get().then((docSnapshot) async {
//       for (QueryDocumentSnapshot docSnapshot in docSnapshot.docs) {
//         await docSnapshot.reference.delete();
//       }
//     });
//     await _bondCollectionRef.doc(bondId).collection(Const.recordCollection).get().then((docSnapshot) async {
//       for (QueryDocumentSnapshot docSnapshot in docSnapshot.docs) {
//         await docSnapshot.reference.delete();
//       }
//     });
//     await _invoicesCollectionRef.doc(billId).delete();
//     await _bondCollectionRef.doc(bondId).delete();
//
//     update();
//     print("End delete");
//   }
//
//   removeBondFromAccount(String account, String bondId) async {
//     print("Start Delete Invoice From Account  removeInvoiceFromAccount(String $account, String $bondId)");
//     _accountPickList.clear();
//     accountController.accountList.forEach((key, value) {
//       if (account.toLowerCase() == value.accId!.toLowerCase() || account.toLowerCase() == value.accName!.toLowerCase()) {
//         _accountCollectionRef.doc(key).collection(Const.recordCollection).doc(bondId).delete();
//       }
//     });
//
//     print("End Delete Invoice From Account  removeInvoiceFromAccount(String $account, String $bondId)");
//     // });
//   }
//
//   String checkInvCode() {
//     var invCode = (int.parse(_invoiceModel.values.lastOrNull?.invCode ?? "0") + 1).toString();
//     while (_invoiceModel.values.toList().map((e) => e.invCode).toList().contains(invCode)) {
//       invCode = (int.parse(invCode) + 1).toString();
//     }
//     return invCode;
//   }
//
//   buildSource(String billId) {
//     records = getInvoiceRecords(billId) + [InvoiceRecordModel(prodChoosePriceMethod:Const.invoiceChoosePriceMethodeDefault)];
//     invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
//   }
//
//   prevInv(String patId, invCode) {
//     var inv = invoiceModel.values.where((element) => element.invCode == invCode).firstOrNull;
//     if (inv == null) {
//       if (nextPrevList.isNotEmpty) {
//         buildInvInit(true, nextPrevList.last);
//       }
//     } else {
//       var index = nextPrevList.indexOf(inv.invId!);
//       if (nextPrevList.first == nextPrevList[index]) {
//       } else {
//         buildInvInit(true, nextPrevList[index - 1]);
//       }
//     }
//     update();
//   }
//
//   nextInv(String patId, invCode) {
//     var inv = invoiceModel.values.toList().firstWhereOrNull((element) => element.invCode == invCode);
//     if (inv == null) {
//     } else {
//       var index = nextPrevList.indexOf(inv.invId!);
//       if (nextPrevList.last == nextPrevList[index]) {
//         getInit(patId);
//       } else {
//         buildInvInit(true, nextPrevList[index + 1]);
//       }
//       update();
//     }
//   }
//
//   //init new inv
//   getInit(String patternId) {
//     initModel = GlobalModel();
//     initModel.patternId = patternId;
//     invCodeController.text = checkInvCode();
//     primaryAccountController.text = getAccountNameFromId(patternController.patternModel[patternId]!.patPrimary!);
//     secondaryAccountController.text = getAccountNameFromId(patternController.patternModel[patternId]!.patSecondary!);
//     storeController.text = getStoreNameFromId(patternController.patternModel[patternId]!.patStore!);
//     var vat = accountController.accountList[patternController.patternModel[patternId]!.patSecondary!]!.accVat;
//     bondIdController.clear();
//     noteController.clear();
//     billIDController.clear();
//     mobileNumberController.clear();
//     if(getMyUserSellerId()!=null){
//       print(getMyUserSellerId());
//       print(getMyUserSellerId());
//       sellerController.text=getSellerNameFromId(getMyUserSellerId());
//     }
//     dateController=DateTime.now().toString().split(" ")[0];
//     records = [InvoiceRecordModel(prodChoosePriceMethod:Const.invoiceChoosePriceMethodeDefault)];
//     invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: vat!);
//     nextPrevList.assignAll(invoiceModel.values.where((element) => element.patternId == patternId).map((e) => e.invId!));
//     print(nextPrevList);
//   }
//
//   //int old inv
//   buildInvInit(bool bool, String invId) {
//     if (bool) {
//       initModel = invoiceModel[invId]!;
//     }
//     primaryAccountController.text = getAccountNameFromId(patternController.patternModel[initModel.patternId]!.patPrimary!);
//     _typeBill = patternController.patternModel[initModel.patternId]!.patType!;
//     secondaryAccountController.text = getAccountNameFromId(initModel.invSecondaryAccount!);
//     sellerController.text = getSellerNameFromId(initModel.invSeller);
//     storeController.text = getStoreNameFromId(initModel.invStorehouse);
//     billIDController.text = initModel.invId!;
//     mobileNumberController.text = initModel.invMobileNumber??"";
//     noteController.text = initModel.invComment!;
//     bondIdController.text = initModel.originId!;
//     invCodeController.text = initModel.invCode!;
//     dateController=initModel.invDate;
//     // dateController = initModel.invDate!;
//     nextPrevList.assignAll(invoiceModel.values.where((element) => element.patternId == initModel.patternId).map((e) => e.invId!));
//     print(nextPrevList);
//     buildSource(initModel.invId!);
//     if (!bool) {
//       update();
//     }
//   }
//
//   bool checkAllRecord() {
//     for (var element in records) {
//       return (element.invRecProduct == "" || element.invRecProduct == null || element.invRecQuantity == 0 || element.invRecQuantity == null);
//     }
//     return false;
//   }
//
//   getAccountComplete() async {
//     _accountPickList = [];
//     accountController.accountList.forEach((key, value) {
//       _accountPickList.addIf(value.accType==Const.accountTypeDefault &&( value.accCode!.toLowerCase().contains(_secondaryAccountController.text.toLowerCase()) || value.accName!.toLowerCase().contains(_secondaryAccountController.text.toLowerCase())), value.accName!);
//     });
//     print(_accountPickList.length);
//     if (_accountPickList.length > 1) {
//       await Get.defaultDialog(
//         title: "اختر احد الحسابات",
//         content: SizedBox(
//           width: 500,
//           height: 500,
//           child: ListView.builder(
//             itemCount: _accountPickList.length,
//             itemBuilder: (context, index) {
//               return InkWell(
//                 onTap: () {
//                   _secondaryAccountController.text = _accountPickList[index];
//                   update();
//                   Get.back();
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(5),
//                   margin: const EdgeInsets.all(8),
//                   width: 500,
//                   child: Center(
//                     child: Text(
//                       _accountPickList[index],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       );
//     } else if (_accountPickList.length == 1) {
//       _secondaryAccountController.text = _accountPickList[0];
//     } else {
//       Get.snackbar("فحص المطاييح", "هذا المطيح غير موجود من قبل");
//     }
//   }
//
//   getStoreComplete() async {
//     _storePickList = [];
//     // var userInput = storeController.text;
//     // storeController.clear();
//     storeViewController.storeMap.forEach((key, value) {
//       _storePickList.addIf(value.stCode!.toLowerCase().contains(storeController.text.toLowerCase()) || value.stName!.toLowerCase().contains(storeController.text.toLowerCase()), value.stName!);
//     });
//     if (_storePickList.length > 1) {
//       await Get.defaultDialog(
//         title: "اختر احد المستودعات",
//         content: SizedBox(
//           width: 500,
//           height: 500,
//           child: ListView.builder(
//             itemCount: _storePickList.length,
//             itemBuilder: (context, index) {
//               return InkWell(
//                 onTap: () {
//                   storeController.text = _storePickList[index];
//                   Get.back();
//                   update();
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(5),
//                   margin: const EdgeInsets.all(8),
//                   width: 500,
//                   child: Center(
//                     child: Text(
//                       _storePickList[index],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       );
//     } else if (_storePickList.length == 1) {
//       storeController.text = _storePickList[0];
//     } else {
//       storeController.clear();
//       Get.snackbar("فحص المطاييح", "هذا المطيح غير موجود من قبل");
//     }
//   }
//
//   bool checkAccountComplete() {
//     return accountController.accountList.values.map((e) => e.accName?.toLowerCase()).toList().contains(secondaryAccountController.text.toLowerCase());
//   }
//
//   bool checkStoreComplete() {
//     return storeViewController.storeMap.values.map((e) => e.stName?.toLowerCase()).toList().contains(storeController.text.toLowerCase());
//   }
//
//   bool checkSellerComplete() {
//     return sellerViewController.allSellers.values.map((e) => e.sellerName?.toLowerCase()).toList().contains(sellerController.text.toLowerCase());
//   }
//
//   getInvCode() {
//     _invIdList = [];
//     _invCodeList = [];
//     invoiceModel.forEach((key, value) {
//       _invIdList.add(value.invId!);
//       _invCodeList.add(value.invCode!);
//       _patternList.add(value.patternId!);
//     });
//     print("0----------------------------${_invCodeList.toList()}");
//   }
//
//   // viewPattern() {
//   //   _pattern.clear();
//   //   patternController.patternModel.forEach((key, value) {
//   //     _pattern.add(value);
//   //   });
//   //   Get.defaultDialog(
//   //     title: "Chose form dialog",
//   //     content: SizedBox(
//   //       width: 500,
//   //       height: 500,
//   //       child: ListView.builder(
//   //         itemCount: _pattern.length,
//   //         itemBuilder: (context, index) {
//   //           return InkWell(
//   //             onTap: () {
//   //               Get.back();
//   //               Get.to(()=>InvoiceView(billId: '1', patternId: _pattern[index].patId!));
//   //             },
//   //             child: Container(
//   //               padding: const EdgeInsets.all(5),
//   //               margin: const EdgeInsets.all(8),
//   //               width: 500,
//   //               child: Center(
//   //                 child: Text(
//   //                   _pattern[index].patName.toString(),
//   //                 ),
//   //               ),
//   //             ),
//   //           );
//   //         },
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   void addProductToInvoice(List<ProductModel> result) {
//     double vat = getVatFromName(getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
//     List<InvoiceRecordModel>  newRecord=[];
//     bool isPatternHasVat = patternController.patternModel[initModel.patternId]!.patHasVat!;
//
//     for(var i =0;i<result.length;i++){
//      var _= InvoiceRecordSource(records: [], accountVat: '');
//      var price =(_.getPrice(Const.invoiceChoosePriceMethodeDefault, result[i].prodId));
//      newRecord.insert(i, InvoiceRecordModel(prodChoosePriceMethod: Const.invoiceChoosePriceMethodeDefault));
//      newRecord[i].invRecProduct = result[i].prodName!.toString();
//      newRecord[i].invRecId = (i + 1).toString();
//      newRecord[i].prodChoosePriceMethod = Const.invoiceChoosePriceMethodeDefault;
//      newRecord[i].invRecSubTotal = price / (result[i].prodHasVat! ? (vat + 1) : 1);
//      newRecord[i].invRecVat = !isPatternHasVat
//          ? 0
//          : (result[i].prodHasVat ?? false)
//         ? (price - (price / (vat + 1)))
//          : 0;
//      newRecord[i].invRecQuantity = 1;
//    }
//
//  // onCellTap(rowColumnIndex);
//     records.removeWhere((element) => element.invRecProduct==null);
//   records = records+ newRecord + [InvoiceRecordModel(prodChoosePriceMethod: Const.invoiceChoosePriceMethodeDefault)];
//   for(var i=0;i<records.length-1;i++){
//     records[i].invRecId=(i+1).toString();
//   }
//   invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
//   update();
//   }
//
//
//   void deleteOneRecord(int index) {
//     records.removeAt(index);
//     for(var i=0;i<records.length-1;i++){
//       records[i].invRecId=(i+1).toString();
//     }
//     invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
//     update();
//   }
//
// }
//
// void showEInvoiceDialog({required String mobileNumber,required String invId}) {
//   Get.defaultDialog(
//     title: "فاتورتك الرقمية",
//     content:SizedBox(
//       height: 460,
//       width: 460,
//       child: Column(
//         children: [
//           QrImageView(
//             data: 'https://ba3-business-solutions.firebaseapp.com/?id='+invId,
//             version: QrVersions.auto,
//             size: 300.0,
//           ),
//           SizedBox(height: 20,),
//           Text("مشاركة عبر",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
//           SizedBox(height: 20,),
//           Row(
//             children: [
//               InkWell(
//                   onTap: (){
//                     Clipboard.setData(ClipboardData(text: 'https://ba3-business-solutions.firebaseapp.com/?id='+invId));
//                   },
//                   child: CircleAvatar(radius: 40,child: Icon(Icons.copy,color: Colors.grey.shade300,),backgroundColor: Colors.grey,)),
//               SizedBox(width: 20,),
//               CircleAvatar(radius: 40,child: Icon(Icons.chat_bubble),),
//             ],
//           )
//         ],
//       ),
//     ),
//     actions: [
//       ElevatedButton(onPressed: (){
//         Get.back();
//       }, child: Text("موافق"))
//     ]
//   );
// }
