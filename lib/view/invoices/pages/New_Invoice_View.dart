import 'dart:developer';

import 'package:ba3_business_solutions/controller/invoice/Invoice_Pluto_Edit_View_Model.dart';
import 'package:ba3_business_solutions/core/constants/app_strings.dart';
import 'package:ba3_business_solutions/core/shared/widgets/custom_pluto_with_edite.dart';
import 'package:ba3_business_solutions/core/shared/widgets/get_product_enter_short_cut.dart';
import 'package:ba3_business_solutions/main.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:ba3_business_solutions/view/invoices/widget/qr_invoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../controller/account/account_view_model.dart';
import '../../../controller/bond/entry_bond_view_model.dart';
import '../../../controller/globle/global_view_model.dart';
import '../../../controller/invoice/invoice_view_model.dart';
import '../../../controller/print/print_view_model.dart';
import '../../../controller/product/product_view_model.dart';
import '../../../controller/seller/sellers_view_model.dart';
import '../../../controller/store/store_view_model.dart';
import '../../../controller/user/user_management_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../core/services/Get_Date_From_String.dart';
import '../../../core/shared/widgets/custom_pluto_short_cut.dart';
import '../../../core/shared/widgets/option_text_widget.dart';
import '../../../core/utils/confirm_delete_dialog.dart';
import '../../../core/utils/date_picker.dart';
import '../../../core/utils/generate_id.dart';
import '../../../model/account/account_model.dart';
import '../../../model/global/global_model.dart';
import '../../../model/invoice/invoice_record_model.dart';
import '../../../model/patterens/Pattern_model.dart';
import '../../../model/product/product_model.dart';
import '../../../model/store/store_model.dart';
import '../../entry_bond/pages/entry_bond_details_view.dart';
import '../../sellers/pages/add_seller.dart';
import '../../stores/pages/add_store.dart';
import '../Controller/Screen_View_Model.dart';

class InvoiceView extends StatefulWidget {
  const InvoiceView({super.key,
    required this.billId,
    required this.patternId,
    this.recentScreen = false});

  final String billId;
  final String patternId;

  final bool recentScreen;

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  final invoiceController = Get.find<InvoiceViewModel>();
  final globalController = Get.find<GlobalViewModel>();
  final accountController = Get.find<AccountViewModel>();
  final storeController = Get.find<StoreViewModel>();
  final plutoEditViewModel = Get.find<InvoicePlutoViewModel>();
  ScreenViewModel screenViewModel = Get.find<ScreenViewModel>();

  List<String> codeInvList = [];

  String typeBill = AppConstants.invoiceTypeSales;
  bool isEditDate = false;
  PatternModel? patternModel;

  @override
  void dispose() {
    // TODO: implement dispose
    if (AppConstants.isNotTap) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.recentScreen) {
      patternModel =
      invoiceController.patternController.patternModel[widget.patternId];
      invoiceController.initModel =
      screenViewModel.openedScreen[widget.billId]!;
      // invoiceController.buildInvInit(false, widget.billId);
      plutoEditViewModel
          .getRows(invoiceController.initModel.invRecords?.toList() ?? []);
      invoiceController
          .buildInvInitRecent(screenViewModel.openedScreen[widget.billId]!);
    } else if (widget.billId != "1") {
      patternModel = invoiceController.patternController.patternModel[
      invoiceController.invoiceModel[widget.billId]!.patternId!];
      invoiceController.buildInvInit(true, widget.billId);
      plutoEditViewModel.getRows(
          invoiceController.invoiceModel[widget.billId]?.invRecords?.toList() ??
              []);
    } else {
      patternModel =
      invoiceController.patternController.patternModel[widget.patternId];
      invoiceController.getInit(patternModel!.patId!);
      invoiceController.selectedPayType = AppConstants.invPayTypeCash;
      invoiceController.invReturnCodeController.text = '';
      invoiceController.invReturnDateController.text = '';

      // globalController.dateController = DateTime.now().toString().split(" ")[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    log('message: "فاتورة ${patternModel?.patFullName ?? ""}"');
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 75,
        leading: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                screenViewModel.openedScreen.removeWhere(
                      (key, value) =>
                  key ==
                      _updateData(plutoEditViewModel.invoiceRecord).invId ||
                      key == widget.billId,
                );
                screenViewModel.update();

                Get.back();
              },
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.red.shade800, shape: BoxShape.circle),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () async {
                plutoEditViewModel.handleSaveAll(
                    withOutProud:
                    patternModel!.patFullName == "مبيعات بدون اصل");
                if (plutoEditViewModel
                    .invoiceRecord.firstOrNull?.invRecProduct !=
                    null &&
                    _updateData(plutoEditViewModel.invoiceRecord)
                        .invIsPending ==
                        null) {
                  screenViewModel.openedScreen[widget.billId == "1"
                      ? _updateData(plutoEditViewModel.invoiceRecord).invId!
                      : widget.billId] =
                      _updateData(plutoEditViewModel.invoiceRecord);
                  screenViewModel.update();
                }

                Get.back();
              },
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade800, shape: BoxShape.circle),
                  child: const Icon(
                    Icons.download_outlined,
                    size: 16,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
        title: FittedBox(
          child: Text(widget.billId == "1"
              ? "فاتورة ${patternModel?.patFullName ?? ""}".tr
              : "تفاصيل فاتورة ${patternModel?.patFullName ?? ""}"),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                List<ProductModel>? a = await Get.to(() =>
                    QRScannerView(
                      whitUnknown:
                      patternModel!.patFullName == "مبيعات بدون اصل",
                    ));
                if (a == null) {} else {
                  plutoEditViewModel.addProductToInvoice(a,
                      whitUnknown:
                      patternModel!.patFullName == "مبيعات بدون اصل");
                }
              },
              icon: const Icon(
                Icons.qr_code,
                color: Colors.black,
              )),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            height: AppConstants.constHeightTextField,
            child: Row(
              children: [
                if (patternModel!.patType !=
                    AppConstants.invoiceTypeSalesWithPartner)
                  SizedBox(
                    width: 250,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          child: Text(
                            "${AppStrings.invoiceType.tr}" ": ",
                          ),
                        ),
                        Expanded(
                          child: Container(
                              height: AppConstants.constHeightTextField,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(8)),
                              child: DropdownButton(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                                underline: const SizedBox(),
                                value: invoiceController.selectedPayType,
                                isExpanded: true,
                                onChanged: (_) {
                                  invoiceController.selectedPayType = _!;
                                  if (invoiceController.selectedPayType ==
                                      AppConstants.invPayTypeCash) {
                                    invoiceController.firstPayController
                                        .clear();
                                  }
                                  setState(() {});
                                },
                                items: [
                                  AppConstants.invPayTypeDue,
                                  AppConstants.invPayTypeCash
                                ]
                                    .map((e) =>
                                    DropdownMenuItem(
                                      value: e,
                                      child: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            getInvPayTypeFromEnum(e),
                                            textDirection:
                                            TextDirection.rtl,
                                          )),
                                    ))
                                    .toList(),
                              )),
                        ),
                      ],
                    ),
                  ),
                if (checkPermission(
                    AppConstants.roleUserAdmin, AppConstants.roleViewInvoice))
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            invoiceController.invNextOrPrev(
                                patternModel!.patId!,
                                invoiceController.invCodeController.text,
                                true);
                            setState(() {});
                          },
                          icon: const Icon(Icons.keyboard_double_arrow_right)),
                      // const Text("Invoice Code : "),
                      SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.10,
                          child: CustomTextFieldWithoutIcon(
                            isNumeric: true,
                            controller: invoiceController.invCodeController,
                            onSubmitted: (text) {
                              invoiceController.getInvByInvCode(
                                patternModel!.patId!,
                                text,
                              );
                            },
                          )),
                      IconButton(
                          onPressed: () {
                            invoiceController.invNextOrPrev(
                                patternModel!.patId!,
                                invoiceController.invCodeController.text,
                                false);

                            // invoiceController.nextInv(patternModel!.patId!, invoiceController.invCodeController.text);
                          },
                          icon: const Icon(Icons.keyboard_double_arrow_left)),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: GetBuilder<InvoiceViewModel>(builder: (controller) {
        return ListView(
          shrinkWrap: true,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (patternModel!.patType != AppConstants.invoiceTypeChange)
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 20,
                    child: Wrap(
                      spacing: 20,
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: 10,
                      children: [
                        SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.45,
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 100,
                                  child: Text(AppStrings.invoiceDateTitle.tr,
                                      style: TextStyle())),
                              Expanded(
                                child: GetBuilder<InvoiceViewModel>(
                                    builder: (controller) {
                                      return DatePicker(
                                        initDate: invoiceController
                                            .dateController,
                                        onSubmit: (_) {
                                          invoiceController.dateController =
                                          _.toString().split(".")[0];
                                          isEditDate = true;
                                          controller.update();
                                        },
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                        if (patternModel?.patType !=
                            AppConstants.invoiceTypeSalesWithPartner &&
                            invoiceController.selectedPayType ==
                                AppConstants.invPayTypeDue)
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.45,
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 100,
                                    child: Text(AppStrings.dueDate.tr,
                                        style: TextStyle())),
                                Expanded(
                                  child: GetBuilder<InvoiceViewModel>(
                                      builder: (controller) {
                                        return DatePicker(
                                          initDate: invoiceController
                                              .invDueDateController,
                                          onSubmit: (_) {
                                            invoiceController
                                                .invDueDateController =
                                            _.toString().split(".")[0];
                                            isEditDate = true;
                                            controller.update();
                                          },
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        if (patternModel!.patType ==
                            AppConstants.invoiceTypeSales)
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.45,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    AppStrings.debtor.tr,
                                  ),
                                ),
                                if (patternModel!.patType ==
                                    AppConstants.invoiceTypeSales)
                                  Expanded(
                                    child: CustomTextFieldWithIcon(
                                        controller: invoiceController
                                            .secondaryAccountController,
                                        onSubmitted: (text) async {
                                          invoiceController
                                              .secondaryAccountController
                                              .text =
                                          await getAccountComplete(
                                              invoiceController
                                                  .secondaryAccountController
                                                  .text);
                                          if (getIfAccountHaveCustomers(
                                              invoiceController
                                                  .secondaryAccountController
                                                  .text)) {
                                            invoiceController
                                                .invCustomerAccountController
                                                .text = getAccountCustomers(
                                                invoiceController
                                                    .secondaryAccountController
                                                    .text)
                                                .first
                                                .customerAccountName!;
                                            invoiceController.changeCustomer();
                                          }
                                          // invoiceController.getAccountComplete();
                                          // invoiceController.changeSecAccount();
                                        },
                                        onIconPressed: () {
                                          AccountModel? _ = accountController
                                              .accountList.values
                                              .toList()
                                              .firstWhereOrNull((element) =>
                                          element.accName ==
                                              invoiceController
                                                  .secondaryAccountController
                                                  .text);
                                          if (_ != null) {
                                            // Get.to(AccountDetails(modelKey: _.accId!));
                                          }
                                        }),
                                  )
                                else
                                  if (patternModel!.patType ==
                                      AppConstants.invoiceTypeBuy)
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          0.10,
                                      child: CustomTextFieldWithoutIcon(
                                        controller: invoiceController
                                            .secondaryAccountController,
                                      ),
                                    ),
                              ],
                            ),
                          )
                        else
                          if (patternModel!.patType ==
                              AppConstants.invoiceTypeBuy)
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.45,
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 100,
                                      child: Text(AppStrings.creditor.tr,
                                          style: TextStyle())),
                                  Expanded(
                                    child: CustomTextFieldWithIcon(
                                        controller: invoiceController
                                            .primaryAccountController,
                                        onSubmitted: (text) async {
                                          invoiceController
                                              .primaryAccountController.text =
                                          await getAccountComplete(
                                              invoiceController
                                                  .primaryAccountController
                                                  .text);
                                          if (getIfAccountHaveCustomers(
                                              invoiceController
                                                  .primaryAccountController
                                                  .text)) {
                                            invoiceController
                                                .invCustomerAccountController
                                                .text = getAccountCustomers(
                                                invoiceController
                                                    .primaryAccountController
                                                    .text)
                                                .first
                                                .customerAccountName!;
                                            invoiceController.changeCustomer();
                                          }
                                          // invoiceController.getAccountComplete();
                                          // invoiceController.changeSecAccount();
                                        },
                                        onIconPressed: () {
                                          AccountModel? _ = accountController
                                              .accountList.values
                                              .toList()
                                              .firstWhereOrNull((element) =>
                                          element.accName ==
                                              invoiceController
                                                  .primaryAccountController
                                                  .text);
                                          if (_ != null) {
                                            // Get.to(AccountDetails(modelKey: _.accId!));
                                          }
                                        }),
                                  ),
                                ],
                              ),
                            ),
                        SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.45,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  width: 100,
                                  child: Text(AppStrings.warehouse.tr)),
                              Expanded(
                                child: CustomTextFieldWithIcon(
                                    controller:
                                    invoiceController.storeController,
                                    onSubmitted: (text) {
                                      invoiceController.getStoreComplete();
                                    },
                                    onIconPressed: () {
                                      StoreModel? _ = storeController
                                          .storeMap.values
                                          .toList()
                                          .firstWhereOrNull((element) =>
                                      element.stName ==
                                          invoiceController
                                              .storeController.text);
                                      if (_ != null) {
                                        Get.to(AddStore(oldKey: _.stId!));
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.45,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  width: 100,
                                  child: Text(AppStrings.mobileNumber.tr)),
                              Expanded(
                                child: CustomTextFieldWithoutIcon(
                                    controller: invoiceController
                                        .mobileNumberController),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.45,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  width: 100,
                                  child: Text(AppStrings.clientAccount.tr)),
                              Expanded(
                                child: CustomTextFieldWithIcon(
                                    controller: invoiceController
                                        .invCustomerAccountController,
                                    onSubmitted: (text) async {
                                      invoiceController.changeCustomer();
                                    },
                                    onIconPressed: () {
                                      AccountModel? _ = accountController
                                          .accountList.values
                                          .toList()
                                          .firstWhereOrNull((element) =>
                                      element.accName ==
                                          invoiceController
                                              .invCustomerAccountController
                                              .text);
                                      if (_ != null) {
                                        // Get.to(AccountDetails(modelKey: _.accId!));
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.45,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  AppStrings.seller.tr,
                                ),
                              ),
                              Expanded(
                                child: CustomTextFieldWithIcon(
                                    controller:
                                    invoiceController.sellerController,
                                    onSubmitted: (text) async {
                                      //   globalController.getAccountComplete();
                                      var seller =
                                      await getSellerComplete(text);
                                      // globalController.changeSecAccount();
                                      invoiceController.initModel.invSeller =
                                          seller;
                                      invoiceController.sellerController.text =
                                          seller;
                                    },
                                    onIconPressed: () {
                                      AccountModel? _ = accountController
                                          .accountList.values
                                          .toList()
                                          .firstWhereOrNull((element) =>
                                      element.accName ==
                                          invoiceController
                                              .secondaryAccountController
                                              .text);
                                      if (_ != null) {
                                        Get.to(AddSeller(oldKey: _.accId!));
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.45,
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 100,
                                  child: Text(AppStrings.statement.tr)),
                              Expanded(
                                child: CustomTextFieldWithoutIcon(
                                    controller:
                                    invoiceController.noteController),
                              ),
                            ],
                          ),
                        ),
                        if (patternModel?.patType ==
                            AppConstants.invoiceTypeSalesWithPartner)
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.45,
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 100,
                                    child: Text(
                                        AppStrings.partnerInvoiceNumber.tr)),
                                Expanded(
                                  child: CustomTextFieldWithoutIcon(
                                      controller: invoiceController
                                          .invPartnerCodeController),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                height: 175,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(AppStrings.oldWarehouse.tr),
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.15,
                              child: CustomTextFieldWithIcon(
                                  controller: invoiceController.storeController,
                                  onSubmitted: (text) {
                                    invoiceController.getStoreComplete();
                                  },
                                  onIconPressed: () {
                                    StoreModel? _ = storeController
                                        .storeMap.values
                                        .toList()
                                        .firstWhereOrNull((element) =>
                                    element.stName ==
                                        invoiceController
                                            .storeController.text);
                                    if (_ != null) {
                                      Get.to(AddStore(oldKey: _.stId!));
                                    }
                                  }),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(AppStrings.newWarehouse.tr),
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.15,
                              child: CustomTextFieldWithIcon(
                                  controller:
                                  invoiceController.storeNewController,
                                  onSubmitted: (text) {
                                    invoiceController.getStoreComplete();
                                  },
                                  onIconPressed: () {
                                    StoreModel? _ = storeController
                                        .storeMap.values
                                        .toList()
                                        .firstWhereOrNull((element) =>
                                    element.stName ==
                                        invoiceController
                                            .storeNewController.text);
                                    if (_ != null) {
                                      Get.to(AddStore(oldKey: _.stId!));
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(AppStrings.statement.tr),
                        SizedBox(
                          height: 35,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          child: CustomTextFieldWithoutIcon(
                              controller: invoiceController.noteController),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 350,
              margin: const EdgeInsets.only(left: 25, right: 8),
              child: GetBuilder<InvoicePlutoViewModel>(builder: (controller) {
                return CustomPlutoWithEdite(
                  evenRowColor: Color(patternModel!.patColor!),
                  controller: controller,
                  shortCut: customPlutoShortcut(GetProductEnterPlutoGridAction(
                      controller, "invRecProduct")),
                  onRowDoubleTap: (event) {
                    if (event.cell.column.field == "invRecSubTotal") {
                      if (getProductModelFromName(controller.stateManager
                          .currentRow?.cells['invRecProduct']?.value!) !=
                          null) {
                        controller.showContextMenuSubTotal(
                            index: event.rowIdx,
                            productModel: getProductModelFromName(controller
                                .stateManager
                                .currentRow
                                ?.cells['invRecProduct']
                                ?.value!)!,
                            tapPosition:
                            Offset(event.rowIdx * 1.0, event.rowIdx * 1.0));
                      }
                    }
                    if (event.cell.column.field == "invRecId") {
                      Get.defaultDialog(
                          title: AppStrings.confirmDeletion.tr,
                          content: Text(AppStrings.confirmDeletionMessage.tr),
                          actions: [
                            AppButton(
                                title: AppStrings.yes.tr,
                                onPressed: () {
                                  controller.clearRowIndex(event.rowIdx);
                                },
                                iconData: Icons.check),
                            AppButton(
                              title: AppStrings.no.tr,
                              onPressed: () {
                                Get.back();
                              },
                              iconData: Icons.clear,
                              color: Colors.red,
                            ),
                          ]);
                    }
                  },
                  onChanged: (PlutoGridOnChangedEvent event) async {
                    String quantityNum = extractNumbersAndCalculate(controller
                        .stateManager
                        .currentRow!
                        .cells["invRecQuantity"]
                        ?.value
                        ?.toString() ??
                        '');
                    String? subTotalStr = extractNumbersAndCalculate(controller
                        .stateManager
                        .currentRow!
                        .cells["invRecSubTotal"]
                        ?.value
                        .toString() ??
                        "0")
                        .toString();
                    String? totalStr = extractNumbersAndCalculate(controller
                        .stateManager
                        .currentRow!
                        .cells["invRecTotal"]
                        ?.value
                        .toString() ??
                        "0")
                        .toString();
                    String? vat = extractNumbersAndCalculate(controller
                        .stateManager
                        .currentRow!
                        .cells["invRecVat"]
                        ?.value
                        .toString() ??
                        "0")
                        .toString();
                    String? dis = extractNumbersAndCalculate(controller
                        .stateManager
                        .currentRow!
                        .cells["invRecDis"]
                        ?.value
                        .toString() ??
                        "0")
                        .toString();
                    String? product = (controller.stateManager.currentRow!
                        .cells["invRecProduct"]?.value
                        .toString() ??
                        "0")
                        .toString();

                    double subTotal = controller.parseExpression(subTotalStr);
                    double total = controller.parseExpression(totalStr);
                    int quantity = double.parse(quantityNum).toInt();

                    if (event.column.field == "invRecProduct") {
                      print("object");
                      controller.updateInvProd();
                    }
                    if (event.column.field == "invRecSubTotal") {
                      controller.updateInvoiceValues(subTotal, quantity);
                    }
                    if (event.column.field == "invRecTotal") {
                      controller.updateInvoiceValuesByTotal(total, quantity);
                    }
                    if (event.column.field == "invRecDis" && quantity > 0) {
                      controller.updateInvoiceValuesByDiscount(
                          total, quantity, double.parse(dis));
                    }
                    if (event.column.field == "invRecQuantity" &&
                        quantity > 0) {
                      controller.updateInvoiceValuesByQuantity(
                          quantity, subTotal, double.parse(vat));
                    }
                    WidgetsFlutterBinding
                        .ensureInitialized()
                        .waitUntilFirstFrameRasterized
                        .then(
                          (value) {
                        controller.update();
                      },
                    );
                  },
                );
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            if (patternModel!.patType != AppConstants.invoiceTypeChange) ...[
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              GetBuilder<InvoicePlutoViewModel>(builder: (controller) {
                return SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      if (patternModel!.patType ==
                          AppConstants.invoiceTypeSalesWithPartner)
                        Wrap(
                          // mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                color: Color(patternModel!.patColor!),
                                width: 150,
                                padding: const EdgeInsets.all(8),
                                margin:
                                const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  children: [
                                    Text(
                                      patternModel?.patName == "م Tabby"
                                          ? (((controller
                                          .computeWithVatTotal() *
                                          (patternModel!
                                              .patPartnerRatio! /
                                              100)) +
                                          patternModel!
                                              .patPartnerCommission!) *
                                          1.05)
                                          .toStringAsFixed(2)
                                          : ((controller.computeWithVatTotal() *
                                          (patternModel!
                                              .patPartnerRatio! /
                                              100)) +
                                          patternModel!
                                              .patPartnerCommission!)
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                    Text(
                                      AppStrings.percentage.tr,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Color(patternModel!.patColor!),
                                width: 150,
                                padding: const EdgeInsets.all(8),
                                margin:
                                const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  children: [
                                    Text(
                                      patternModel?.patName == "م Tabby"
                                          ? (controller.computeWithVatTotal() -
                                          (((controller.computeWithVatTotal() *
                                              (patternModel!
                                                  .patPartnerRatio! /
                                                  100)) +
                                              patternModel!
                                                  .patPartnerCommission!) *
                                              1.05))
                                          .toStringAsFixed(2)
                                          : (controller.computeWithVatTotal() -
                                          ((controller.computeWithVatTotal() *
                                              (patternModel!
                                                  .patPartnerRatio! /
                                                  100)) +
                                              patternModel!
                                                  .patPartnerCommission!))
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                    Text(
                                      AppStrings.netAmount.tr,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ])
                      else
                        const SizedBox(),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        alignment: WrapAlignment.end,
                        children: [
                          Container(
                            color: Colors.blueGrey.shade400,
                            width: 150,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                Text(
                                  (controller.computeWithVatTotal() -
                                      controller.computeWithoutVatTotal())
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                Text(
                                  AppStrings.vatAmount.tr,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade600,
                            width: 150,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                Text(
                                  controller
                                      .computeWithoutVatTotal()
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                Text(
                                  AppStrings.total.tr,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            width: 300,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    (controller.computeWithVatTotal())
                                        .toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    AppStrings.finalAmount.tr,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 20,
                children: [
                  AppButton(
                      title: AppStrings.newString.tr,
                      onPressed: () async {
                        checkPermissionForOperation(AppConstants.roleUserWrite,
                            AppConstants.roleViewInvoice)
                            .then((value) {
                          if (value) {
                            controller.getInit(controller.initModel.patternId!);
                            controller.update();
                            plutoEditViewModel.getRows([]);
                            plutoEditViewModel.update();
                          }
                        });
                      },
                      iconData: Icons.create_new_folder_outlined),
                  if (controller.initModel.invId == null ||
                      controller.initModel.invIsPending == null)
                    AppButton(
                        title: AppStrings.addString.tr,
                        onPressed: () async {
                          plutoEditViewModel.handleSaveAll(
                              withOutProud: patternModel!.patFullName ==
                                  "مبيعات بدون اصل");
                          /* if (invoiceController.checkInvCode()) {
                            Get.snackbar("فحص المطاييح", "هذا الرمز يرجى استخدام الرمز: ${invoiceController.getNextCodeInv()}");
                          } else */
                          if (!invoiceController.checkSellerComplete() &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.checkItems,
                                AppStrings.sellerNotFound);
                          } else if (!invoiceController.checkStoreComplete()) {
                            Get.snackbar(AppStrings.checkItems,
                                AppStrings.storeNotFound);
                          } else if (!invoiceController
                              .checkStoreNewComplete() &&
                              patternModel!.patType ==
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.checkItems,
                                AppStrings.storeNotFound);
                          } else if (!invoiceController.checkAccountComplete(
                              invoiceController
                                  .secondaryAccountController.text) &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.checkItems,
                                AppStrings.accountNotFound);
                          } else if (invoiceController
                              .primaryAccountController.text.isEmpty &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeAdd &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.fillingError,
                                AppStrings.enterSellerAccount);
                          } else if (invoiceController
                              .primaryAccountController.text ==
                              invoiceController
                                  .secondaryAccountController.text &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.fillingError,
                                AppStrings.sellerBuyerConflict);
                          } else if (plutoEditViewModel.invoiceRecord.isEmpty) {
                            Get.snackbar(AppStrings.fillingError,
                                AppStrings.addItemsToInvoice);
                          } else if (invoiceController
                              .checkAllDiscountRecords()) {
                            Get.snackbar(AppStrings.fillingError,
                                AppStrings.correctDiscountError);
                          } else if (patternModel?.patType ==
                              AppConstants.invoiceTypeSalesWithPartner &&
                              controller
                                  .invPartnerCodeController.text.isEmpty) {
                            Get.snackbar(AppStrings.fillingError,
                                AppStrings.correctPartnerInvoiceError);
                          } else {
                            checkPermissionForOperation(
                                AppConstants.roleUserWrite,
                                AppConstants.roleViewInvoice)
                                .then((value) async {
                              if (value) {
                                screenViewModel.openedScreen.removeWhere(
                                      (key, value) =>
                                  key ==
                                      _updateData(plutoEditViewModel
                                          .invoiceRecord)
                                          .invId ||
                                      key == widget.billId,
                                );
                                // await invoiceController.computeTotal(plutoEditViewModel.invoiceRecord);
                                globalController.addGlobalInvoice(_updateData(
                                    plutoEditViewModel.invoiceRecord));
                                // invoiceController.initModel=_updateData(plutoEditViewModel.invoiceRecord);
                                screenViewModel.update();
                              }
                            });
                          }
                        },
                        iconData: Icons.add_chart_outlined),
                  if (controller.initModel.invId != null &&
                      controller.initModel.invIsPending != null) ...[
                    if (!(controller.initModel.invIsPending ?? true))
                      AppButton(
                          title: AppStrings.bond.tr,
                          onPressed: () async {
                            Get.to(() =>
                                EntryBondDetailsView(
                                  oldId: controller.initModel.entryBondId,
                                ));
                          },
                          iconData: Icons.file_open_outlined)
                    else
                      AppButton(
                        title: AppStrings.approval.tr,
                        onPressed: () async {
                          plutoEditViewModel.handleSaveAll(
                              withOutProud: patternModel!.patFullName ==
                                  "مبيعات بدون اصل");

                          // if (globalController.invCodeList.contains(
                          //     globalController.invCodeController.text)) {
                          if (!invoiceController.checkSellerComplete() &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.check.tr,
                                AppStrings.sellerNotFound.tr);
                          } else if (!invoiceController.checkStoreComplete()) {
                            Get.snackbar(AppStrings.check.tr,
                                AppStrings.storeNotFound.tr);
                          } else if (!invoiceController
                              .checkStoreNewComplete() &&
                              patternModel!.patType ==
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.checkItems.tr,
                                AppStrings.storeNotFound.tr);
                          } else if (!invoiceController.checkAccountComplete(
                              invoiceController
                                  .secondaryAccountController.text) &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.check.tr,
                                AppStrings.accountNotFound.tr);
                            // } else if (!invoiceController.checkAccountComplete(invoiceController.invCustomerAccountController.text)) {
                            //   Get.snackbar("فحص المطاييح", "هذا العميل غير موجود من قبل");
                          } else if (invoiceController
                              .primaryAccountController.text.isEmpty &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.error.tr,
                                AppStrings.enterSellerAccount.tr);
                          } else if (invoiceController
                              .primaryAccountController.text ==
                              invoiceController
                                  .secondaryAccountController.text) {
                            Get.snackbar(AppStrings.error.tr,
                                AppStrings.sellerBuyerConflict.tr);
                          } else if (plutoEditViewModel.invoiceRecord.isEmpty) {
                            Get.snackbar(AppStrings.error.tr,
                                AppStrings.emptyProducts.tr);
                          } else
                            /*if (invoiceController.checkAllRecordPrice() && patternModel!.patType == Const.invoiceTypeSales) {
                            Get.snackbar("خطأ ", "تم البيع بأقل من الحد المسموح");
                          } else if (invoiceController.checkAllDiscountRecords()) {
                            Get.snackbar("خطأ تعباية", "يرجى تصحيح الخطأ في الحسميات");
                          } else*/ {
                            checkPermissionForOperation(
                                AppConstants.roleUserAdmin,
                                AppConstants.roleViewInvoice)
                                .then((value) async {
                              if (value) {
                                await invoiceController.computeTotal(
                                    plutoEditViewModel.invoiceRecord);
                                invoiceController.initModel.invIsPending =
                                false;
                                globalController.updateGlobalInvoice(
                                    _updateData(
                                        plutoEditViewModel.invoiceRecord));
                              }
                            });
                          }
                        },
                        iconData: Icons.file_download_done_outlined,
                        color: Colors.green,
                      ),
                    AppButton(
                        title: AppStrings.edit.tr,
                        onPressed: () async {
                          plutoEditViewModel.handleSaveAll(
                              withOutProud: patternModel!.patFullName ==
                                  "مبيعات بدون اصل");

                          // if (globalController.invCodeList.contains(
                          //     globalController.invCodeController.text)) {
                          if (!invoiceController.checkSellerComplete() &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.check.tr,
                                AppStrings.sellerNotFound.tr);
                          } else if (!invoiceController.checkStoreComplete()) {
                            Get.snackbar(AppStrings.check.tr,
                                AppStrings.storeNotFound.tr);
                          } else if (!invoiceController
                              .checkStoreNewComplete() &&
                              patternModel!.patType ==
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.checkItems.tr,
                                AppStrings.storeNotFound.tr);
                          } else if (!invoiceController.checkAccountComplete(
                              invoiceController
                                  .secondaryAccountController.text) &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.check.tr,
                                AppStrings.accountNotFound.tr);
                            // } else if (!invoiceController.checkAccountComplete(invoiceController.invCustomerAccountController.text)) {
                            //   Get.snackbar("فحص المطاييح", "هذا العميل غير موجود من قبل");
                          } else if (invoiceController
                              .primaryAccountController.text.isEmpty &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.error.tr,
                                AppStrings.enterSellerAccount.tr);
                          } else if (invoiceController
                              .primaryAccountController.text ==
                              invoiceController
                                  .secondaryAccountController.text &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.error.tr,
                                AppStrings.sellerBuyerConflict.tr);
                          } else if (plutoEditViewModel.invoiceRecord
                              .where(
                                (element) => element.invRecId != null,
                          )
                              .isEmpty) {
                            Get.snackbar(AppStrings.error.tr,
                                AppStrings.addItemsToInvoiceError.tr);
                          } else if (plutoEditViewModel.invoiceRecord.isEmpty) {
                            Get.snackbar(AppStrings.error.tr,
                                AppStrings.emptyProducts.tr);
                          }
                          /* else if (invoiceController.checkAllRecordPrice() && patternModel!.patType == Const.invoiceTypeSales) {
                            Get.snackbar("خطأ ", "تم البيع بأقل من الحد المسموح");
                          } else if (invoiceController.checkAllDiscountRecords()) {
                            Get.snackbar("خطأ تعباية", "يرجى تصحيح الخطأ في الحسميات");
                          } */
                          else {
                            checkPermissionForOperation(
                                AppConstants.roleUserUpdate,
                                AppConstants.roleViewInvoice)
                                .then((value) async {
                              if (value) {
                                globalController.updateGlobalInvoice(
                                    _updateData(
                                        plutoEditViewModel.invoiceRecord));
                              }
                            });
                          }
                        },
                        iconData: Icons.edit_outlined),
                    if (patternModel!.patFullName == "مبيعات بدون اصل" &&
                        controller.initModel.invId != null)
                      AppButton(
                        title: AppStrings.sales.tr,
                        onPressed: () async {
                          plutoEditViewModel.handleSaveAll(withOutProud: false);
                          // controller.initCodeList(Const.salleTypeId);

                          // if (globalController.invCodeList.contains(
                          //     globalController.invCodeController.text)) {
                          if (!invoiceController.checkSellerComplete() &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.check.tr,
                                AppStrings.sellerNotFound.tr);
                          } else if (!invoiceController.checkStoreComplete()) {
                            Get.snackbar(AppStrings.check.tr,
                                AppStrings.storeNotFound.tr);
                          } else if (!invoiceController
                              .checkStoreNewComplete() &&
                              patternModel!.patType ==
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.checkItems.tr,
                                AppStrings.storeNotFound.tr);
                          } else if (!invoiceController.checkAccountComplete(
                              invoiceController
                                  .secondaryAccountController.text) &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.check.tr,
                                AppStrings.accountNotFound.tr);
                          } else if (invoiceController
                              .primaryAccountController.text.isEmpty &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.error.tr,
                                AppStrings.enterSellerAccount.tr);
                          } else if (invoiceController
                              .primaryAccountController.text ==
                              invoiceController
                                  .secondaryAccountController.text &&
                              patternModel!.patType !=
                                  AppConstants.invoiceTypeChange) {
                            Get.snackbar(AppStrings.error.tr,
                                AppStrings.sellerBuyerConflict.tr);
                          } else if (plutoEditViewModel.invoiceRecord
                              .where(
                                (element) => element.invRecId != null,
                          )
                              .isEmpty) {
                            Get.snackbar(AppStrings.error,
                                AppStrings.addItemsToInvoiceError);
                          } else if (plutoEditViewModel.invoiceRecord.isEmpty) {
                            Get.snackbar(AppStrings.error.tr,
                                AppStrings.emptyProducts.tr);
                          } else {
                            checkPermissionForOperation(
                                AppConstants.roleUserUpdate,
                                AppConstants.roleViewInvoice)
                                .then((value) async {
                              if (value) {
                                controller
                                    .initCodeList(AppConstants.salleTypeId);
                                controller.initModel
                                  ..invRecords = plutoEditViewModel
                                      .handleSaveAll(withOutProud: false)
                                  ..patternId = AppConstants.salleTypeId
                                  ..invCode = controller.getNextCodeInv()
                                  ..invFullCode =
                                      "مبيعات : ${controller.getNextCodeInv()}"
                                  ..entryBondRecord = []
                                  ..bondDescription = '';
                                globalController
                                    .updateGlobalInvoice(controller.initModel);
                                Get.back();
                              }
                            });
                          }
                        },
                        iconData: Icons.done_all,
                        color: Colors.green,
                      ),
                    if (controller.initModel.invId != null) ...[
                      AppButton(
                        iconData: Icons.print_outlined,
                        title: AppStrings.print.tr,
                        onPressed: () async {
                          plutoEditViewModel.handleSaveAll(
                              withOutProud: patternModel!.patFullName ==
                                  "مبيعات بدون اصل");

                          checkPermissionForOperation(
                              AppConstants.roleUserAdmin,
                              AppConstants.roleViewInvoice)
                              .then((value) async {
                            if (value) {
                              PrintViewModel printViewModel =
                              Get.find<PrintViewModel>();
                              printViewModel
                                  .printFunction(invoiceController.initModel);
                            }
                          });
                        },
                      ),
                      AppButton(
                          title: "E-Invoice",
                          onPressed: () {
                            showEInvoiceDialog(
                                mobileNumber:
                                controller.initModel.invMobileNumber ?? "",
                                invId: controller.initModel.invId!);
                          },
                          iconData: Icons.link),
                      if (screenViewModel.openedScreen[widget.billId] == null)
                        AppButton(
                          iconData: Icons.delete_outline,
                          color: Colors.red,
                          title: AppStrings.delete.tr,
                          onPressed: () async {
                            confirmDeleteWidget().then((value) {
                              if (value) {
                                checkPermissionForOperation(
                                    AppConstants.roleUserDelete,
                                    AppConstants.roleViewInvoice)
                                    .then((value) async {
                                  if (value) {
                                    globalController.deleteGlobal(
                                        invoiceController.initModel);
                                    Get.back();
                                  }
                                });
                              }
                            });
                          },
                        )
                    ]
                  ],
                  if (patternModel!.patName ==
                      AppConstants.invoiceTypeSalesWithPartner ||
                      controller.selectedPayType == AppConstants.invPayTypeDue)
                    AppButton(
                      iconData: Icons.more_horiz_outlined,
                      title: AppStrings.more.tr,
                      onPressed: () async {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) =>
                              Dialog(
                                backgroundColor: backGroundColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 200,
                                    height: 150,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Center(
                                            child: Text(
                                              AppStrings.options.tr,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            )),
                                        const SizedBox(height: 15),
                                        Text(AppStrings.firstPayment.tr),
                                        const SizedBox(height: 5),
                                        Expanded(
                                          child: CustomTextFieldWithoutIcon(
                                            controller: invoiceController
                                                .firstPayController,
                                            onChanged: (text) =>
                                            invoiceController
                                                .firstPayController.text = text,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text(AppStrings.agree.tr),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        );
                      },
                    ),
                  if ((patternModel?.patName == "م. مبيع" ||
                      patternModel?.patName == "م. شراء"))
                    AppButton(
                      iconData: Icons.more_horiz_outlined,
                      title: AppStrings.more.tr,
                      onPressed: () async {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) =>
                              Dialog(
                                backgroundColor: backGroundColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: <Widget>[
                                      Text(
                                        AppStrings.returnInvoiceDetails.tr,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(height: 15),
                                      OptionTextWidget(
                                        title: AppStrings.invoiceNumber,
                                        controller:
                                        controller.invReturnCodeController,
                                        onSubmitted: (text) async {
                                          controller.invReturnCodeController
                                              .text =
                                              text;
                                        },
                                      ),
                                      const SizedBox(height: 5),
                                      OptionTextWidget(
                                        title: AppStrings.invoiceDateTitle,
                                        controller:
                                        controller.invReturnDateController,
                                        onSubmitted: (text) async {
                                          controller.invReturnDateController
                                              .text =
                                              getDateFromString(text);
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(AppStrings.agree.tr),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  GlobalModel _updateData(List<InvoiceRecordModel> record) {
    return GlobalModel(
        firstPay: double.tryParse(invoiceController.firstPayController.text),
        invReturnCode: invoiceController.invReturnCodeController.text,
        invReturnDate: invoiceController.invReturnDateController.text,
        invGiftAccount: invoiceController.initModel.invGiftAccount,
        invSecGiftAccount: invoiceController.initModel.invSecGiftAccount,
        invVatAccount: patternModel?.patType == AppConstants.invoiceTypeBuy
            ? getAccountIdFromText("استرداد ضريبة القيمة المضافة رأس الخيمة")
            : getAccountIdFromText("ضريبة القيمة المضافة رأس الخيمة"),
        invPayType: invoiceController.selectedPayType,
        invIsPaid:
        invoiceController.selectedPayType == AppConstants.invPayTypeDue
            ? getInvIsPay(patternModel!.patType!)
            : true,
        invPartnerCode: invoiceController.invPartnerCodeController.text,
        invDueDate:
        patternModel?.patType == AppConstants.invoiceTypeSalesWithPartner
            ? getDueDate(getPatNameFromId(widget.patternId))
            .toIso8601String()
            .split(".")[0]
            : invoiceController.invDueDateController,
        invDiscountRecord: /*invoiceController.discountRecords*/ [],
        invIsPending: invoiceController.initModel.invIsPending,
        // invVatAccount: getVatAccountFromPatternId(patternModel!.patId!),

        entryBondId: invoiceController.initModel.invId == null
            ? generateId(RecordType.entryBond)
            : invoiceController.initModel.entryBondId,
        entryBondCode: invoiceController.initModel.invId == null
            ? getNextEntryBondCode().toString()
            : invoiceController.initModel.entryBondCode,
        invRecords: record,
        patternId: patternModel!.patId!,
        invType: patternModel!.patType!,
        invTotal: Get.find<InvoicePlutoViewModel>().computeWithVatTotal(),
        invFullCode: invoiceController.initModel.invId == null
            ? "${patternModel!.patName!}: ${invoiceController.invCodeController
            .text}"
            : invoiceController.initModel.invFullCode,
        invId:
        invoiceController.initModel.invId ?? generateId(RecordType.invoice),
        invStorehouse:
        getStoreIdFromText(invoiceController.storeController.text),
        invSecStorehouse:
        getStoreIdFromText(invoiceController.storeNewController.text),
        invComment: invoiceController.noteController.text,
        invPrimaryAccount: getAccountIdFromText(
            invoiceController.primaryAccountController.text),
        invSecondaryAccount: getAccountIdFromText(
            invoiceController.secondaryAccountController.text),
        invCustomerAccount: invoiceController
            .invCustomerAccountController.text.isEmpty
            ? ""
            : getAccountIdFromText(
            invoiceController.invCustomerAccountController.text),
        invCode: "0" /* invoiceController.initModel.invId == null ? invoiceController.invCodeController.text : invoiceController.initModel.invCode*/,
        invSeller: getSellerIdFromText(invoiceController.sellerController.text),
        invDate: isEditDate ? invoiceController.dateController : DateTime
            .now()
            .toString()
            .split(".")
            .first,
        invMobileNumber: invoiceController.mobileNumberController.text,
        invTotalPartner: patternModel?.patType ==
            AppConstants.invoiceTypeSalesWithPartner
            ? patternModel?.patName == "م Tabby"
            ? Get.find<InvoicePlutoViewModel>().computeWithVatTotal() -
            (((Get.find<InvoicePlutoViewModel>().computeWithVatTotal() *
                (patternModel!.patPartnerRatio! / 100)) +
                patternModel!.patPartnerCommission!) * 1.05)
            : Get.find<InvoicePlutoViewModel>().computeWithVatTotal() -
            ((Get.find<InvoicePlutoViewModel>().computeWithVatTotal() *
                (patternModel!.patPartnerRatio! / 100)) +
                patternModel!.patPartnerCommission!)
            : 0,
        globalType: AppConstants.globalTypeInvoice);
  }
}

class AppButton extends StatelessWidget {
  const AppButton({super.key,
    required this.title,
    required this.onPressed,
    required this.iconData,
    this.color});

  final String title;
  final Color? color;
  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(color),
            shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))))),
        onPressed: onPressed,
        child: SizedBox(
          width: 100,
          height: AppConstants.constHeightTextField,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                // const Spacer(),
                Icon(
                  iconData,
                  size: 22,
                ),
              ],
            ),
          ),
        ));
  }
}
