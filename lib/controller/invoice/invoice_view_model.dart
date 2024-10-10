import 'package:ba3_business_solutions/controller/bond/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/invoice/Invoice_Pluto_Edit_View_Model.dart';
import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store/store_view_model.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/utils/hive.dart';
import 'package:ba3_business_solutions/model/invoice/invoice_discount_record_model.dart';
import 'package:ba3_business_solutions/model/invoice/invoice_record_model.dart';
import 'package:ba3_business_solutions/model/patterens/Pattern_model.dart';
import 'package:ba3_business_solutions/view/invoices/widget/all_invoice_data_sorce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../core/helper/functions/functions.dart';
import '../../core/shared/dialogs/CustomerDialog.dart';
import '../../model/account/account_customer.dart';
import '../../model/global/global_model.dart';
import '../../view/invoices/pages/New_Invoice_View.dart';
import '../../view/invoices/widget/custom_TextField.dart';
import '../account/account_view_model.dart';
import 'Screen_View_Model.dart';

class InvoiceViewModel extends GetxController {
  var accountController = Get.find<AccountViewModel>();
  var bondController = Get.find<BondViewModel>();
  var productController = Get.find<ProductViewModel>();
  var patternController = Get.find<PatternViewModel>();
  var storeViewController = Get.find<StoreViewModel>();
  var sellerViewController = Get.find<SellersViewModel>();
  var startDateController = TextEditingController()
    ..text = DateTime.now().toString().split(" ")[0];
  var endDateController = TextEditingController()
    ..text = DateTime.now().toString().split(" ")[0];

  GlobalModel? invoiceForSearch;

  List<String> invIdList = [];

  List<String> invCodeList = [];

  List<String> patternList = [];

  // String typeBill = "";

  RxMap<String, GlobalModel> invoiceModel = <String, GlobalModel>{}.obs;

  List<InvoiceRecordModel> invoiceRecordModel = [];

  List<String> accountPickList = [];

  List<String> storePickList = [];

  String? dateController;
  String? invDueDateController;
  TextEditingController primaryAccountController = TextEditingController();
  TextEditingController secondaryAccountController = TextEditingController();
  TextEditingController invCustomerAccountController = TextEditingController();
  TextEditingController sellerController = TextEditingController();
  TextEditingController invCodeController = TextEditingController();
  TextEditingController storeController = TextEditingController();
  TextEditingController storeNewController = TextEditingController();
  TextEditingController billIDController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController invPartnerCodeController = TextEditingController();
  TextEditingController entryBondIdController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController firstPayController = TextEditingController();
  TextEditingController invReturnCodeController = TextEditingController();
  TextEditingController invReturnDateController = TextEditingController();
  TextEditingController totalPaidFromPartner = TextEditingController();

  // TextEditingController invDueDateController = TextEditingController();
  final DataGridController dataGridController = DataGridController();
  late GlobalModel initModel;
  int colorInvoice = Colors.grey.value;

  double total = 0.0;

  late List<InvoiceRecordModel> records;
  late List<InvoiceDiscountRecordModel> discountRecords;

  // late InvoiceRecordSource invoiceRecordSource;
  // late InvoiceDiscountRecordSource invoiceDiscountRecordSource;

  late allInvoiceDataGridSource invoiceAllDataGridSource;

  Map<String, String> nextPrevList = {};

  List<GlobalModel> allInvoiceForPluto = [];

  changeCustomer() async {
    InvoicePlutoViewModel plutoInvController =
        Get.find<InvoicePlutoViewModel>();
    AccountCustomer customer = AccountCustomer();
    PatternModel patternModel =
        patternController.patternModel[initModel.patternId]!;
    if (patternModel.patType != AppConstants.invoiceTypeBuy) {
      if (getIfAccountHaveCustomers(secondaryAccountController.text)) {
        customer = await accountCustomerDialog(
            customers: getAccountCustomers(secondaryAccountController.text),
            text: invCustomerAccountController.text);
        invCustomerAccountController.text = customer.customerAccountName!;
      } else {
        customer = await accountCustomerDialog(
            text: invCustomerAccountController.text);
        invCustomerAccountController.text = customer.customerAccountName!;
        secondaryAccountController.text =
            getAccountNameFromId(customer.mainAccount);
      }
    } else {
      if (getIfAccountHaveCustomers(primaryAccountController.text)) {
        customer = await accountCustomerDialog(
            customers: getAccountCustomers(primaryAccountController.text),
            text: invCustomerAccountController.text);
        invCustomerAccountController.text = customer.customerAccountName!;
      } else {
        customer = await accountCustomerDialog(
            text: invCustomerAccountController.text);
        invCustomerAccountController.text = customer.customerAccountName!;
        primaryAccountController.text =
            getAccountNameFromId(customer.mainAccount);
      }
    }
    plutoInvController.customerName = customer.customerAccountName!;

    plutoInvController.changeVat();
    update();
    // invoiceController.invCustomerAccountController.text = await getAccountComplete(invoiceController.invCustomerAccountController.text);
  }

  searchInvoice(String invPartnerId) {
    invoiceForSearch = invoiceModel.values
        .where(
          (element) => element.invPartnerCode == invPartnerId,
        )
        .firstOrNull;
  }

/*  /// we don't need this
  getDataForPluto() async {
    // IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
    isolateViewModel.init();
    print("from invoice View");
    final a = await compute<({List<GlobalModel> invoiceModel, IsolateViewModel isolateViewModel}), List<GlobalModel>>((message) {
      Get.put(message.isolateViewModel);
      return message.invoiceModel;
    }, (invoiceModel: invoiceModel.values.toList(), isolateViewModel: isolateViewModel));
    allInvoiceForPluto = a;
    // Get.find<PlutoViewModel>().  update();
    update();
    // return a;
  }*/

/*
  onCellTap(RowColumnIndex rowColumnIndex) {
    if (rowColumnIndex.rowIndex + 1 == records.length) {
      records.add(InvoiceRecordModel(prodChoosePriceMethod: Const.invoiceChoosePriceMethodeDefault));
      invoiceRecordSource.buildDataGridRows(records, getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat);
      invoiceRecordSource.updateDataGridSource();
    }
  }
*/

/*  onDiscountCellTap(RowColumnIndex rowColumnIndex) {
    if (rowColumnIndex.rowIndex + 1 == discountRecords.length) {
      discountRecords.add(InvoiceDiscountRecordModel());
      invoiceDiscountRecordSource.buildDataGridRows(discountRecords);
      invoiceDiscountRecordSource.updateDataGridSource();
    }
  }*/

/*
  changeSecAccount() {
    //invoiceRecordSource.buildDataGridRows(records, getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat);
    invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
    invoiceRecordSource.updateDataGridSource();
    update();
  }
*/

  initAllInvoice() {
    invoiceAllDataGridSource = allInvoiceDataGridSource(invoiceModel);
    invoiceAllDataGridSource.updateDataGridSource();
    update();
  }

  // getAllInvoices() async {
  // _invoicesCollectionRef.snapshots().listen((value) {
  //   _invoiceModel.clear();
  //   for (int i = 0; i < value.docs.length; i++) {
  //     value.docs[i].reference.collection("invRecord").snapshots().listen((value0) {
  //       List<InvoiceRecordModel> _ = [];
  //       for (var element in value0.docs) {
  //         _.add(InvoiceRecordModel.fromJson(element.data()));
  //       }
  //       _invoiceModel[value.docs[i]['invId']] = GlobalModel.fromJson(value.docs[i].data() as Map<String, dynamic>);
  //       _invoiceModel[value.docs[i]['invId']]?.invRecords = _;
  //       invoiceAllDataGridSource.updateDataGridSource();
  //       update();
  //     });
  //   }
  // });
  // }

  initGlobalInvoice(GlobalModel globalModel) {
    invoiceModel[globalModel.invId!] = globalModel;
    update();
  }

  deleteGlobalInvoice(GlobalModel globalModel) {
    invoiceModel.removeWhere((key, value) => key == globalModel.invId);
    initAllInvoice();
  }

  computeTotal(List<InvoiceRecordModel> records) {
    int quantity = 0;
    double subtotals = 0.0;
    total = 0.0;
    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        subtotals = record.invRecSubTotal!;
        record.invRecTotal = quantity * (subtotals + record.invRecVat!);
        total += quantity * (subtotals + record.invRecVat!);
        update();
      }
    }
  }

  double computeAllTotal() {
    int quantity = 0;
    double subtotals = 0.0;
    total = 0.0;
    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        subtotals = record.invRecSubTotal!;
        total += quantity * (subtotals + record.invRecVat!);
      }
    }
    for (var record in discountRecords) {
      if ((record.discountPercentage ?? 0) > 0) {
        total -= total * (record.discountPercentage ?? 0);
      }
      if ((record.addedPercentage ?? 0) > 0) {
        total += total * (record.addedPercentage ?? 0);
      }
    }
    return total;
  }

  double computeVatTotal() {
    int quantity = 0;
    total = 0.0;
    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        total += quantity * record.invRecVat!;
      }
    }
    for (var record in discountRecords) {
      if ((record.discountPercentage ?? 0) > 0) {
        total -= total * (record.discountPercentage ?? 0);
      }
      if ((record.addedPercentage ?? 0) > 0) {
        total += total * (record.addedPercentage ?? 0);
      }
    }

    return total;
  }

  double calculateTotalDiscount(List<double?> totalDiscount) {
    return totalDiscount.fold(0.0, (sum, item) => sum + (item ?? 0.0));
  }

  double computeWithoutVatTotal() {
    int quantity = 0;
    double subtotals = 0.0;
    total = 0.0;

    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        subtotals = record.invRecSubTotal!;
        total += quantity * (subtotals);
      }
    }
    for (var record in discountRecords) {
      if ((record.discountPercentage ?? 0) > 0) {
        total -= record.discountTotal ?? 0;
      }
      if ((record.addedPercentage ?? 0) > 0) {
        total += record.addedTotal ?? 0;
      }
    }

    return total;
  }

  bool checkInvCode() {
    return nextPrevList.keys.toList().contains(invCodeController.text);
  }

/*  buildSource(String billId) {
    records = invoiceModel[billId]!.invRecords! + [InvoiceRecordModel(prodChoosePriceMethod: Const.invoiceChoosePriceMethodeDefault)];
    invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: secondaryAccountController.text == "" ? "a" : getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
  }*/

/*  buildSourceRecent(GlobalModel model) {
    records = model.invRecords! + [InvoiceRecordModel(prodChoosePriceMethod: Const.invoiceChoosePriceMethodeDefault)];
    invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: secondaryAccountController.text == "" ? "a" : getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
  }*/

/*
  buildDiscountSource(String billId) {
    discountRecords = invoiceModel[billId]!.invDiscountRecord! + [InvoiceDiscountRecordModel()];
    invoiceDiscountRecordSource = InvoiceDiscountRecordSource(records: discountRecords);
  }
*/

/*  buildDiscountSourceRecent(GlobalModel model) {
    discountRecords = model.invDiscountRecord! + [InvoiceDiscountRecordModel()];
    invoiceDiscountRecordSource = InvoiceDiscountRecordSource(records: discountRecords);
  }*/

/*  rebuildDiscount() {
    double totalWithoutVat = computeWithoutVatTotal();
    for (InvoiceDiscountRecordModel model in discountRecords) {
      if (model.discountId != null) {
        if ((model.discountTotal ?? 0) > 0) {
          if (model.isChooseDiscountTotal == true) {
            model.discountPercentage = model.discountTotal! / totalWithoutVat;
          } else if (model.isChooseDiscountTotal == false) {
            model.discountTotal = totalWithoutVat * model.discountPercentage! / 100;
          }
        } else if ((model.addedTotal ?? 0) > 0) {
          if (model.isChooseAddedTotal == true) {
            model.addedPercentage = model.addedTotal! / totalWithoutVat;
          } else if (model.isChooseAddedTotal == false) {
            model.addedTotal = totalWithoutVat * model.addedPercentage! / 100;
          }
        }
      }
    }
    invoiceDiscountRecordSource = InvoiceDiscountRecordSource(records: discountRecords);
    update();
  }*/

  invNextOrPrev(String patId, invCode, bool isPrev) {
    List<GlobalModel> inv = invoiceModel.values
        .where((element) => element.patternId == patId)
        .toList()
        .reversed
        .toList();
    if ((!HiveDataBase.getWithFree()) &&
        patternController.patternModel[patId]?.patType ==
            AppConstants.invoiceTypeBuy) {
      inv = invoiceModel.values
          .where((element) =>
              element.patternId == patId &&
              element.invRecords!.where(
                (element) {
                  return productController
                          .productDataMap[element.invRecProduct]?.prodIsLocal ==
                      false;
                },
              ).isEmpty)
          .toList()
          .reversed
          .toList();
    }
    inv.sort(
      (a, b) {
        if (a.invCode!.startsWith("F") && b.invCode!.startsWith("F")) {
          return int.parse((a.invCode ?? "F-0").split("F-")[1])
              .compareTo(int.parse((b.invCode ?? "F-0").split("F-")[1]));
        } else if (a.invCode!.startsWith("F")) {
          return int.parse((a.invCode ?? "F-0").split("F-")[1])
              .compareTo(int.parse(b.invCode ?? "0"));
        } else if (b.invCode!.startsWith("F")) {
          return int.parse((a.invCode ?? "0"))
              .compareTo(int.parse((b.invCode ?? "F-0").split("F-")[1]));
        } else {
          return int.parse(a.invCode ?? "0")
              .compareTo(int.parse(b.invCode ?? "0"));
        }
      },
    );
    int currentPosition = inv.indexOf(inv
            .where(
              (element) => element.invCode == invCode,
            )
            .firstOrNull ??
        inv.last);

    if (isPrev) {
      if (currentPosition != 0) {
        if (inv
            .where(
              (element) => element.invCode == invCode,
            )
            .isNotEmpty) {
          buildInvInit(true, inv[currentPosition - 1].invId!);
        } else {
          buildInvInit(true, inv.last.invId!);
        }
      }
    } else {
      if (currentPosition < inv.length - 1) {
        buildInvInit(true, inv[currentPosition + 1].invId!);
      }
    }
    update();
  }

  getInvByInvCode(String patId, invCode) {
    List<GlobalModel> inv = invoiceModel.values
        .where((element) =>
            element.patternId == patId && element.invCode == invCode)
        .toList();
    if (inv.isNotEmpty) {
      buildInvInit(true, inv.first.invId!);
    } else {
      Get.snackbar("خطأ رقم الفاتورة", "رقم الفاتورة غير موجود",
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ));
      invCodeController.text = initModel.invCode ?? "";
    }

    update();
  }

  String? selectedPayType;

  //init new inv
  getInit(String patternId) {
    initModel = GlobalModel();
    initModel.patternId = patternId;
    initCodeList(patternId);
    PatternModel patternModel = patternController.patternModel[patternId]!;
    Get.find<InvoicePlutoViewModel>().typeBile = patternModel.patType!;
    invCodeController.text = getNextCodeInv();
    initModel.invGiftAccount = patternModel.patGiftAccount;
    initModel.invSecGiftAccount = patternModel.patSecGiftAccount;

    invPartnerCodeController.text = '';
    if (patternModel.patType != AppConstants.invoiceTypeBuy) {
      invCustomerAccountController.text =
          getAccountModelFromId(patternModel.patSecondary)
                  ?.accCustomer
                  ?.firstOrNull
                  ?.customerAccountName ??
              '';
    } else {
      invCustomerAccountController.text =
          getAccountModelFromId(patternModel.patPrimary)
                  ?.accCustomer
                  ?.firstOrNull
                  ?.customerAccountName ??
              '';
    }
    Get.find<InvoicePlutoViewModel>().customerName =
        invCustomerAccountController.text;
    if (patternModel.patType != AppConstants.invoiceTypeChange) {
      primaryAccountController.text =
          getAccountNameFromId(patternModel.patPrimary!);
      secondaryAccountController.text =
          getAccountNameFromId(patternModel.patSecondary!);
    } else {
      primaryAccountController.clear();
      secondaryAccountController.clear();
      storeNewController.text = getStoreNameFromId(patternModel.patNewStore!);
    }
    storeController.text = getStoreNameFromId(patternModel.patStore!);
    entryBondIdController.clear();
    noteController.clear();
    billIDController.clear();
    mobileNumberController.clear();
    if (getMyUserSellerId() != null) {
      sellerController.text = getSellerNameFromId(getMyUserSellerId()) ?? '';
    }
    dateController = DateTime.now().toString().split(".")[0];
    invDueDateController = DateTime.now().toString().split(".")[0];
    // records = [...List.generate(5, (index) => InvoiceRecordModel(prodChoosePriceMethod: Const.invoiceChoosePriceMethodeDefault))];
    // discountRecords = List.generate(3, (index) => InvoiceDiscountRecordModel());
    // invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: vat);
    // invoiceDiscountRecordSource = InvoiceDiscountRecordSource(
    //   records: discountRecords,
    // );
  }

  ScreenViewModel screenViewModel = Get.find<ScreenViewModel>();

  initCodeList(patternId) {
    nextPrevList = Map.fromEntries(invoiceModel.values
        .where((element) => element.patternId == patternId)
        .map((e) => MapEntry(e.invCode!, e.invId!))
        .toList());

    // if (screenViewModel.openedScreen.values.where((element) => element.patternId == patternId).isEmpty) {
    //   nextPrevList = Map.fromEntries(invoiceModel.values.where((element) => element.patternId == patternId).map((e) => MapEntry(e.invCode!, e.invId!)).toList());
    // } else {
    //   nextPrevList = Map.fromEntries(screenViewModel.openedScreen.values.where((element) => element.patternId == patternId).map((e) => MapEntry(e.invCode!, e.invId!)).toList());
    // }
  }

  String getNextCodeInv() {
    int _ = 0;
    if (nextPrevList.isEmpty) {
      return "0";
    } else {
      _ = int.parse(nextPrevList.keys.where((e) => !e.contains("F-")).last);
      while (nextPrevList.containsKey(_.toString())) {
        _++;
      }
    }
    return _.toString();
  }

  //int old inv
  buildInvInit(bool bool, String invId) {
    if (bool) {
      initModel = invoiceModel[invId]!;
    }
    invPartnerCodeController.text = initModel.invPartnerCode ?? '';
    invReturnCodeController.text = initModel.invReturnCode ?? '';
    invReturnDateController.text = initModel.invReturnDate ?? '';
    // typeBill = patternController.patternModel[initModel.patternId]!.patType!;
    storeController.text = getStoreNameFromId(initModel.invStorehouse);
    billIDController.text = initModel.invId!;
    PatternModel patternModel =
        patternController.patternModel[initModel.patternId]!;
    Get.find<InvoicePlutoViewModel>().typeBile = patternModel.patType!;

    initModel.invGiftAccount = patternModel.patGiftAccount;
    initModel.invSecGiftAccount = patternModel.patSecGiftAccount;
    if (patternController.patternModel[initModel.patternId]!.patColor != null) {
      colorInvoice =
          patternController.patternModel[initModel.patternId]!.patColor!;
    }

    if (patternModel.patType != AppConstants.invoiceTypeChange &&
        patternModel.patType != AppConstants.invoiceTypeAdd) {
      secondaryAccountController.text =
          getAccountNameFromId(initModel.invSecondaryAccount!);
      primaryAccountController.text =
          getAccountNameFromId(initModel.invPrimaryAccount!);
      sellerController.text = getSellerNameFromId(initModel.invSeller) ?? '';
    } else {
      primaryAccountController.clear();
      secondaryAccountController.clear();
      storeNewController.text = getStoreNameFromId(initModel.invSecStorehouse);
    }

    if (patternModel.patType != AppConstants.invoiceTypeBuy) {
      invCustomerAccountController.text =
          getAccountModelFromId(initModel.invSecondaryAccount)
                  ?.accCustomer
                  ?.firstOrNull
                  ?.customerAccountName ??
              '';
    } else {
      invCustomerAccountController.text =
          getAccountModelFromId(initModel.invPrimaryAccount)
                  ?.accCustomer
                  ?.firstOrNull
                  ?.customerAccountName ??
              '';
    }
    Get.find<InvoicePlutoViewModel>().customerName =
        invCustomerAccountController.text;
    mobileNumberController.text = initModel.invMobileNumber ?? "";
    noteController.text = initModel.invComment!;
    entryBondIdController.text = initModel.entryBondId ?? "";
    invCodeController.text = initModel.invCode!;
    dateController = initModel.invDate;
    invDueDateController = initModel.invDueDate;
    firstPayController.text = initModel.firstPay.toString();

    // dateController = initModel.invDate!;
    initCodeList(initModel.patternId);

    Get.find<InvoicePlutoViewModel>().getRows(initModel.invRecords ?? []);
    // buildSource(initModel.invId!);
    // buildDiscountSource(initModel.invId!);

    if (!bool) {
      update();
    }
    selectedPayType = initModel.invPayType;
  }

  buildInvInitRecent(GlobalModel model) {
    initModel = model;
    PatternModel patternModel =
        patternController.patternModel[initModel.patternId]!;
    Get.find<InvoicePlutoViewModel>().typeBile = patternModel.patType!;
    invReturnCodeController.text = initModel.invReturnCode ?? '';
    invReturnDateController.text = initModel.invReturnDate ?? '';
    invPartnerCodeController.text = model.invPartnerCode ?? '';
    secondaryAccountController.text =
        getAccountNameFromId(initModel.invSecondaryAccount);
    primaryAccountController.text =
        getAccountNameFromId(initModel.invPrimaryAccount);
    invCustomerAccountController.text =
        getAccountModelFromId(initModel.invCustomerAccount)
                ?.accCustomer
                ?.firstOrNull
                ?.customerAccountName ??
            '';
    Get.find<InvoicePlutoViewModel>().customerName =
        invCustomerAccountController.text;
    storeController.text = getStoreNameFromId(initModel.invStorehouse);
    billIDController.text = initModel.invId!;
    if (patternModel.patType != AppConstants.invoiceTypeBuy) {
      invCustomerAccountController.text =
          getAccountModelFromId(initModel.invSecondaryAccount)
                  ?.accCustomer
                  ?.firstOrNull
                  ?.customerAccountName ??
              '';
    } else {
      invCustomerAccountController.text =
          getAccountModelFromId(initModel.invPrimaryAccount)
                  ?.accCustomer
                  ?.firstOrNull
                  ?.customerAccountName ??
              '';
    }
    initModel.invGiftAccount = patternModel.patGiftAccount;
    initModel.invSecGiftAccount = patternModel.patSecGiftAccount;
    if (patternController.patternModel[initModel.patternId]!.patColor != null) {
      colorInvoice =
          patternController.patternModel[initModel.patternId]!.patColor!;
    }
    if (patternModel.patType != AppConstants.invoiceTypeChange &&
        patternModel.patType != AppConstants.invoiceTypeAdd) {
      secondaryAccountController.text =
          getAccountNameFromId(initModel.invSecondaryAccount!);
      primaryAccountController.text =
          getAccountNameFromId(initModel.invPrimaryAccount!);
      sellerController.text = getSellerNameFromId(initModel.invSeller) ?? '';
    } else {
      primaryAccountController.clear();
      secondaryAccountController.clear();
      storeNewController.text = getStoreNameFromId(initModel.invSecStorehouse);
    }
    mobileNumberController.text = initModel.invMobileNumber ?? "";
    noteController.text = initModel.invComment!;
    entryBondIdController.text = initModel.entryBondId ?? "";
    invCodeController.text = initModel.invCode!;
    firstPayController.text = initModel.firstPay.toString();
    dateController = initModel.invDate;
    invDueDateController = initModel.invDueDate;
    // dateController = initModel.invDate!;
    initCodeList(initModel.patternId);
    selectedPayType = initModel.invPayType;
    // buildSourceRecent(initModel);
    // buildDiscountSourceRecent(initModel);

    // update();
  }

  bool checkAllRecord() {
    for (var element in records) {
      return (element.invRecProduct == "" ||
          element.invRecProduct == null ||
          (element.invRecQuantity == 0 && element.invRecGift == 0) ||
          element.invRecQuantity == null);
    }
    return false;
  }

  bool checkAllDiscountRecords() {
    // for (var element in discountRecords) {

    //   if(( element.discountId != null && (element.accountId == null || element.percentage == null || element.total == null))){
    //       return true;
    //   }

    // }
    // double _total =0;
    // if(discountRecords.length>1){
    //   total = discountRecords.map((e)=>e.total??0).reduce((value, element) => value+element);
    // }else if (discountRecords.length == 1){
    //   total =discountRecords.first.total??0;
    // }
    // if(_total>computeWithoutVatTotal()){

    //     return true;
    // }
    return false;
  }

  getStoreComplete() async {
    storePickList = [];
    // var userInput = storeController.text;
    // storeController.clear();
    storeViewController.storeMap.forEach((key, value) {
      storePickList.addIf(
          value.stCode!
                  .toLowerCase()
                  .contains(storeController.text.toLowerCase()) ||
              value.stName!
                  .toLowerCase()
                  .contains(storeController.text.toLowerCase()),
          value.stName!);
    });
    if (storePickList.length > 1) {
      await Get.defaultDialog(
        title: "اختر احد المستودعات",
        content: SizedBox(
          height: Get.height / 2,
          width: Get.height / 2,
          child: ListView.builder(
            itemCount: storePickList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  storeController.text = storePickList[index];
                  Get.back();
                  update();
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(8),
                  width: 500,
                  child: Center(
                    child: Text(
                      storePickList[index],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else if (storePickList.length == 1) {
      storeController.text = storePickList[0];
    } else {
      storeController.clear();
      Get.snackbar("فحص المطاييح", "هذا المطيح غير موجود من قبل");
    }
  }

  bool checkAccountComplete(String text) {
    return accountController.accountList.values
        .map((e) => e.accName?.toLowerCase())
        .toList()
        .contains(text.toLowerCase());
  }

  bool checkStoreComplete() {
    return storeViewController.storeMap.values
        .map((e) => e.stName?.toLowerCase())
        .toList()
        .contains(storeController.text.toLowerCase());
  }

  bool checkStoreNewComplete() {
    return storeViewController.storeMap.values
        .map((e) => e.stName?.toLowerCase())
        .toList()
        .contains(storeNewController.text.toLowerCase());
  }

  bool checkSellerComplete() {
    return sellerViewController.allSellers.values
        .map((e) => e.sellerName?.toLowerCase())
        .toList()
        .contains(sellerController.text.toLowerCase());
  }

  getInvCode() {
    invIdList = [];
    invCodeList = [];
    invoiceModel.forEach((key, value) {
      invIdList.add(value.invId!);
      invCodeList.add(value.invCode!);
      patternList.add(value.patternId!);
    });
  }

/*  void addProductToInvoice(List<ProductModel> result) {
    double vat = getVatFromName(getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
    List<InvoiceRecordModel> newRecord = [];
    bool isPatternHasVat = patternController.patternModel[initModel.patternId]!.patHasVat!;

    for (var i = 0; i < result.length; i++) {
      var _ = InvoiceRecordSource(records: [], accountVat: '');
      var price = (_.getPrice(Const.invoiceChoosePriceMethodeDefault, result[i].prodId));
      newRecord.insert(i, InvoiceRecordModel(prodChoosePriceMethod: Const.invoiceChoosePriceMethodeDefault));
      newRecord[i].invRecProduct = result[i].prodId!.toString();
      newRecord[i].invRecId = (i + 1).toString();
      newRecord[i].prodChoosePriceMethod = Const.invoiceChoosePriceMethodeDefault;
      newRecord[i].invRecSubTotal = price / (result[i].prodIsLocal! ? (vat + 1) : 1);
      newRecord[i].invRecVat = !isPatternHasVat
          ? 0
          : (result[i].prodIsLocal ?? false)
              ? (price - (price / (vat + 1)))
              : 0;
      newRecord[i].invRecQuantity = 1;
    }

    // onCellTap(rowColumnIndex);
    records.removeWhere((element) => element.invRecProduct == null);
    records = records + newRecord + [InvoiceRecordModel(prodChoosePriceMethod: Const.invoiceChoosePriceMethodeDefault)];
    for (var i = 0; i < records.length - 1; i++) {
      records[i].invRecId = (i + 1).toString();
    }
    invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
    update();
  }*/

/*  void deleteOneRecord(int index) {
    records.removeAt(index);
    for (var i = 0; i < records.length - 1; i++) {
      records[i].invRecId = (i + 1).toString();
    }
    invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
    update();
  }*/

  double getTotal(double input) {
    double totalWithoutVat = computeWithoutVatTotal();

    return totalWithoutVat * input / 100;
  }

  double getPercentage(double input) {
    double totalWithoutVat = computeWithoutVatTotal();
    return input / totalWithoutVat * 100;
  }

  void copyInvoice(GlobalModel initModel) {
    String _ = "";
    for (var i = 0; i < records.length; i++) {}
  }
}

void showEInvoiceDialog({required String mobileNumber, required String invId}) {
  Get.defaultDialog(
      title: "فاتورتك الرقمية",
      content: SizedBox(
        height: Get.height / 1.8,
        width: Get.height / 1.8,
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            Center(
              child: QrImageView(
                data:
                    'https://ba3-business-solutions.firebaseapp.com/?id=$invId&year=${AppConstants.dataName}',
                version: QrVersions.auto,
                size: Get.height / 2.5,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                "مشاركة عبر",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text("البريد الألكتروني:"),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: CustomTextFieldWithoutIcon(
                  controller: TextEditingController(),
                  onSubmitted: (p0) {
                    sendEmail(
                        'https://ba3-business-solutions.firebaseapp.com/?id=$invId&year=${AppConstants.dataName}',
                        p0);
                  },
                )),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                      text:
                          'https://ba3-business-solutions.firebaseapp.com/?id=$invId&year=${AppConstants.dataName}',
                    ));
                  },
                  // backgroundColor: Colors.grey,
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        AppButton(
          onPressed: () {
            Get.back();
          },
          title: "موافق",
          iconData: Icons.done,
        )
      ]);
}

getInvoicePatternFromInvId(id) {
  GlobalModel globalModel = Get.find<InvoiceViewModel>().invoiceModel[id]!;
  return "${getPatModelFromPatternId(globalModel.patternId).patName!} : ${globalModel.invCode!}";
}
