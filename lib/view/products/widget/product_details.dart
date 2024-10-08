import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/core/utils/confirm_delete_dialog.dart';
import 'package:ba3_business_solutions/view/products/widget/add_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controller/invoice/Invoice_Pluto_Edit_View_Model.dart';
import '../../../controller/invoice/discount_pluto_edit_view_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/hive.dart';
import '../../../model/global/global_model.dart';
import '../../../model/product/product_model.dart';
import '../../../model/product/product_record_model.dart';
import '../../invoices/pages/New_Invoice_View.dart';

class ProductDetails extends StatefulWidget {
  final String? oldKey;

  const ProductDetails({super.key, this.oldKey});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<ProductRecordModel> editedProductRecord = [];
  ProductViewModel productController = Get.find<ProductViewModel>();

  @override
  void initState() {
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              productController.productDataMap[widget.oldKey!]!.prodName ?? ""),
          actions: [
            if (!productController.productDataMap[widget.oldKey!]!.prodIsGroup!)
              ElevatedButton(
                  onPressed: () {
                    Get.to(AddProduct(
                      oldKey: widget.oldKey,
                    ));
                  },
                  child: Text("بطاقة المادة")),
            SizedBox(
              width: 30,
            ),
            if ((productController.productDataMap[widget.oldKey!]!.prodRecord ??
                    [])
                .isEmpty)
              ElevatedButton(
                  onPressed: () {
                    confirmDeleteWidget().then((value) {
                      if (value) {
                        checkPermissionForOperation(AppConstants.roleUserDelete,
                                AppConstants.roleViewProduct)
                            .then((value) {
                          if (value) {
                            productController.deleteProduct(withLogger: true);
                            Get.back();
                          }
                        });
                      }
                    });
                  },
                  child: Text("حذف"))
            else
              ElevatedButton(
                  onPressed: () {
                    productController.exportProduct(widget.oldKey);
                  },
                  child: Text("جرد لحركات المادة")),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: productController.productDataMap.stream,
                    builder: (context, snapshot) {
                      // if (snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) {
                      //   return CircularProgressIndicator();
                      // } else {
                      return GetBuilder<ProductViewModel>(
                          builder: (controller) {
                        initPage();
                        // controller.initGrid(snapshot.data);
                        return SfDataGrid(
                          onCellTap: (DataGridCellTapDetails _) {
                            if (_.rowColumnIndex.rowIndex != 0) {
                              var invId = controller.recordDataSource
                                  .dataGridRows[_.rowColumnIndex.rowIndex - 1]
                                  .getCells()
                                  .firstWhere((element) =>
                                      element.columnName ==
                                      AppConstants.rowProductInvId)
                                  .value;
                              Get.to(
                                () => InvoiceView(
                                  billId: invId,
                                  patternId: '',
                                ),
                                binding: BindingsBuilder(() {
                                  Get.lazyPut(() => InvoicePlutoViewModel());
                                  Get.lazyPut(() => DiscountPlutoViewModel());
                                }),
                              );
                            }
                          },
                          source: controller.recordDataSource,
                          allowEditing: false,
                          selectionMode: SelectionMode.none,
                          editingGestureType: EditingGestureType.tap,
                          navigationMode: GridNavigationMode.cell,
                          columnWidthMode: ColumnWidthMode.fill,
                          columns: <GridColumn>[
                            GridColumnItem(
                                label: "المادة",
                                name: AppConstants.rowProductRecProduct),
                            GridColumnItem(
                                label: "النوع",
                                name: AppConstants.rowProductType),
                            GridColumnItem(
                                label: 'الكمية',
                                name: AppConstants.rowProductQuantity),
                            GridColumnItem(
                                label: 'الكمية',
                                name: AppConstants.rowProductTotal),
                            GridColumnItem(
                                label: 'التاريخ',
                                name: AppConstants.rowProductDate),
                            // GridColumnItem(
                            //     label: 'الرمز التسلسي للفاتورة',
                            //     name: Const.rowProductInvId),
                            GridColumn(
                                visible: false,
                                allowEditing: false,
                                columnName: AppConstants.rowProductInvId,
                                label: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25)),
                                    color: Colors.grey,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'ID',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                          ],
                        );
                      });
                      // }
                    }),
              ),

              //Spacer(),
              // ElevatedButton(
              //     onPressed: () {
              //       if (editedProduct.prodId == null) {
              //         productController.createProduct(editedProduct,
              //             withLogger: true);
              //         isEdit = false;
              //       } else {
              //         productController.updateProduct(editedProduct,
              //             withLogger: true);
              //         isEdit = false;
              //       }
              //     },
              //     child:
              //         Text(editedProduct.prodId == null ? "create" : "update"))
            ],
          ),
        ),
      ),
    );
  }

  GridColumn GridColumnItem({required label, name}) {
    return GridColumn(
        allowEditing: false,
        columnName: name,
        label: Container(
            color: Colors.blue.shade800,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              label.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            )));
  }

  initPage() async {
    if (widget.oldKey != null) {
      List<GlobalModel> globalModels = HiveDataBase.globalModelBox.values
          .where((element) => (element.invRecords
                  ?.where(
                    (element) => element.invRecProduct == widget.oldKey,
                  )
                  .isNotEmpty ??
              false))
          .toList();
      for (var globalModel in globalModels) {
        if (globalModel.invType != AppConstants.invoiceTypeChange) {
          await productController.initGlobalProduct(globalModel);
        }
      }

      productController.productModel = ProductModel.fromJson(
          productController.productDataMap[widget.oldKey!]!.toFullJson());
      editedProductRecord.clear();
      productController.productModel?.prodRecord?.forEach((element) {
        editedProductRecord.add(ProductRecordModel.fromJson(element.toJson()));
      });
      // productController.productModel?.prodRecord=editedProductRecord;
      // ProductModel _ = productController.productDataMap[widget.oldKey!]!;
    } else {
      productController.productModel = ProductModel();
      editedProductRecord = <ProductRecordModel>[];
    }
    productController.initProductPage(productController.productModel!);
    WidgetsFlutterBinding.ensureInitialized()
        .waitUntilFirstFrameRasterized
        .then(
      (value) {
        setState(() {});
      },
    );
  }
}
