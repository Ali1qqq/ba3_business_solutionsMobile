import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/view/invoices/New_Invoice_View.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../Const/const.dart';
import '../../../Dialogs/Search_Product_Group_Text_Dialog.dart';
import '../../../controller/user_management_model.dart';
import '../../../model/product_model.dart';
import '../../../model/product_record_model.dart';

class AddProduct extends StatefulWidget {
  final String? oldKey;
  final String? oldBarcode;
  final String? oldParent;

  const AddProduct({super.key, this.oldKey, this.oldBarcode, this.oldParent});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController customerPriceController = TextEditingController();
  TextEditingController wholePriceController = TextEditingController();
  TextEditingController retailPriceController = TextEditingController();
  TextEditingController costPriceController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  String? productType;

  // String? prodParentId;
  // bool prodIsRoot=false;
  late ProductModel editedProduct;
  List<ProductRecordModel> editedProductRecord = [];
  ProductViewModel productController = Get.find<ProductViewModel>();
  bool isEdit = false;
  bool hasVat = true;
  bool isGroup = false;

  @override
  void initState() {
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          if (isEdit) {
            Get.defaultDialog(actions: [
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: Text("تجاهل")),
              ElevatedButton(
                  onPressed: () {
                    checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewProduct).then((value) {
                      if (value) {
                        productController.updateProduct(editedProduct, withLogger: true);
                        Get.back();
                        Get.back();
                      }
                    });
                  },
                  child: const Text("تعديل")),
            ]);
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(editedProduct.prodName ?? "إضافة المادة"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (editedProduct.prodParentId != null) Text(getProductModelFromId(editedProduct.prodParentId)!.prodFullCode!),
                SizedBox(
                  width: Get.width,
                  child: Wrap(
                    runSpacing: 20,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      item(
                          text: "اسم المادة",
                          controller: nameController,
                          onChange: (_) {
                            print("object");
                            editedProduct.prodName = _;
                            isEdit = true;
                          }),
                      item(
                          text: "الرمز",
                          controller: codeController,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChange: (_) {
                            editedProduct.prodCode = _;
                            isEdit = true;
                          }),
                      item(
                          text: "سعر مستهلك",
                          controller: customerPriceController,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChange: (_) {
                            editedProduct.prodCustomerPrice = _;
                            isEdit = true;
                          }),
                      item(
                          text: "سعر الجملة",
                          controller: wholePriceController,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChange: (_) {
                            editedProduct.prodWholePrice = _;
                            isEdit = true;
                          }),
                      item(
                          text: "سعر مفرق",
                          controller: retailPriceController,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChange: (_) {
                            editedProduct.prodRetailPrice = _;
                            isEdit = true;
                          }),
                      item(
                          text: "سعر تكلفة",
                          controller: costPriceController,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChange: (_) {
                            editedProduct.prodCostPrice = _;
                            isEdit = true;
                          }),
                      item(
                          text: "اقل سعر مسموح",
                          controller: minPriceController,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChange: (_) {
                            editedProduct.prodMinPrice = _;
                            isEdit = true;
                          }),
                      item(
                          text: "الباركود",
                          controller: barcodeController,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChange: (_) {
                            editedProduct.prodBarcode = _;
                            isEdit = true;
                          }),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 100, child: Text("isLocal")),
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: StatefulBuilder(builder: (context, setstate) {
                            return Checkbox(
                                checkColor: Colors.white,
                                fillColor: WidgetStatePropertyAll(Colors.blue.shade800),
                                value: editedProduct.prodIsLocal!,
                                onChanged: (_) {
                                  setstate(() {
                                    editedProduct.prodIsLocal = _;
                                    isEdit = true;
                                  });
                                });
                          }),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(child: Text("حساب اب")),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Checkbox(
                            value: editedProduct.prodIsParent ?? false,
                            onChanged: (_) {
                              setState(() {
                                editedProduct.prodIsParent = _!;
                                editedProduct.prodParentId = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // SizedBox(height: 30,),
                // StatefulBuilder(builder: (context, setstate) {
                //   return Column(
                //     children: [
                //       Row(
                //         children: [
                //           Text("حساب مجموعة" ),
                //           SizedBox(
                //             width: 30,
                //             height: 30,
                //             child: Checkbox(
                //               value: editedProduct.prodIsGroup??false,
                //               onChanged: (_) {
                //                 setstate(() {
                //                   editedProduct.prodIsGroup = _!;
                //                 });
                //               },
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   );
                // }),
                // if(widget.oldKey != null)
                const SizedBox(
                  height: 20,
                ),
                // if(widget.oldKey != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width * .45,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 100, child: Text("الحساب الاب")),
                          SizedBox(
                            width: (Get.width * .45)-100,
                            child: IgnorePointer(
                              ignoring: editedProduct.prodIsParent ?? false,
                              child: Container(
                                  decoration: BoxDecoration(color: editedProduct.prodIsParent ?? false ? Colors.grey.shade700 : Colors.white, borderRadius: BorderRadius.circular(5)),
                                  child: CustomTextFieldWithoutIcon(
                                    controller: TextEditingController()..text=getProductNameFromId(editedProduct.prodParentId),
                                    onSubmitted: (productText) async {
                                      editedProduct.prodParentId = await searchProductGroupTextDialog(productText);
                                      setState(() {

                                      });
                                    },
                                  )
                                  /* DropdownButton(
                                  underline: const SizedBox(),
                                  value: editedProduct.prodParentId,
                                  items: productController.productDataMap.entries.toList().where((element) => element.value.prodIsGroup!).map((MapEntry<String, ProductModel> e) => DropdownMenuItem(value: e.key, child: Text(e.value.prodCode! + " - " + e.value.prodName!))).toList(),
                                  onChanged: (_) {
                                    setState(() {
                                      editedProduct.prodParentId = _.toString();
                                    });
                                  },
                                ),*/
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Get.width * .45,
                      child: Row(
                        children: [
                          const SizedBox(width: 100, child: Text("نوع الحساب")),
                          Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                              // height: 50,
                              width: 350,
                              child: StatefulBuilder(builder: (context, setstate) {
                                return DropdownButton(
                                    value: editedProduct.prodType,
                                    underline: const SizedBox(),
                                    isExpanded: true,
                                    items: [Const.productTypeStore, Const.productTypeService].map((e) => DropdownMenuItem(value: e, child: Text(getProductTypeFromEnum(e.toString())))).toList(),
                                    onChanged: (_) {
                                      setstate(() {
                                        editedProduct.prodType = _;
                                      });
                                    });
                              })),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    alignment: Alignment.center,
                    child: AppButton(
                      color: editedProduct.prodId == null ? null : Colors.green,
                      title: editedProduct.prodId == null ? "إضافة" : "تعديل",
                      onPressed: () {
                        if (checkInput()) {
                          if (editedProduct.prodId == null) {
                            checkPermissionForOperation(Const.roleUserWrite, Const.roleViewProduct).then((value) {
                              if (value) {
                                print("object");
                                productController.createProduct(editedProduct, withLogger: true);
                                isEdit = false;
                              }
                            });
                          } else {
                            checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewProduct).then((value) {
                              if (value) {
                                productController.updateProduct(editedProduct, withLogger: true);
                                isEdit = false;
                              }
                            });
                          }
                        }
                      },
                      iconData: editedProduct.prodId == null ? Icons.add : Icons.edit,
                    )

                    /*  ElevatedButton(

                      child: Text(editedProduct.prodId == null ? "إضافة" : "تعديل")),*/
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initPage() {
    if (widget.oldKey != null) {
      editedProduct = ProductModel.fromJson(productController.productDataMap[widget.oldKey!]!.toJson());
      productController.productModel = ProductModel.fromJson(productController.productDataMap[widget.oldKey!]!.toJson());
      editedProductRecord.clear();
      productController.productModel?.prodRecord?.forEach((element) {
        editedProductRecord.add(ProductRecordModel.fromJson(element.toJson()));
      });
      ProductModel _ = productController.productDataMap[widget.oldKey!]!;
      nameController.text = _.prodName!;
      codeController.text = _.prodCode!;
      customerPriceController.text = _.prodCustomerPrice ?? "0";
      wholePriceController.text = _.prodWholePrice ?? "0";
      retailPriceController.text = _.prodRetailPrice ?? "0";
      costPriceController.text = _.prodCostPrice ?? "0";
      minPriceController.text = _.prodMinPrice ?? "0";
      barcodeController.text = _.prodBarcode!;
      productType = _.prodType;
      isGroup = _.prodIsGroup ?? false;
      // editedProduct.prodParentId = _.prodParentId ;
      // editedProduct.prodIsParent=_.prodParentId==null;
      print(_.toFullJson());
    } else {
      editedProduct = ProductModel();
      productController.productModel = ProductModel();
      editedProductRecord = <ProductRecordModel>[];
      hasVat = true;
      isGroup = false;
      editedProduct.prodIsLocal = false;

      editedProduct.prodType = Const.productTypeStore;
      editedProduct.prodIsGroup = false;
      if (widget.oldBarcode != null) {
        barcodeController.text = widget.oldBarcode!;
        editedProduct.prodBarcode = widget.oldBarcode;
      }
      if (widget.oldParent != null) {
        editedProduct.prodCode = productController.getNextProductCode(perantId: widget.oldParent);
        editedProduct.prodParentId = widget.oldParent;
        editedProduct.prodIsParent = false;
      } else {
        editedProduct.prodCode = productController.getNextProductCode();
      }
      codeController.text = editedProduct.prodCode!;
    }
    // productController.initProductPage(editedProductRecord);
  }

  bool checkInput() {
    if (editedProduct.prodName?.isEmpty ?? true) {
      Get.snackbar("خطأ", "يرجى كتابة اسم");
    } else if (editedProduct.prodCode?.isEmpty ?? true) {
      Get.snackbar("خطأ", "يرجى كتابة رمز");
    } else if (editedProduct.prodCustomerPrice?.isEmpty ?? true) {
      Get.snackbar("خطأ", "يرجى كتابة سعر المستهلك");
    } else if (editedProduct.prodWholePrice?.isEmpty ?? true) {
      Get.snackbar("خطأ", "يرجى كتابة السعر الجملة");
    } else if (editedProduct.prodCostPrice?.isEmpty ?? true) {
      Get.snackbar("خطأ", "يرجى كتابة السعر التكلفة");
    } else if (editedProduct.prodRetailPrice?.isEmpty ?? true) {
      Get.snackbar("خطأ", "يرجى كتابة سعر المفرق");
    } else if (editedProduct.prodMinPrice?.isEmpty ?? true) {
      Get.snackbar("خطأ", "يرجى كتابة اقل سعر مسموح");
    } else if (editedProduct.prodBarcode?.isEmpty ?? true) {
      Get.snackbar("خطأ", "يرجى كتابة باركود");
    } else {
      return true;
    }
    return false;
  }

  Widget item({required String text, required TextEditingController controller, required Function(String _) onChange, List<TextInputFormatter>? inputFormatters}) {
    return SizedBox(
      width: Get.width * .45,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 100, child: Text(text)),
          Expanded(
            child: CustomTextFieldWithoutIcon(
                // decoration: const InputDecoration(fillColor: Colors.white,filled: true),
                inputFormatters: inputFormatters,
                controller: controller,
                onChanged: onChange),
          ),
        ],
      ),
    );
  }
}
