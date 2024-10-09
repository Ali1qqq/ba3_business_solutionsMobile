import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/view/products/pages/product_tree_view.dart';
import 'package:ba3_business_solutions/view/products/pages/product_view.dart';
import 'package:ba3_business_solutions/view/products/widget/add_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';

class ProductType extends StatefulWidget {
  const ProductType({super.key});

  @override
  State<ProductType> createState() => _ProductTypeState();
}

class _ProductTypeState extends State<ProductType> {
  PatternViewModel patternController = Get.find<PatternViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("المواد"),
      ),
      body: Column(
        children: [
          Item("إضافة مادة", () {
            Get.to(() => AddProduct());
          }),
          // Item("معاينة المواد",(){
          //   checkPermissionForOperation(Const.roleUserRead , Const.roleViewProduct).then((value) {
          //     if(value) Get.to(()=>AllProductOLD());
          //   });
          // }),
          Item("معاينة المواد(الشكل الجديد)", () {
            checkPermissionForOperation(
                    AppConstants.roleUserRead, AppConstants.roleViewProduct)
                .then((value) {
              if (value) Get.to(() => AllProduct());
            });
          }),
          Item("شجرة المواد", () {
            checkPermissionForOperation(
                    AppConstants.roleUserRead, AppConstants.roleViewProduct)
                .then((value) {
              if (value) Get.to(() => ProductTreeView());
            });
          }),
          /*         Item("إدارة المخزون ",(){
            checkPermissionForOperation(Const.roleUserAdmin , Const.roleViewProduct).then((value) {
              if(value) Get.to(()=>ProductManagementView());
            });
          }), */
        ],
      ),
    );
  }

  Widget Item(text, onTap) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Text(
              text,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ))),
      ),
    );
  }
}
