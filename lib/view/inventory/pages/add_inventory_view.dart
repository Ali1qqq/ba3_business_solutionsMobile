import 'package:ba3_business_solutions/controller/inventory/inventory_view_model.dart';
import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/core/constants/app_strings.dart';
import 'package:ba3_business_solutions/model/inventory/inventory_model.dart';
import 'package:ba3_business_solutions/model/product/product_model.dart';
import 'package:ba3_business_solutions/view/invoices/pages/New_Invoice_View.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controller/seller/sellers_view_model.dart';
import '../../../core/constants/app_constants.dart';

class AddInventoryView extends StatefulWidget {
  final InventoryModel inventoryModel;

  const AddInventoryView({Key? key, required this.inventoryModel})
      : super(key: key);

  @override
  State<AddInventoryView> createState() => _AddInventoryViewState();
}

class _AddInventoryViewState extends State<AddInventoryView> {
  List<ProductModel> prodList = [];
  TextEditingController searchController = TextEditingController();
  bool isNotFound = false;
  late InventoryModel inventoryModel;

  UserManagementViewModel myUser = Get.find<UserManagementViewModel>();

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
    inventoryModel = widget.inventoryModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventoryViewModel>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(),
          body: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                /*         SizedBox(
                    width: double.infinity,
                    height: 75,
                    child: TextFormField(
                      autofocus: true,
                      controller: searchController,
                      decoration: const InputDecoration(hintText: "أدخل اسم المنتج للبحث"),
                      onFieldSubmitted: (_) {
                        prodList = controller.getProduct(_,inventoryModel.inventoryTargetedProductList);
                        controller.update();
                        searchController.clear();
                        isNotFound = prodList.isEmpty;
                      },
                    ),
                  ),*/
                // if (prodList.isNotEmpty)
                Expanded(
                  child: GetBuilder<ProductViewModel>(
                    builder: (productController) {
                      return inventoryModel.inventoryTargetedProductList.values
                              .where(
                                (element) =>
                                    element == myUser.myUserModel?.userSellerId,
                              )
                              .isNotEmpty
                          ? ListView.builder(
                              itemCount: inventoryModel
                                  .inventoryTargetedProductList.values
                                  .where(
                                    (element) =>
                                        element ==
                                        myUser.myUserModel?.userSellerId,
                                  )
                                  .length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> myEnv = Map.fromEntries(
                                  inventoryModel
                                      .inventoryTargetedProductList.entries
                                      .where(
                                    (element) =>
                                        element.value ==
                                        myUser.myUserModel?.userSellerId,
                                  ),
                                );
                                ProductModel model = getProductModelFromId(
                                    myEnv.keys.toList()[index])!;

                                int count =
                                    productController.getCountOfProduct(model);
                                Map<String, int> storeMap = {};
                                model.prodRecord?.forEach((element) {
                                  if (storeMap[element.prodRecStore] == null)
                                    storeMap[element.prodRecStore!] = 0;
                                  storeMap[element.prodRecStore!] =
                                      int.parse(element.prodRecQuantity!) +
                                          storeMap[element.prodRecStore!]!;
                                });
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(AppStrings
                                              .responsibleForInventory.tr),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Text(
                                            getSellerNameFromId(myEnv.values
                                                    .toList()[index])
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 18),
                                          )),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color:
                                                  Colors.grey.withOpacity(0.25),
                                              border: Border.all(
                                                  color: inventoryModel
                                                                  .inventoryRecord[
                                                              model.prodId!] !=
                                                          null
                                                      ? Colors.green
                                                      : Colors.red)),
                                          height: 95,
                                          padding: const EdgeInsets.all(8),
                                          alignment: Alignment.center,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(AppStrings
                                                        .productNameLabel.tr),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      model.prodName.toString(),
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(AppStrings
                                                      .actualQuantityLabel.tr),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    count.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(AppStrings
                                                      .enteredQuantityLabel.tr),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    (inventoryModel.inventoryRecord[
                                                                model
                                                                    .prodId!] ??
                                                            "0")
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  const Spacer(),
                                                  AppButton(
                                                    onPressed: () async {
                                                      TextEditingController
                                                          textController =
                                                          TextEditingController();
                                                      String? a = await Get
                                                          .defaultDialog(
                                                              title: AppStrings
                                                                  .enterNumber
                                                                  .tr,
                                                              content: Column(
                                                                children: [
                                                                  TextFormField(
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter
                                                                          .digitsOnly
                                                                    ],
                                                                    controller:
                                                                        textController,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        return Get.back(
                                                                            result:
                                                                                textController.text);
                                                                      },
                                                                      child: Text(AppStrings
                                                                          .approval
                                                                          .tr))
                                                                ],
                                                              ));
                                                      if (a != null &&
                                                          a.isNotEmpty) {
                                                        inventoryModel
                                                                .inventoryRecord[
                                                            model
                                                                .prodId!] = a
                                                            .toString();
                                                        inventoryModel
                                                                .inventoryRecord[
                                                            model
                                                                .prodId!] = a
                                                            .toString();
                                                        // setState(() {});
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(AppConstants
                                                                .inventoryCollection)
                                                            .doc(inventoryModel
                                                                .inventoryId)
                                                            .set(
                                                                inventoryModel
                                                                    .toJson(),
                                                                SetOptions(
                                                                    merge:
                                                                        true));
                                                      }
                                                    },
                                                    title: AppStrings
                                                        .writeQuantity.tr,
                                                    iconData: Icons.add,
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  /*                 const SizedBox(
                                                  width: 20,
                                                ),
                                                if (inventoryModel.inventoryRecord[model.prodId!] != null)
                                                  Icon(Icons.check)
                                                else
                                                  SizedBox(
                                                    width: 25,
                                                  ),*/
                                                ],
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                );
                              })
                          : Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.withOpacity(0.25),
                              ),
                              child: Text(
                                AppStrings.noItemsToInventory.tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontSize: 20),
                              ));
                    },
                  ),
                )
                // else
                //   Expanded(
                //       child: Center(
                //     child: Text(isNotFound ? "لم يتم العثور على المنتج" : "ابحث عن المنتج المطلوب "),
                //   )),
              ],
            ),
          ),
        );
      },
    );
  }
}
