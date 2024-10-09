import 'package:ba3_business_solutions/core/constants/app_strings.dart';
import 'package:ba3_business_solutions/core/shared/widgets/custom_pluto_with_edite.dart';
import 'package:ba3_business_solutions/core/shared/widgets/get_product_enter_short_cut.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../controller/invoice/invoice_view_model.dart';
import '../../../controller/print/print_view_model.dart';
import '../../../controller/user/user_management_model.dart';
import '../../../controller/warranty/warranty_pluto_view_model.dart';
import '../../../controller/warranty/warranty_view_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/shared/widgets/custom_pluto_short_cut.dart';
import '../../../core/utils/confirm_delete_dialog.dart';
import '../../../core/utils/date_picker.dart';
import '../../../model/global/global_model.dart';
import '../../../model/product/product_model.dart';
import '../../invoices/pages/New_Invoice_View.dart';
import '../../invoices/widget/qr_invoice.dart';

class WarrantyInvoiceView extends StatefulWidget {
  const WarrantyInvoiceView({super.key, required this.billId});

  final String billId;

  @override
  State<WarrantyInvoiceView> createState() => _WarrantyInvoiceViewState();
}

class _WarrantyInvoiceViewState extends State<WarrantyInvoiceView> {
  WarrantyViewModel invoiceController = Get.find<WarrantyViewModel>();
  WarrantyPlutoViewModel plutoEditViewModel =
      Get.find<WarrantyPlutoViewModel>();
  List<String> codeInvList = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (AppConstants.isNotTap) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  @override
  void initState() {
    if (widget.billId != "1") {
      invoiceController.buildInvInit(widget.billId);
      plutoEditViewModel.getRows(
          invoiceController.warrantyMap[widget.billId]?.invRecords?.toList() ??
              []);
    } else {
      invoiceController.getInit();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
              padding: const EdgeInsets.all(5),
              child: const Icon(
                Icons.close,
                color: Colors.red,
                size: 16,
              )),
        ),
        title: Text(widget.billId == "1"
            ? AppStrings.warrantyInvoice.tr
            : AppStrings.warrantyInvoiceDetails.tr),
        actions: [
          IconButton(
              onPressed: () async {
                var a = await Get.to(() => const QRScannerView(
                      whitUnknown: false,
                    )) as List<ProductModel>?;
                if (a == null) {
                } else {
                  plutoEditViewModel.addProductToInvoice(a);
                }
              },
              icon: const Icon(
                Icons.qr_code,
                color: Colors.black,
              )),
          const SizedBox(
            width: 20,
          ),
          if (checkPermission(
              AppConstants.roleUserAdmin, AppConstants.roleViewInvoice))
            SizedBox(
              height: AppConstants.constHeightTextField,
              child: Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            invoiceController.invNextOrPrev(
                                invoiceController.invCodeController.text, true);
                            setState(() {});
                          },
                          icon: const Icon(Icons.keyboard_double_arrow_right)),
                      // const Text("Invoice Code : "),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.10,
                          child: CustomTextFieldWithoutIcon(
                            isNumeric: true,
                            controller: invoiceController.invCodeController,
                            onSubmitted: (text) {
                              invoiceController.getInvByInvCode(
                                text,
                              );
                            },
                          )),
                      IconButton(
                          onPressed: () {
                            invoiceController.invNextOrPrev(
                                invoiceController.invCodeController.text,
                                false);

                            // invoiceController.nextInv(widget.patternModel!.patId!, invoiceController.invCodeController.text);
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
      body: GetBuilder<WarrantyViewModel>(builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: Wrap(
                  spacing: 20,
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 10,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 100,
                              child: Text(AppStrings.invoiceDateTitle.tr,
                                  style: TextStyle())),
                          Expanded(
                            child: DatePicker(
                              initDate: invoiceController.dateController,
                              onSubmit: (_) {
                                invoiceController.dateController =
                                    _.toString().split(".")[0];

                                controller.update();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              width: 100,
                              child: Text(AppStrings.mobileNumber.tr)),
                          Expanded(
                            child: CustomTextFieldWithoutIcon(
                                controller:
                                    invoiceController.mobileNumberController),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              AppStrings.customerName.tr,
                            ),
                          ),
                          Expanded(
                            child: CustomTextFieldWithIcon(
                                controller:
                                    invoiceController.customerNameController,
                                onSubmitted: (text) async {},
                                onIconPressed: () {}),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 100, child: Text(AppStrings.statement.tr)),
                          Expanded(
                            child: CustomTextFieldWithoutIcon(
                                controller: invoiceController.noteController),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              // flex: 3,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child:
                    GetBuilder<WarrantyPlutoViewModel>(builder: (controller) {
                  return CustomPlutoWithEdite(
                    evenRowColor: Colors.redAccent,
                    controller: controller,
                    shortCut: customPlutoShortcut(
                        GetProductEnterPlutoGridAction(
                            controller, "invRecProduct")),
                    onRowSecondaryTap: (event) {
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
                    onChanged: (PlutoGridOnChangedEvent event) async {},
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
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
                            controller.getInit();
                            controller.update();
                            plutoEditViewModel.getRows([]);
                            plutoEditViewModel.update();
                          }
                        });
                      },
                      iconData: Icons.create_new_folder_outlined),
                  if (controller.isNew)
                    AppButton(
                        title: AppStrings.addString.tr,
                        onPressed: () async {
                          plutoEditViewModel.handleSaveAll();

                          controller.updateInvoice(isAdd: true, done: false);
                        },
                        iconData: Icons.add_chart_outlined),
                  if (controller.isNew == false) ...[
                    AppButton(
                        title: AppStrings.edit.tr,
                        onPressed: () async {
                          plutoEditViewModel.handleSaveAll();
                          checkPermissionForOperation(
                                  AppConstants.roleUserUpdate,
                                  AppConstants.roleViewInvoice)
                              .then((value) async {
                            if (value) {
                              controller.updateInvoice(
                                  isAdd: false, done: false);
                            }
                          });
                        },
                        iconData: Icons.edit_outlined),
                    if (!(controller.initModel.done ?? true))
                      AppButton(
                        iconData: Icons.done_all,
                        color: Colors.green,
                        title: AppStrings.delivery.tr,
                        onPressed: () async {
                          plutoEditViewModel.handleSaveAll();

                          controller.updateInvoice(isAdd: false, done: true);
                        },
                      ),
                    AppButton(
                      iconData: Icons.print_outlined,
                      title: AppStrings.print.tr,
                      onPressed: () async {
                        plutoEditViewModel.handleSaveAll();

                        PrintViewModel printViewModel =
                            Get.find<PrintViewModel>();
                        printViewModel.printFunction(GlobalModel(),
                            warrantyModel: controller.initModel);
                      },
                    ),
                    AppButton(
                        title: "E-Invoice",
                        onPressed: () {
                          showEInvoiceDialog(
                              mobileNumber:
                                  controller.initModel.customerPhone ?? "",
                              invId: controller.initModel.invId!);
                        },
                        iconData: Icons.link),
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
                                controller.deleteInvoice();
                                Get.back();
                              }
                            });
                          }
                        });
                      },
                    )
                  ]
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
