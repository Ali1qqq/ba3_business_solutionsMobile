import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../model/inventory/inventory_model.dart';
import '../../model/product/product_model.dart';

class InventoryViewModel extends GetxController {
  Map<String, InventoryModel> allInventory = {};

  InventoryViewModel() {
    FirebaseFirestore.instance
        .collection(AppConstants.inventoryCollection)
        .snapshots()
        .listen((event) {
      allInventory.clear();
      for (var i in event.docs) {
        allInventory[i.id] = InventoryModel.fromJson(i.data());
      }
      WidgetsFlutterBinding.ensureInitialized()
          .waitUntilFirstFrameRasterized
          .then((value) => update());
    });
  }

  List<ProductModel> getProduct(_, List targetedProductList) {
    List<ProductModel>? listProduct = getProductsModelFromName(_);
    if (listProduct == null || listProduct.isEmpty) {
      return [];
    } else {
      listProduct.removeWhere(
          (element) => !targetedProductList.contains(element.prodId));
      return listProduct;
    }
  }
}
