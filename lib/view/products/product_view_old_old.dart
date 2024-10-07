import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:ba3_business_solutions/utils/logger.dart';
import 'package:ba3_business_solutions/view/products/widget/product_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/product_model.dart';

class AllProductOLDOLD extends StatelessWidget {
  const AllProductOLDOLD({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
        //     actions: [
        //   ElevatedButton(
        //       onPressed: () {
        //         Get.to(() => AddProduct());
        //       },
        //       child: const Text("create"))
        // ]
        ),
        body: GetBuilder<ProductViewModel>(builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView.builder(
                itemCount: controller.productDataMap.values.where((element) => !element.prodIsGroup!&&(HiveDataBase.isFree.get("isFree")! ? element.prodIsLocal!: true)).toList().length,
                itemBuilder: (context, index) {
                  ProductModel model = controller.productDataMap.values.toList().where((element) => !element.prodIsGroup!&&(HiveDataBase.isFree.get("isFree")! ? element.prodIsLocal!: true)).toList()[index];
                  return _prodItemWidget(model ,controller);
                }),
          );
        }),
      ),
    );
  }


  Widget _prodItemWidget(ProductModel model,controller){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          logger(newData: model, transfersType: TransfersType.read);
          Get.to(() => ProductDetails(
            oldKey: model.prodId,
          ));
        },
        child: Row(
          children: [
            Container(
                width: 100,
                child: Text(controller.getFullCodeOfProduct(model.prodId!),style: TextStyle(fontSize: 20),)),
            Text(" - ",style: TextStyle(fontSize: 20),),
            //   Text(model.prodId ?? "not found"),
            Text(model.prodName ?? "not found",style: TextStyle(fontSize: 20),),
            SizedBox(width: 20,),
            Text("الكمية: "),
            Text(model.prodFullCode.toString(),style: TextStyle(fontSize: 20),),
          ],
        ),
      ),
    );
  }
}
