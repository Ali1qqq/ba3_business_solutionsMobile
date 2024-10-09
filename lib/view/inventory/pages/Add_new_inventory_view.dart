import 'package:ba3_business_solutions/controller/inventory/inventory_view_model.dart';
import 'package:ba3_business_solutions/controller/pluto/pluto_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/core/shared/widgets/option_text_widget.dart';
import 'package:ba3_business_solutions/core/utils/generate_id.dart';
import 'package:ba3_business_solutions/main.dart';
import 'package:ba3_business_solutions/view/invoices/pages/New_Invoice_View.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/product/product_view_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../core/shared/dialogs/Search_Product_Group_Text_Dialog.dart';
import '../../../model/inventory/inventory_model.dart';
import '../../../model/product/product_model.dart';
import '../widgets/CustomPlutoGrid.dart';

class AddNewInventoryView extends StatefulWidget {
  const AddNewInventoryView({Key? key}) : super(key: key);

  @override
  _AddNewInventoryViewState createState() => _AddNewInventoryViewState();
}

class _AddNewInventoryViewState extends State<AddNewInventoryView> {
  List<Map<String, dynamic>> treeListData = [];
  TextEditingController dateInventoryController = TextEditingController(
      text:
          "${AppStrings.inventoryOnDate.tr}${DateTime.now().toString().split(" ")[0]}");
  TextEditingController productGroupNameController = TextEditingController();
  List<ProductModel> allData = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {}

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إنشاء جرد"),
          actions: [
            AppButton(
                title: "موافق",
                onPressed: () async {
                  SellersViewModel sellerViewController =
                      Get.find<SellersViewModel>();
                  List<String?> sellers = [];
                  Map<String, String> allInventoryProducts = {};
                  List<String> groupProduct = [];
                  for (var element in allData) {
                    groupProduct.addIf(
                        !groupProduct.contains(element.prodParentId!),
                        element.prodParentId!);
                  }
                  sellers = List.generate(groupProduct.length, (index) => null);
                  Get.defaultDialog(
                      backgroundColor: backGroundColor,
                      title: "اختر الموظف لكل مهمة",
                      middleText: "",
                      content: GetBuilder<InventoryViewModel>(
                          builder: (inventoryController) {
                        return SizedBox(
                          width: Get.width / 2,
                          height: Get.height / 1.5,
                          child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.all(15),
                                  margin: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade200,
                                      borderRadius: BorderRadius.circular(15)),
                                  alignment: Alignment.center,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: Text(
                                          getProductNameFromId(
                                                  groupProduct[index])
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      // const Spacer(),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      SizedBox(
                                        width: 300,
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                                width: 70,
                                                child: Text("البائع")),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: DropdownButton<String>(
                                                  icon: const SizedBox(),
                                                  underline: const SizedBox(),
                                                  value: sellers[index],
                                                  items: sellerViewController
                                                      .allSellers.keys
                                                      .toList()
                                                      .map((e) => DropdownMenuItem(
                                                          value:
                                                              sellerViewController
                                                                  .allSellers[e]
                                                                  ?.sellerId,
                                                          child: Text(
                                                              sellerViewController
                                                                      .allSellers[
                                                                          e]
                                                                      ?.sellerName ??
                                                                  "error")))
                                                      .toList(),
                                                  onChanged: (_) {
                                                    if (_ != null) {
                                                      sellers[index] = _;
                                                      inventoryController
                                                          .update();
                                                    }

                                                    // controller.initAddUserModel?.userSellerId = _;
                                                    // controller.update();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: groupProduct.length),
                        );
                      }),
                      confirm: AppButton(
                          title: "حفظ",
                          onPressed: () {
                            if (!sellers.contains(null)) {
                              for (int i = 0; i < groupProduct.length; i++) {
                                allData
                                    .where(
                                      (element) =>
                                          element.prodParentId ==
                                          groupProduct[i],
                                    )
                                    .map(
                                      (e) => e.prodId,
                                    )
                                    .forEach(
                                  (element) {
                                    allInventoryProducts[element!] =
                                        sellers[i]!;
                                  },
                                );
                              }
                              InventoryModel inventory = InventoryModel(
                                  isDone: false,
                                  inventoryUserId: getMyUserUserId(),
                                  inventoryId: generateId(RecordType.inventory),
                                  inventoryDate:
                                      DateTime.now().toString().split(" ")[0],
                                  inventoryName: dateInventoryController.text,
                                  inventoryRecord: {},
                                  inventoryTargetedProductList:
                                      allInventoryProducts);

                              FirebaseFirestore.instance
                                  .collection(AppConstants.inventoryCollection)
                                  .doc(inventory.inventoryId)
                                  .set(inventory.toJson());

                              Get.back();
                              Get.back();
                            } else {
                              Get.snackbar("خطأ", "يجب تعبئة كل الحقول");
                            }
                          },
                          iconData: Icons.save_as_outlined));
                },
                iconData: Icons.add),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "اسم الجرد: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                      height: 60,
                      width: 400,
                      child: TextFormField(
                        controller: dateInventoryController,
                        decoration:
                            const InputDecoration(hintText: "اسم الجرد"),
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              OptionTextWidget(
                title: "اسم المجموعة",
                controller: productGroupNameController,
                onSubmitted: (productText) async {
                  PlutoViewModel plutoViewMode = Get.find<PlutoViewModel>();
                  plutoViewMode.plutoKey = GlobalKey();
                  ProductModel? productModel;
                  productModel = getProductModelFromId(
                      await searchProductGroupTextDialog(productText));
                  if (productModel != null) {
                    if (hasCommonElements(
                        productModel.prodChild!,
                        allData
                            .map(
                              (e) => e.prodId,
                            )
                            .toList())) {
                      Get.snackbar("فشل العملية", "المجموعة موجودة من قبل");
                      return;
                    }
                    allData.addAll(productModel.prodChild!.map(
                      (e) => getProductModelFromId(e)!,
                    ));

                    Get.snackbar(
                        "تمت العملية بنجاح", "تمت اضافة المجموعة الى الجرد");
                    setState(() {});
                    productGroupNameController.clear();
                  } else {
                    Get.snackbar("فشل العملية", "هذه المجموعة غير موجودة");
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: CustomPlutoGrid(
                title: "المواد المراد جردها",
                onLoaded: (p0) {},
                onSelected: (p0) {},
                modelList: allData,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
