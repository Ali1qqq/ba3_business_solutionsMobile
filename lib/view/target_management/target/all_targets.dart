import 'package:ba3_business_solutions/controller/seller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/target_view_model.dart';
import 'package:ba3_business_solutions/model/seller/seller_model.dart';
import 'package:ba3_business_solutions/view/sellers/pages/seller_targets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart'; // Import app strings
import '../../../model/seller/task_model.dart';

class AllTargets extends StatelessWidget {
  const AllTargets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.targetsPreview), // Use constant here
      ),
      body: GetBuilder<SellersViewModel>(builder: (controller) {
        return controller.allSellers.isEmpty
            ? const Center(
                child: Text(AppStrings.noTargets), // Use constant here
              )
            : GetBuilder<TargetViewModel>(builder: (targetViewModel) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: controller.allSellers.values.length,
                    itemBuilder: (context, index) {
                      SellerModel sellerModel =
                          controller.allSellers.values.toList()[index];
                      ({
                        double mobileTotal,
                        double otherTotal,
                        Map<String, int> productsMap
                      }) sellerData =
                          targetViewModel.checkTask(sellerModel.sellerId!);
                      int allTask = 0;
                      bool isHitTarget = false;
                      for (TaskModel model
                          in targetViewModel.allTarget.values.toList()) {
                        int count =
                            sellerData.productsMap[model.taskProductId!] ?? 0;
                        bool isDone = count >= model.taskQuantity!;
                        if (isDone) allTask++;
                      }
                      if (allTask == targetViewModel.allTarget.length &&
                          sellerData.otherTotal >
                              AppConstants.minMobileTarget &&
                          sellerData.mobileTotal >
                              AppConstants.minOtherTarget) {
                        isHitTarget = true;
                      }
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Get.to(() => SellerTarget(
                                  sellerId: sellerModel.sellerId!));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10)),
                              height: 140,
                              width: 140,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        sellerModel.sellerCode ?? "",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        sellerModel.sellerName ?? "",
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      "${AppStrings.mobileTarget}${sellerData.mobileTotal}",
                                      style: const TextStyle(fontSize: 18)),
                                  Text(
                                      "${AppStrings.accessoriesTarget}${sellerData.otherTotal.toStringAsFixed(2)}",
                                      style: const TextStyle(fontSize: 18)),
                                  Text(
                                      "${AppStrings.tasksExecuted}${allTask.toInt()} من أصل ${targetViewModel.allTarget.values.where((e) => e.taskSellerListId.contains(sellerModel.sellerId) && e.isTaskAvailable!).length}",
                                      style: const TextStyle(fontSize: 18)),
                                  Row(
                                    children: [
                                      const Text(AppStrings.achievedTarget,
                                          style: TextStyle(fontSize: 18)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        isHitTarget
                                            ? Icons.check
                                            : Icons.cancel,
                                        color: isHitTarget
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ));
                    },
                  ),
                );
              });
      }),
    );
  }
}
