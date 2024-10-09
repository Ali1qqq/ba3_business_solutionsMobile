import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/model/inventory/inventory_model.dart';
import 'package:ba3_business_solutions/model/product/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/seller/sellers_view_model.dart';
import '../../../core/constants/app_strings.dart'; // Import your app strings

class AllInventoryView extends StatefulWidget {
  final InventoryModel inventoryModel;

  const AllInventoryView({super.key, required this.inventoryModel});

  @override
  State<AllInventoryView> createState() => _AllInventoryViewState();
}

class _AllInventoryViewState extends State<AllInventoryView> {
  bool isAll = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                isAll = !isAll;
              });
            },
            child: Text(isAll
                ? AppStrings.showCountedItems.tr
                : AppStrings.showAllItems.tr),
          ),
          const SizedBox(width: 10),
        ],
        title: Text(AppStrings.inventoryViewTitle.tr),
      ),
      body: GetBuilder<ProductViewModel>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: isAll
                ? widget.inventoryModel.inventoryTargetedProductList.keys.length
                : widget.inventoryModel.inventoryRecord.length,
            itemBuilder: (context, index) {
              ProductModel productModel = getProductModelFromId(isAll
                      ? widget.inventoryModel.inventoryTargetedProductList.keys
                          .toList()[index]
                      : widget.inventoryModel.inventoryRecord.keys
                          .toList()[index]) ??
                  ProductModel(prodId: "prod1723066749939566");
              int count = controller.getCountOfProduct(productModel);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(AppStrings.responsibleForInventory.tr),
                        Expanded(
                          child: Text(
                            getSellerNameFromId(widget.inventoryModel
                                    .inventoryTargetedProductList.values
                                    .toList()[index])
                                .toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    Container(
                      color: Colors.grey.withOpacity(0.25),
                      height: 75,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Text(
                              AppStrings.productNameLabel.tr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              productModel.prodName.toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              AppStrings.actualQuantityLabel.tr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              count.toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              AppStrings.enteredQuantityLabel.tr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.inventoryModel
                                      .inventoryRecord[productModel.prodId] ??
                                  '0',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 10),
                            if (widget.inventoryModel
                                    .inventoryRecord[productModel.prodId!] !=
                                null)
                              Icon(Icons.check, color: Colors.green.shade700)
                            else
                              Icon(Icons.cancel, color: Colors.red.shade700),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
