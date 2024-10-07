// import 'package:ba3_business_solutions/Const/const.dart';
// import 'package:ba3_business_solutions/controller/account_view_model.dart';
// import 'package:ba3_business_solutions/controller/entry_bond_view_model.dart';
// import 'package:ba3_business_solutions/controller/global_view_model.dart';
// import 'package:ba3_business_solutions/controller/print_view_model.dart';
// import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
// import 'package:ba3_business_solutions/controller/store_view_model.dart';
// import 'package:ba3_business_solutions/model/Pattern_model.dart';
// import 'package:ba3_business_solutions/model/account_model.dart';
// import 'package:ba3_business_solutions/model/global_model.dart';
// import 'package:ba3_business_solutions/model/product_model.dart';
// import 'package:ba3_business_solutions/model/store_model.dart';
// import 'package:ba3_business_solutions/utils/confirm_delete_dialog.dart';
// import 'package:ba3_business_solutions/utils/date_picker.dart';
// import 'package:ba3_business_solutions/view/entry_bond/entry_bond_details_view.dart';
// import 'package:ba3_business_solutions/view/invoices/Controller/Screen_View_Model.dart';
// import 'package:ba3_business_solutions/view/invoices/widget/qr_invoice.dart';
// import 'package:ba3_business_solutions/view/accounts/widget/account_details.dart';
// import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
// import 'package:ba3_business_solutions/view/sellers/add_seller.dart';
// import 'package:ba3_business_solutions/view/stores/add_store.dart';
// import 'package:bitsdojo_window/bitsdojo_window.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import '../../controller/invoice_view_model.dart';
// import '../../controller/pattern_model_view.dart';
// import '../../controller/user_management_model.dart';
// import '../../main.dart';
// import '../../model/invoice_record_model.dart';
// import '../../utils/generate_id.dart';
// import '../widget/CustomWindowTitleBar.dart';
//
// class InvoiceView extends StatefulWidget {
//   InvoiceView({Key? key, required this.billId, required this.patternId, this.recentScreen = false}) : super(key: key);
//   final String billId;
//   final String patternId;
//   late final PatternModel? patternModel;
//   final bool recentScreen;
//
//   @override
//   State<InvoiceView> createState() => _InvoiceViewState();
// }
//
// class _InvoiceViewState extends State<InvoiceView> {
//   final invoiceController = Get.find<InvoiceViewModel>();
//   final globalController = Get.find<GlobalViewModel>();
//   final accountController = Get.find<AccountViewModel>();
//   final storeController = Get.find<StoreViewModel>();
//   ScreenViewModel screenViewModel = Get.find<ScreenViewModel>();
//   final _formKey = GlobalKey<FormState>();
//
//   List<String> codeInvList = [];
//
//   late Map<String, double> columnWidths = {'id': double.nan, 'product': double.nan, 'quantity': double.nan, 'subTotal': double.nan, 'total': double.nan, 'gift': double.nan};
//   String? selectedPayType;
//   String typeBill = Const.invoiceTypeSales;
//   bool isEditDate = false;
//
//   @override
//   void initState() {
//     if (widget.recentScreen) {
//       widget.patternModel = invoiceController.patternController.patternModel[widget.patternId];
//       invoiceController.initModel = screenViewModel.openedScreen[widget.billId]!;
//       // invoiceController.buildInvInit(false, widget.billId);
//       invoiceController.buildInvInitRecent(screenViewModel.openedScreen[widget.billId]!);
//
//       selectedPayType = invoiceController.initModel.invPayType;
//     } else if (widget.billId != "1") {
//       widget.patternModel = invoiceController.patternController.patternModel[invoiceController.invoiceModel[widget.billId]!.patternId!];
//       invoiceController.buildInvInit(true, widget.billId);
//       selectedPayType = invoiceController.initModel.invPayType;
//     } else {
//       widget.patternModel = invoiceController.patternController.patternModel[widget.patternId];
//       invoiceController.getInit(widget.patternModel!.patId!);
//       selectedPayType = Const.invPayTypeDue;
//
//       // globalController.dateController = DateTime.now().toString().split(" ")[0];
//     }
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // print(widget.patternModel!.toJson());
//     return Column(
//       children: [
//         const CustomWindowTitleBar(),
//         Expanded(
//           child: Directionality(
//             textDirection: TextDirection.rtl,
//             child: Scaffold(
//               appBar: AppBar(
//                 leadingWidth: 100,
//                 leading: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         screenViewModel.openedScreen.removeWhere(
//                           (key, value) => key == _updateData(invoiceController.records).invId||key == widget.billId,
//                         );
//                         screenViewModel.update();
//
//                         Get.back();
//                       },
//                       child: Container(
//                           padding: const EdgeInsets.all(5),
//                           decoration: BoxDecoration(color: Colors.red.shade800, shape: BoxShape.circle),
//                           child: const Icon(
//                             Icons.close,
//                             color: Colors.white,
//                             size: 16,
//                           )),
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//
//                         if (invoiceController.records.first.invRecProduct != null && _updateData(invoiceController.records).invIsPending == null) {
//                           screenViewModel.openedScreen[widget.billId=="1"?_updateData(invoiceController.records).invId!:widget.billId] = _updateData(invoiceController.records);
//                           screenViewModel.update();
//                         }
//
//                         Get.back();
//                       },
//                       child: Container(
//                           padding: const EdgeInsets.all(5),
//                           decoration: BoxDecoration(color: Colors.blue.shade800, shape: BoxShape.circle),
//                           child: const Icon(
//                             Icons.download_outlined,
//                             size: 16,
//                             color: Colors.white,
//                           )),
//                     ),
//
//                     /*             IconButton(
//                       onPressed: () {
//                         screenViewModel.openedScreen.removeWhere(
//                               (key, value) => key == _updateData(invoiceController.records).invCode,
//                         );
//                         screenViewModel.update();
//
//                         Get.back();
//                       },
//                       icon:  const Icon(Icons.close,color: Colors.red,),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         if (invoiceController.records.first.invRecProduct != null&&_updateData(invoiceController.records).invIsPending==null) {
//                           screenViewModel.openedScreen[_updateData(invoiceController.records).invCode!] = _updateData(invoiceController.records);
//                           screenViewModel.update();
//                         }
//
//                         Get.back();
//                       },
//                       icon:  const Icon(Icons.minimize),
//                     ),*/
//                   ],
//                 ),
//                 title: Text(widget.billId == "1" ? "فاتورة ${widget.patternModel?.patName ?? ""}" : "تفاصيل فاتورة " + (widget.patternModel?.patName ?? "")),
//                 actions: [
//                   IconButton(
//                       onPressed: () async {
//                         var a = await Get.to(() => const QRScannerView()) as List<ProductModel>?;
//                         if (a == null) {
//                         } else {
//                           invoiceController.addProductToInvoice(a);
//                         }
//                       },
//                       icon: const Icon(
//                         Icons.qr_code,
//                         color: Colors.black,
//                       )),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Row(
//                           children: [
//                             const Text("تاريخ الفاتورة : ", style: TextStyle()),
//                             SizedBox(
//                               //  width: Get.width * 0.10,
//                               child: GetBuilder<InvoiceViewModel>(builder: (controller) {
//                                 return DatePicker(
//                                   initDate: invoiceController.dateController,
//                                   onSubmit: (_) {
//                                     invoiceController.dateController = _.toString().split(".")[0];
//                                     isEditDate = true;
//                                     controller.update();
//                                   },
//                                 );
//                               }),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         if (checkPermission(Const.roleUserAdmin, Const.roleViewInvoice))
//                           Row(
//                             children: [
//                               IconButton(
//                                   onPressed: () {
//                                     invoiceController.invNextOrPrev(widget.patternModel!.patId!, invoiceController.invCodeController.text,true);
//                                   },
//                                   icon: const Icon(Icons.keyboard_double_arrow_right)),
//                               // const Text("Invoice Code : "),
//                               SizedBox(width: Get.width * 0.10, child: customTextFieldWithoutIcon(invoiceController.invCodeController, true)),
//                               IconButton(
//                                   onPressed: () {
//                                     invoiceController.nextInv(widget.patternModel!.patId!, invoiceController.invCodeController.text);
//                                   },
//                                   icon: const Icon(Icons.keyboard_double_arrow_left)),
//                             ],
//                           ),
//                       ],
//                     ),
//                     // child: Row(
//                     //   children: [
//                     //     SizedBox(width: Get.width * 0.30, child: customTextFieldWithoutIcon(TextEditingController(text:invoiceController.initModel.invId), false)),
//                     //     const SizedBox(
//                     //       width: 10,
//                     //     ),
//                     //     SizedBox(width: Get.width * 0.30, child: customTextFieldWithoutIcon(TextEditingController(text:invoiceController.initModel.bondId), false)),
//                     //   ],
//                     // ),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                 ],
//               ),
//               body: GetBuilder<InvoiceViewModel>(builder: (controller) {
//                 return ListView(
//                   physics: const ClampingScrollPhysics(),
//                   children: [
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     if (widget.patternModel!.patType != Const.invoiceTypeChange)
//                       Column(
//                         children: [
//                           Wrap(
//                             spacing: 20,
//                             alignment: WrapAlignment.spaceBetween,
//                             runSpacing: 20,
//                             children: [
//                               SizedBox(
//                                 width: Get.width * 0.35,
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const Text(
//                                       "المدين : ",
//                                     ),
//                                     if (widget.patternModel!.patType == Const.invoiceTypeSales)
//                                       SizedBox(
//                                         width: Get.width * 0.30,
//                                         child: customTextFieldWithIcon(invoiceController.secondaryAccountController, (text) async {
//                                           invoiceController.secondaryAccountController.text = await getAccountComplete(invoiceController.secondaryAccountController.text);
//                                           // invoiceController.getAccountComplete();
//                                           invoiceController.changeSecAccount();
//                                         }, onIconPressed: () {
//                                           AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == invoiceController.secondaryAccountController.text);
//                                           if (_ != null) {
//                                             Get.to(AccountDetails(modelKey: _.accId!));
//                                           }
//                                         }),
//                                       )
//                                     else if (widget.patternModel!.patType == Const.invoiceTypeBuy)
//                                       SizedBox(
//                                         width: Get.width * 0.10,
//                                         child: customTextFieldWithoutIcon(
//                                           invoiceController.secondaryAccountController,
//                                           false,
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const Text("المستودع : "),
//                                   SizedBox(
//                                     width: Get.width * 0.15,
//                                     child: Form(
//                                       key: _formKey,
//                                       child: customTextFieldWithIcon(invoiceController.storeController, (text) {
//                                         invoiceController.getStoreComplete();
//                                       }, onIconPressed: () {
//                                         StoreModel? _ = storeController.storeMap.values.toList().firstWhereOrNull((element) => element.stName == invoiceController.storeController.text);
//                                         if (_ != null) {
//                                           Get.to(AddStore(oldKey: _.stId!));
//                                         }
//                                       }),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const Text("رقم الجوال : "),
//                                   SizedBox(
//                                     width: Get.width * 0.15,
//                                     child: customTextFieldWithoutIcon(invoiceController.mobileNumberController, true),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const Text("حساب العميل : "),
//                                   SizedBox(
//                                     width: Get.width * 0.15,
//                                     child: customTextFieldWithIcon(invoiceController.invCustomerAccountController, (text) async {
//                                       invoiceController.invCustomerAccountController.text = await getAccountComplete(invoiceController.invCustomerAccountController.text);
//                                     }, onIconPressed: () {
//                                       AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == invoiceController.invCustomerAccountController.text);
//                                       if (_ != null) {
//                                         Get.to(AccountDetails(modelKey: _.accId!));
//                                       }
//                                     }),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const Text(
//                                     "البائع : ",
//                                   ),
//                                   SizedBox(
//                                     width: Get.width * 0.15,
//                                     child: customTextFieldWithIcon(invoiceController.sellerController, (text) async {
//                                       //   globalController.getAccountComplete();
//                                       var seller = await getSellerComplete(text);
//                                       // globalController.changeSecAccount();
//                                       invoiceController.initModel.invSeller = seller;
//                                       invoiceController.sellerController.text = seller;
//                                     }, onIconPressed: () {
//                                       AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == invoiceController.secondaryAccountController.text);
//                                       if (_ != null) {
//                                         Get.to(AddSeller(oldKey: _.accId!));
//                                       }
//                                     }),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const Text(
//                                     "نوع الفاتورة" + ": ",
//                                     textDirection: TextDirection.rtl,
//                                   ),
//                                   Container(
//                                       height: 50,
//                                       width: Get.width * 0.15,
//                                       decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black38), borderRadius: BorderRadius.circular(8)),
//                                       child: DropdownButton(
//                                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                                         underline: const SizedBox(),
//                                         value: selectedPayType,
//                                         isExpanded: true,
//                                         onChanged: (_) {
//                                           selectedPayType = _!;
//                                           setState(() {});
//                                         },
//                                         items: [Const.invPayTypeDue, Const.invPayTypeCash]
//                                             .map((e) => DropdownMenuItem(
//                                                   value: e,
//                                                   child: SizedBox(
//                                                       width: double.infinity,
//                                                       child: Text(
//                                                         getInvPayTypeFromEnum(e),
//                                                         textDirection: TextDirection.rtl,
//                                                       )),
//                                                 ))
//                                             .toList(),
//                                       )),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           // const SizedBox(height: 40,),
//                           // Wrap(
//                           //   spacing: 40,
//                           //   alignment: WrapAlignment.spaceBetween,
//                           //   runSpacing: 40,
//                           //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           //   children: [
//                           //     /* SizedBox(
//                           //       width: Get.width * 0.35,
//                           //       child: Row(
//                           //         children: [
//                           //           const Text("الدائن : ", style: TextStyle()),
//                           //           // color: globalController.initModel.invType == Const.invoiceTypeSales
//                           //           //     ? Colors.redAccent
//                           //           //     : Colors.greenAccent)),
//                           //           if (widget.patternModel!.patType == Const.invoiceTypeSales)
//                           //             SizedBox(
//                           //               width: Get.width * 0.10,
//                           //               child: customTextFieldWithoutIcon(
//                           //                 invoiceController.primaryAccountController,
//                           //                 false,
//                           //               ),
//                           //             )
//                           //           else if (widget.patternModel!.patType == Const.invoiceTypeBuy)
//                           //             SizedBox(
//                           //               width: Get.width * 0.30,
//                           //               child: customTextFieldWithIcon(invoiceController.primaryAccountController, (text) async {
//                           //                 invoiceController.primaryAccountController.text = await getAccountComplete(invoiceController.primaryAccountController.text);
//                           //                 // invoiceController.getAccountComplete();
//                           //                 invoiceController.changeSecAccount();
//                           //               }, onIconPressed: () {
//                           //                 AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == invoiceController.primaryAccountController.text);
//                           //                 if (_ != null) {
//                           //                   Get.to(AccountDetails(modelKey: _.accId!));
//                           //                 }
//                           //               }),
//                           //             ),
//                           //         ],
//                           //       ),
//                           //     ),*/
//                           //
//                           //     Row(
//                           //       mainAxisSize: MainAxisSize.min,
//                           //       children: [
//                           //         const Text("رقم الجوال : "),
//                           //         SizedBox(
//                           //           width: Get.width * 0.15,
//                           //
//                           //           child: customTextFieldWithoutIcon(invoiceController.mobileNumberController, true),
//                           //         ),
//                           //       ],
//                           //     ),
//                           //
//                           //     Row(
//                           //       mainAxisSize: MainAxisSize.min,
//                           //
//                           //       children: [
//                           //
//                           //         const Text("حساب العميل : "),
//                           //         SizedBox(
//                           //           width: Get.width * 0.15,
//                           //           child: customTextFieldWithIcon(invoiceController.invCustomerAccountController, (text) async {
//                           //             invoiceController.invCustomerAccountController.text = await getAccountComplete(invoiceController.invCustomerAccountController.text);
//                           //           }, onIconPressed: () {
//                           //             AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == invoiceController.invCustomerAccountController.text);
//                           //             if (_ != null) {
//                           //               Get.to(AccountDetails(modelKey: _.accId!));
//                           //             }
//                           //           }),
//                           //         ),
//                           //       ],
//                           //     ),
//                           //
//                           //     Row(
//                           //       mainAxisSize: MainAxisSize.min,
//                           //
//                           //       children: [
//                           //         const Text(
//                           //           "البائع : ",
//                           //         ),
//                           //         SizedBox(
//                           //           width: Get.width * 0.15,
//                           //           child: customTextFieldWithIcon(invoiceController.sellerController, (text) async {
//                           //             //   globalController.getAccountComplete();
//                           //             var seller = await getSellerComplete(text);
//                           //             // globalController.changeSecAccount();
//                           //             invoiceController.initModel.invSeller = seller;
//                           //             invoiceController.sellerController.text = seller;
//                           //           }, onIconPressed: () {
//                           //             AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == invoiceController.secondaryAccountController.text);
//                           //             if (_ != null) {
//                           //               Get.to(AddSeller(oldKey: _.accId!));
//                           //             }
//                           //           }),
//                           //         ),
//                           //       ],
//                           //     ),
//                           //     Row(
//                           //       mainAxisSize: MainAxisSize.min,
//                           //
//                           //       children: [
//                           //         const Text(
//                           //           "نوع الفاتورة" + ": ",
//                           //           textDirection: TextDirection.rtl,
//                           //         ),
//                           //         Container(
//                           //             height: 50,
//                           //             width: Get.width * 0.15,
//                           //             decoration: BoxDecoration(
//                           //                 color: Colors.white,
//                           //                 border: Border.all(color: Colors.black38), borderRadius: BorderRadius.circular(8)),
//                           //             child: DropdownButton(
//                           //               padding: const EdgeInsets.symmetric(horizontal: 8),
//                           //               underline: const SizedBox(),
//                           //               value: selectedPayType,
//                           //               isExpanded: true,
//                           //               onChanged: (_) {
//                           //                 selectedPayType = _!;
//                           //                 setState(() {});
//                           //               },
//                           //               items: [ Const.invPayTypeDue,Const.invPayTypeCash]
//                           //                   .map((e) => DropdownMenuItem(
//                           //                         value: e,
//                           //                         child: SizedBox(
//                           //                             width: double.infinity,
//                           //                             child: Text(
//                           //                               getInvPayTypeFromEnum(e),
//                           //                               textDirection: TextDirection.rtl,
//                           //                             )),
//                           //                       ))
//                           //                   .toList(),
//                           //             )),
//                           //       ],
//                           //     ),
//                           //
//                           //   ],
//                           // ),
//                           // const SizedBox(
//                           //   height: 40,
//                           // ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               const SizedBox(
//                                 width: 20,
//                               ),
//                               const Text("البيان"),
//                               const SizedBox(
//                                 width: 20,
//                               ),
//                               Expanded(
//                                 child: SizedBox(
//                                   height: 50,
//                                   child: customTextFieldWithoutIcon(invoiceController.noteController, true),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 20,
//                               ),
//                             ],
//                           ),
//                         ],
//                       )
//                     else
//                       SizedBox(
//                         height: 175,
//                         child: Column(
//                           children: [
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Row(
//                                   children: [
//                                     const Text('المستودع القديم :'),
//                                     const SizedBox(
//                                       width: 15,
//                                     ),
//                                     SizedBox(
//                                       width: Get.width * 0.15,
//                                       child: customTextFieldWithIcon(invoiceController.storeController, (text) {
//                                         invoiceController.getStoreComplete();
//                                       }, onIconPressed: () {
//                                         StoreModel? _ = storeController.storeMap.values.toList().firstWhereOrNull((element) => element.stName == invoiceController.storeController.text);
//                                         if (_ != null) {
//                                           Get.to(AddStore(oldKey: _.stId!));
//                                         }
//                                       }),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     const Text('المستودع الجديد :'),
//                                     SizedBox(
//                                       width: 15,
//                                     ),
//                                     SizedBox(
//                                       width: Get.width * 0.15,
//                                       child: customTextFieldWithIcon(invoiceController.storeNewController, (text) {
//                                         invoiceController.getStoreComplete();
//                                       }, onIconPressed: () {
//                                         StoreModel? _ = storeController.storeMap.values.toList().firstWhereOrNull((element) => element.stName == invoiceController.storeNewController.text);
//                                         if (_ != null) {
//                                           Get.to(AddStore(oldKey: _.stId!));
//                                         }
//                                       }),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 const Text("البيان"),
//                                 SizedBox(
//                                   height: 35,
//                                   width: Get.width * 0.7,
//                                   child: customTextFieldWithoutIcon(invoiceController.noteController, true),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                           ],
//                         ),
//                       ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       margin: const EdgeInsets.all(0),
//                       height: 250,
//                       child: SfDataGrid(
//                         horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
//                         verticalScrollPhysics: const ClampingScrollPhysics(),
//                         source: invoiceController.invoiceRecordSource,
//                         // tableSummaryRows: [
//                         //   GridTableSummaryRow(color: Colors.blueGrey, showSummaryInRow: true, title: 'Total : {Total} AED', columns: [const GridSummaryColumn(name: 'Total', columnName: Const.rowInvTotal, summaryType: GridSummaryType.sum)], position: GridTableSummaryRowPosition.bottom),
//                         // ],
//                         columns: [
//                           GridColumn(
//                               allowEditing: false,
//                               width: 50,
//                               columnName: Const.rowInvId,
//                               label: InkWell(
//                                 onSecondaryTapDown: (_) {
//                                   showMenu(
//                                     context: Get.context!,
//                                     position: RelativeRect.fromLTRB(
//                                       _.globalPosition.dx,
//                                       _.globalPosition.dy,
//                                       _.globalPosition.dx + 1.0,
//                                       _.globalPosition.dy + 1.0,
//                                     ),
//                                     items: [
//                                       const PopupMenuItem(
//                                         value: "pressed",
//                                         child: Center(
//                                           child: Text(
//                                             "نسخ",
//                                             textDirection: TextDirection.rtl,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ).then((e) {
//                                     if (e == "pressed") {
//                                       controller.copyInvoice(controller.initModel);
//                                     }
//                                   });
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: const BorderRadius.only(topRight: Radius.circular(25)),
//                                     color: Colors.blue.shade700,
//                                   ),
//                                   alignment: Alignment.center,
//                                   child: const Text(
//                                     'الرقم',
//                                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               )),
//                           GridColumn(
//                               width: columnWidths['product']!,
//                               columnWidthMode: ColumnWidthMode.fill,
//                               columnName: Const.rowInvProduct,
//                               label: Container(
//                                 color: Colors.blue.shade700,
//                                 alignment: Alignment.center,
//                                 child: const Text(
//                                   'المادة',
//                                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               )),
//                           GridColumn(
//                               width: columnWidths['gift']!,
//                               columnName: Const.rowInvGift,
//                               label: Container(
//                                 color: Colors.blue.shade700,
//                                 alignment: Alignment.center,
//                                 child: const Text(
//                                   'الهدايا',
//                                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               )),
//                           GridColumn(
//                               width: columnWidths['quantity']!,
//                               columnName: Const.rowInvQuantity,
//                               label: Container(
//                                 color: Colors.blue.shade700,
//                                 alignment: Alignment.center,
//                                 child: const Text(
//                                   'الكمية',
//                                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               )),
//                           GridColumn(
//                               visible: widget.patternModel!.patType != Const.invoiceTypeChange,
//                               width: columnWidths['subTotal']!,
//                               columnName: Const.rowInvSubTotal,
//                               label: Container(
//                                 color: Colors.blue.shade700,
//                                 alignment: Alignment.center,
//                                 child: const Text(
//                                   'السعر الإفرادي',
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//                                 ),
//                               )),
//                           GridColumn(
//                               visible: widget.patternModel!.patType != Const.invoiceTypeChange,
//                               allowEditing: false,
//                               columnName: Const.rowInvVat,
//                               label: Container(
//                                 color: Colors.blue.shade700,
//                                 alignment: Alignment.center,
//                                 child: const Text(
//                                   'إفرادي الضريبة',
//                                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               )),
//                           GridColumn(
//                               visible: widget.patternModel!.patType != Const.invoiceTypeChange,
//                               allowEditing: true,
//                               columnName: Const.rowInvTotal,
//                               label: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.blue.shade700,
//                                 ),
//                                 alignment: Alignment.center,
//                                 child: const Text(
//                                   'المجموع',
//                                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               )),
//                           GridColumn(visible: false, allowEditing: false, columnName: Const.rowInvTotalVat, label: const Text('ID')),
//                         ],
//                         controller: invoiceController.dataGridController,
//                         columnWidthMode: ColumnWidthMode.none,
//                         allowColumnsResizing: true,
//
//                         gridLinesVisibility: GridLinesVisibility.both,
//                         headerGridLinesVisibility: GridLinesVisibility.both,
//                         allowEditing: true,
//                         navigationMode: GridNavigationMode.cell,
//                         selectionMode: SelectionMode.singleDeselect,
//                         editingGestureType: EditingGestureType.tap,
//
//                         allowSwiping: false,
//                         swipeMaxOffset: Get.width / 2,
//                         startSwipeActionsBuilder: (BuildContext context, DataGridRow row, int rowIndex) {
//                           return GestureDetector(
//                               onTap: () {
//                                 invoiceController.invoiceRecordSource.dataGridRows.removeAt(rowIndex);
//                                 invoiceController.records.removeAt(rowIndex);
//                                 invoiceController.invoiceRecordSource.updateDataGridSource();
//                               },
//                               child: Container(color: Colors.red, padding: const EdgeInsets.only(left: 30.0), alignment: Alignment.centerLeft, child: const Text('Delete', style: TextStyle(color: Colors.white))));
//                         },
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     if (widget.patternModel!.patType != Const.invoiceTypeChange)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               "الحسميات و الاضافات",
//                               style: TextStyle(
//                                 fontSize: 25,
//                               ),
//                             ),
//                           ),
//                           Container(
//                               margin: const EdgeInsets.all(0),
//                               child: SizedBox(
//                                 height: 150,
//                                 child: SfDataGrid(
//                                   horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
//                                   verticalScrollPhysics: const ClampingScrollPhysics(),
//                                   source: invoiceController.invoiceDiscountRecordSource,
//                                   // tableSummaryRows: [
//                                   //   GridTableSummaryRow(color: Colors.blueGrey, showSummaryInRow: true, title: 'Total : {Total} AED', columns: [const GridSummaryColumn(name: 'Total', columnName: Const.rowInvTotal, summaryType: GridSummaryType.sum)], position: GridTableSummaryRowPosition.bottom),
//                                   // ],
//                                   columns: [
//                                     GridColumn(
//                                         allowEditing: false,
//                                         width: 50,
//                                         columnName: Const.rowInvDiscountId,
//                                         label: Container(
//                                           decoration: const BoxDecoration(
//                                             borderRadius: BorderRadius.only(topRight: Radius.circular(25)),
//                                             color: Colors.grey,
//                                           ),
//                                           alignment: Alignment.center,
//                                           child: const Text(
//                                             'الرقم',
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         )),
//                                     GridColumn(
//                                         width: columnWidths['product']!,
//                                         columnWidthMode: ColumnWidthMode.fill,
//                                         columnName: Const.rowInvDiscountAccount,
//                                         label: Container(
//                                           color: Colors.grey,
//                                           alignment: Alignment.center,
//                                           child: const Text(
//                                             'الحساب',
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         )),
//                                     GridColumn(
//                                         width: columnWidths['quantity']!,
//                                         columnName: Const.rowInvDisAddedTotal,
//                                         label: Container(
//                                           color: Colors.grey,
//                                           alignment: Alignment.center,
//                                           child: const Text(
//                                             "الإضافات",
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         )),
//                                     GridColumn(
//                                         width: columnWidths['subTotal']!,
//                                         columnName: Const.rowInvDisAddedPercentage,
//                                         label: Container(
//                                           color: Colors.grey,
//                                           alignment: Alignment.center,
//                                           child: const Text(
//                                             "النسبة المئوية للاضافات",
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         )),
//                                     GridColumn(
//                                         width: columnWidths['quantity']!,
//                                         columnName: Const.rowInvDisDiscountTotal,
//                                         label: Container(
//                                           color: Colors.grey,
//                                           alignment: Alignment.center,
//                                           child: const Text(
//                                             "الحسميات",
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         )),
//                                     GridColumn(
//                                         width: columnWidths['subTotal']!,
//                                         columnName: Const.rowInvDisDiscountPercentage,
//                                         label: Container(
//                                           color: Colors.grey,
//                                           alignment: Alignment.center,
//                                           child: const Text(
//                                             "النسبة المئوية للحسميات",
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         )),
//                                   ],
//                                   // controller: invoiceController.dataGridController,
//                                   columnWidthMode: ColumnWidthMode.none,
//                                   allowColumnsResizing: true,
//                                   onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
//                                     // setState(() {
//                                     //   columnWidths[details.column.columnName] =
//                                     //       details.width;
//                                     // });
//                                     return true;
//                                   },
//                                   // showColumnHeaderIconOnHover: true,
//                                   gridLinesVisibility: GridLinesVisibility.both,
//                                   headerGridLinesVisibility: GridLinesVisibility.both,
//                                   allowEditing: true,
//                                   navigationMode: GridNavigationMode.cell,
//                                   selectionMode: SelectionMode.singleDeselect,
//                                   editingGestureType: EditingGestureType.tap,
//                                   // onCellTap: (DataGridCellTapDetails details) {
//                                   //   globalController.onCellTap(details);
//                                   // },
//
//                                   allowSwiping: false,
//                                   swipeMaxOffset: Get.width / 2,
//                                   startSwipeActionsBuilder: (BuildContext context, DataGridRow row, int rowIndex) {
//                                     return GestureDetector(
//                                         onTap: () {
//                                           invoiceController.invoiceRecordSource.dataGridRows.removeAt(rowIndex);
//                                           invoiceController.records.removeAt(rowIndex);
//                                           invoiceController.invoiceRecordSource.updateDataGridSource();
//                                         },
//                                         child: Container(color: Colors.red, padding: const EdgeInsets.only(left: 30.0), alignment: Alignment.centerLeft, child: const Text('Delete', style: TextStyle(color: Colors.white))));
//                                   },
//                                 ),
//                               )),
//                         ],
//                       ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     if (widget.patternModel!.patType != Const.invoiceTypeChange)
//                       Wrap(
//                         // crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               color: Colors.blue.shade100,
//                               height: 50,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const SizedBox(width: 150, child: Text("المجموع بدون الضريبة")),
//                                     const SizedBox(
//                                       width: 20,
//                                     ),
//                                     Text(invoiceController.computeWithoutVatTotal().toStringAsFixed(2))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               color: Colors.blue.shade100,
//                               height: 50,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const SizedBox(width: 150, child: Text("مجموع الضريبة")),
//                                     const SizedBox(
//                                       width: 20,
//                                     ),
//                                     Text(invoiceController.computeVatTotal().toStringAsFixed(2))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               color: Colors.blue.shade200,
//                               height: 50,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const Text(
//                                       "المجموع مع الضريبة",
//                                       style: TextStyle(fontSize: 22),
//                                     ),
//                                     const SizedBox(
//                                       width: 20,
//                                     ),
//                                     Text(
//                                       invoiceController.computeAllTotal().toStringAsFixed(2),
//                                       style: TextStyle(fontSize: 22),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: SizedBox(
//                         height: 100,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               children: [
//                                 Flexible(
//                                   child: ElevatedButton(
//                                       child: const Text(
//                                         'فاتورة جديدة',
//                                         style: TextStyle(fontSize: 25),
//                                       ),
//                                       onPressed: () async {
//                                         checkPermissionForOperation(Const.roleUserWrite, Const.roleViewInvoice).then((value) {
//                                           if (value) {
//                                             controller.getInit(controller.initModel.patternId!);
//                                             controller.update();
//                                           }
//                                         });
//                                       }),
//                                 ),
//                                 const SizedBox(
//                                   height: 25,
//                                 ),
//                                 if (controller.initModel.invId == null || controller.initModel.invIsPending == null)
//                                   Flexible(
//                                     child: ElevatedButton(
//                                         // style: const ButtonStyle(
//                                         //     backgroundColor: MaterialStatePropertyAll(
//                                         //         Colors.indigo)),
//                                         child: const Text(
//                                           'إضافة فاتورة',
//                                           style: TextStyle(fontSize: 25),
//                                         ),
//                                         onPressed: () async {
//                                           if (invoiceController.checkInvCode()) {
//                                             Get.snackbar("فحص المطاييح", "هذا الرمز الرمز يرجى استخدام الرمز: ${invoiceController.getNextCodeInv()}");
//                                           } else if (!invoiceController.checkSellerComplete() && widget.patternModel!.patType != Const.invoiceTypeChange) {
//                                             Get.snackbar("فحص المطاييح", "هذا البائع غير موجود من قبل");
//                                           } else if (!invoiceController.checkStoreComplete()) {
//                                             Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
//                                           } else if (!invoiceController.checkStoreNewComplete() && widget.patternModel!.patType == Const.invoiceTypeChange) {
//                                             Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
//                                           } else if (!invoiceController.checkAccountComplete(invoiceController.secondaryAccountController.text) && widget.patternModel!.patType != Const.invoiceTypeChange) {
//                                             Get.snackbar("فحص المطاييح", "هذا الحساب غير موجود من قبل");
//                                           } else if (invoiceController.primaryAccountController.text.isEmpty && widget.patternModel!.patType != Const.invoiceTypeAdd && widget.patternModel!.patType != Const.invoiceTypeChange) {
//                                             Get.snackbar("خطأ تعباية", "يرجى كتابة حساب البائع");
//                                           } else if (invoiceController.primaryAccountController.text == invoiceController.secondaryAccountController.text && widget.patternModel!.patType != Const.invoiceTypeChange) {
//                                             Get.snackbar("خطأ تعباية", "لا يمكن تشابه البائع و المشتري");
//                                           } else if (invoiceController.records.length < 2) {
//                                             Get.snackbar("خطأ تعباية", "يرجى إضافة مواد الى الفاتورة");
//                                           } else if (invoiceController.checkAllRecordPrice() && widget.patternModel!.patType == Const.invoiceTypeSales) {
//                                             Get.snackbar("خطأ ", "تم البيع بأقل من الحد المسموح");
//                                           } else if (invoiceController.checkAllRecord()) {
//                                             Get.snackbar("خطأ تعباية", "بعض المنتجات فارغة");
//                                           } else if (invoiceController.checkAllDiscountRecords()) {
//                                             Get.snackbar("خطأ تعباية", "يرجى تصحيح الخطأ في الحسميات");
//                                           } else {
//                                             checkPermissionForOperation(Const.roleUserWrite, Const.roleViewInvoice).then((value) async {
//                                               if (value) {
//                                                 screenViewModel.openedScreen.removeWhere(
//                                                       (key, value) => key == _updateData(invoiceController.records).invId||key == widget.billId,
//                                                 );
//                                                 await invoiceController.computeTotal(invoiceController.records);
//                                                 globalController.addGlobalInvoice(_updateData(invoiceController.records));
//                                                 screenViewModel.update();
//                                               }
//                                             });
//                                           }
//                                         }),
//                                   ),
//                               ],
//                             ),
//                             if (controller.initModel.invId != null && controller.initModel.invIsPending != null)
//                               Column(
//                                 children: [
//                                   if (!(controller.initModel.invIsPending ?? true))
//                                     ElevatedButton(
//                                         child: const Text(
//                                           'عرض الأصل',
//                                           style: TextStyle(fontSize: 25),
//                                         ),
//                                         onPressed: () async {
//                                           Get.to(() => EntryBondDetailsView(
//                                                 oldId: controller.initModel.entryBondId,
//                                               ));
//                                         })
//                                   else
//                                     ElevatedButton(
//                                         style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green)),
//                                         child: const Text(
//                                           'موافقة على الفاتورة',
//                                           style: TextStyle(color: Colors.white, fontSize: 25),
//                                         ),
//                                         onPressed: () async {
//                                           // if (globalController.invCodeList.contains(
//                                           //     globalController.invCodeController.text)) {
//                                           if (!invoiceController.checkSellerComplete() && widget.patternModel!.patType != Const.invoiceTypeChange) {
//                                             Get.snackbar("فحص ", "هذا البائع غير موجود من قبل");
//                                           } else if (!invoiceController.checkStoreComplete()) {
//                                             Get.snackbar("فحص ", "هذا المستودع غير موجود من قبل");
//                                           } else if (!invoiceController.checkStoreNewComplete() && widget.patternModel!.patType == Const.invoiceTypeChange) {
//                                             Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
//                                           } else if (!invoiceController.checkAccountComplete(invoiceController.secondaryAccountController.text) && widget.patternModel!.patType != Const.invoiceTypeChange) {
//                                             Get.snackbar("فحص ", "هذا الحساب غير موجود من قبل");
//                                             // } else if (!invoiceController.checkAccountComplete(invoiceController.invCustomerAccountController.text)) {
//                                             //   Get.snackbar("فحص المطاييح", "هذا العميل غير موجود من قبل");
//                                           } else if (invoiceController.primaryAccountController.text.isEmpty && widget.patternModel!.patType != Const.invoiceTypeChange) {
//                                             Get.snackbar("خطأ ", "يرجى كتابة حساب البائع");
//                                           } else if (invoiceController.primaryAccountController.text == invoiceController.secondaryAccountController.text) {
//                                             Get.snackbar("خطأ ", "لا يمكن تشابه البائع و المشتري");
//                                           } else if (invoiceController.records.length < 2) {
//                                             Get.snackbar("خطأ ", "يرجى إضافة مواد الى الفاتورة+");
//                                           } else if (invoiceController.checkAllRecord()) {
//                                             Get.snackbar("خطأ ", "بعض المنتجات فارغة");
//                                           } else if (invoiceController.checkAllRecordPrice() && widget.patternModel!.patType == Const.invoiceTypeSales) {
//                                             Get.snackbar("خطأ ", "تم البيع بأقل من الحد المسموح");
//                                           } else if (invoiceController.checkAllDiscountRecords()) {
//                                             Get.snackbar("خطأ تعباية", "يرجى تصحيح الخطأ في الحسميات");
//                                           } else {
//                                             checkPermissionForOperation(Const.roleUserAdmin, Const.roleViewInvoice).then((value) async {
//                                               if (value) {
//                                                 await invoiceController.computeTotal(invoiceController.records);
//                                                 invoiceController.initModel.invIsPending = false;
//                                                 globalController.updateGlobalInvoice(_updateData(invoiceController.records));
//                                               }
//                                             });
//                                           }
//                                         }),
//                                   const Spacer(),
//                                   ElevatedButton(
//                                       child: const Text(
//                                         'تعديل الفاتورة',
//                                         style: TextStyle(fontSize: 25),
//                                       ),
//                                       onPressed: () async {
//                                         // if (globalController.invCodeList.contains(
//                                         //     globalController.invCodeController.text)) {
//                                         if (!invoiceController.checkSellerComplete() && widget.patternModel!.patType != Const.invoiceTypeChange) {
//                                           Get.snackbar("فحص ", "هذا البائع غير موجود من قبل");
//                                         } else if (!invoiceController.checkStoreComplete()) {
//                                           Get.snackbar("فحص ", "هذا المستودع غير موجود من قبل");
//                                         } else if (!invoiceController.checkStoreNewComplete() && widget.patternModel!.patType == Const.invoiceTypeChange) {
//                                           Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
//                                         } else if (!invoiceController.checkAccountComplete(invoiceController.secondaryAccountController.text) && widget.patternModel!.patType != Const.invoiceTypeChange) {
//                                           Get.snackbar("فحص ", "هذا الحساب غير موجود من قبل");
//                                           // } else if (!invoiceController.checkAccountComplete(invoiceController.invCustomerAccountController.text)) {
//                                           //   Get.snackbar("فحص المطاييح", "هذا العميل غير موجود من قبل");
//                                         } else if (invoiceController.primaryAccountController.text.isEmpty && widget.patternModel!.patType != Const.invoiceTypeChange) {
//                                           Get.snackbar("خطأ ", "يرجى كتابة حساب البائع");
//                                         } else if (invoiceController.primaryAccountController.text == invoiceController.secondaryAccountController.text && widget.patternModel!.patType != Const.invoiceTypeChange) {
//                                           Get.snackbar("خطأ ", "لا يمكن تشابه البائع و المشتري");
//                                         } else if (invoiceController.records
//                                             .where(
//                                               (element) => element.invRecId != null,
//                                             )
//                                             .isEmpty) {
//                                           Get.snackbar("خطأ ", "يرجى إضافة مواد الى الفاتورة+");
//                                         } else if (invoiceController.checkAllRecord()) {
//                                           Get.snackbar("خطأ ", "بعض المنتجات فارغة");
//                                         } else if (invoiceController.checkAllRecordPrice() && widget.patternModel!.patType == Const.invoiceTypeSales) {
//                                           Get.snackbar("خطأ ", "تم البيع بأقل من الحد المسموح");
//                                         } else if (invoiceController.checkAllDiscountRecords()) {
//                                           Get.snackbar("خطأ تعباية", "يرجى تصحيح الخطأ في الحسميات");
//                                         } else {
//                                           checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewInvoice).then((value) async {
//                                             if (value) {
//                                               await invoiceController.computeTotal(invoiceController.records);
//                                               globalController.updateGlobalInvoice(_updateData(invoiceController.records));
//                                               invoiceController.buildSource(invoiceController.initModel.invId!);
//                                               invoiceController.buildDiscountSource(invoiceController.initModel.invId!);
//                                             }
//                                           });
//                                         }
//                                       }),
//                                 ],
//                               ),
//                             if (controller.initModel.invId != null)
//                               Column(
//                                 children: [
//                                   ElevatedButton(
//                                     child: const Text(
//                                       'طباعة الفاتورة',
//                                       style: TextStyle(fontSize: 25),
//                                     ),
//                                     onPressed: () async {
//                                       checkPermissionForOperation(Const.roleUserAdmin, Const.roleViewInvoice).then((value) async {
//                                         if (value) {
//                                           PrintViewModel printViewModel = Get.find<PrintViewModel>();
//                                           printViewModel.printFunction(invoiceController.initModel);
//                                         }
//                                       });
//                                     },
//                                   ),
//                                   Spacer(),
//                                   if (screenViewModel.openedScreen[widget.billId] == null)
//                                     ElevatedButton(
//                                       style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.redAccent)),
//                                       child: const Text(
//                                         'حذف الفاتورة',
//                                         style: TextStyle(color: Colors.white, fontSize: 25),
//                                       ),
//                                       onPressed: () async {
//                                         confirmDeleteWidget().then((value) {
//                                           if (value) {
//                                             checkPermissionForOperation(Const.roleUserDelete, Const.roleViewInvoice).then((value) async {
//                                               if (value) {
//                                                 globalController.deleteGlobal(invoiceController.initModel);
//                                                 Get.back();
//                                               }
//                                             });
//                                           }
//                                         });
//                                       },
//                                     ),
//                                 ],
//                               )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   GlobalModel _updateData(List<InvoiceRecordModel> record) {
//     print(invoiceController.initModel.invId);
//     return GlobalModel(
//         invGiftAccount: invoiceController.initModel.invGiftAccount,
//         invSecGiftAccount: invoiceController.initModel.invSecGiftAccount,
//         invPayType: selectedPayType,
//         invDiscountRecord: invoiceController.discountRecords,
//         invIsPending: invoiceController.initModel.invIsPending,
//         invVatAccount: getVatAccountFromPatternId(widget.patternModel!.patId!),
//         entryBondId: invoiceController.initModel.invId == null ? generateId(RecordType.entryBond) : invoiceController.initModel.entryBondId,
//         entryBondCode: invoiceController.initModel.invId == null ? getNextEntryBondCode().toString() : invoiceController.initModel.entryBondCode,
//         invRecords: record,
//         patternId: widget.patternModel!.patId!,
//         invType: widget.patternModel!.patType!,
//         invTotal: invoiceController.total,
//         invFullCode: invoiceController.initModel.invId == null ? widget.patternModel!.patName! + ": " + invoiceController.invCodeController.text : invoiceController.initModel.invFullCode,
//         invId: invoiceController.initModel.invId ?? generateId(RecordType.invoice),
//         invStorehouse: getStoreIdFromText(invoiceController.storeController.text),
//         invSecStorehouse: getStoreIdFromText(invoiceController.storeNewController.text),
//         invComment: invoiceController.noteController.text,
//         invPrimaryAccount: getAccountIdFromText(invoiceController.primaryAccountController.text),
//         invSecondaryAccount: getAccountIdFromText(invoiceController.secondaryAccountController.text),
//         invCustomerAccount: invoiceController.invCustomerAccountController.text.isEmpty ? "" : getAccountIdFromText(invoiceController.invCustomerAccountController.text),
//         invCode: invoiceController.initModel.invId == null ? invoiceController.invCodeController.text : invoiceController.initModel.invCode,
//         invSeller: getSellerIdFromText(invoiceController.sellerController.text),
//         invDate: isEditDate ? invoiceController.dateController : DateTime.now().toString().split(".").first,
//         invMobileNumber: invoiceController.mobileNumberController.text,
//         globalType: Const.globalTypeInvoice);
//   }
// }
