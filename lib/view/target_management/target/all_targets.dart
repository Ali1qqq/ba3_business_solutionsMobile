
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/target_view_model.dart';
import 'package:ba3_business_solutions/model/seller_model.dart';
import 'package:ba3_business_solutions/view/sellers/seller_targets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Const/const.dart';
import '../../../model/task_model.dart';

class AllTargets extends StatelessWidget {
  const AllTargets({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("معاينة التارغتات"),
        ),
        body: GetBuilder<SellersViewModel>(builder: (controller) {
          return controller.allSellers.isEmpty
              ? const Center(
                  child: Text("لا يوجد التارغتات بعد"),
                )
              : GetBuilder<TargetViewModel>(builder: (targetViewModel) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: controller.allSellers.values.length,
                      itemBuilder: (context, index) {
                        SellerModel sellerModel = controller.allSellers.values.toList()[index];
                        ({double mobileTotal, double otherTotal, Map<String, int> productsMap}) sellerData = targetViewModel.checkTask(sellerModel.sellerId!);
                        int allTask=0;
                        bool isHitTarget = false;
                        for (TaskModel model in targetViewModel.allTarget.values.toList()){
                          int count = sellerData.productsMap[model.taskProductId!] ?? 0;
                          bool isDone = count >= model.taskQuantity!;
                          if(isDone)allTask++;
                        }
                       if(allTask == targetViewModel.allTarget.length &&sellerData.otherTotal>Const.minMobileTarget &&sellerData.mobileTotal>Const.minOtherTarget){
                          isHitTarget = true;
                       }
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => SellerTarget(sellerId: sellerModel.sellerId!));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                                height: 140,
                                width: 140,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          sellerModel.sellerCode ?? "",
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(width: 20,),
                                        Text(
                                          sellerModel.sellerName ?? "",
                                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Text("تارغيت الجوالات: " + sellerData.mobileTotal.toString(), style: const TextStyle(fontSize: 18)),
                                    Text("تارغيت الاكسسوارات: " + sellerData.otherTotal.toStringAsFixed(2), style: const TextStyle(fontSize: 18)),
                                    Text("التاسكات المنفذة: " + allTask.toInt().toString() + " من أصل "+targetViewModel.allTarget.values.where((e)=>e.taskSellerListId.contains(sellerModel.sellerId)&&e.isTaskAvailable!).length.toString(), style: const TextStyle(fontSize: 18)),
                                    Row(
                                      children: [
                                        Text("حقق التارغيت:", style: const TextStyle(fontSize: 18)),
                                        SizedBox(width: 5,),
                                        Icon(isHitTarget?Icons.check:Icons.cancel,color: isHitTarget?Colors.green:Colors.red,),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                        );
                      },
                    ),
                  );
                });
        }),
      ),
    );
  }
}
