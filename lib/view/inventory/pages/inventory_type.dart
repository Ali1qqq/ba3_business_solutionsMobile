import 'package:ba3_business_solutions/controller/inventory/inventory_view_model.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/view/inventory/pages/add_inventory_view.dart';
import 'package:ba3_business_solutions/view/inventory/pages/all_inventory_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../model/inventory/inventory_model.dart';
import 'Add_new_inventory_view.dart';

class InventoryType extends StatefulWidget {
  const InventoryType({super.key});

  @override
  State<InventoryType> createState() => _InventoryTypeState();
}

class _InventoryTypeState extends State<InventoryType> {
  InventoryViewModel inventoryViewModel = Get.find<InventoryViewModel>();
  TextEditingController inventoryName = TextEditingController();
  InventoryModel? selectedInventory;

  @override
  void initState() {
    // selectedInventory = (inventoryViewModel.allInventory.isNotEmpty)?inventoryViewModel.allInventory.values.last:null;
    // selectedInventory =inventoryViewModel.allInventory.values.where((element) => element.isDone==false,).lastOrNull;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventoryViewModel>(builder: (controller) {
      selectedInventory = inventoryViewModel.allInventory.values
          .where(
            (element) => element.isDone == false,
          )
          .lastOrNull;

      return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.inventory.tr),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: selectedInventory != null
                  ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 12),
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${AppStrings.inventoryOnDate.tr}\n'
                            '${selectedInventory!.inventoryDate}',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ("${AppStrings.completionStatus.tr} :${(selectedInventory!.inventoryRecord.length / selectedInventory!.inventoryTargetedProductList.length) * 100}%"),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ))
                  : InkWell(
                      onTap: () async {
                        checkPermissionForOperation(AppConstants.roleUserWrite,
                                AppConstants.roleViewInventory)
                            .then((value) async {
                          if (value) {
                            await Get.to(() => const AddNewInventoryView());
                            // selectedInventory = HiveDataBase.inventoryModelBox.get("0");
                            // setState(() {});
                          }
                        });
                      },
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.all(30.0),
                          child: Center(
                            child: Text(
                              AppStrings.createInventory.tr,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
            ),
            if (selectedInventory != null)
              Column(
                children: [
                  item(AppStrings.completeInventory.tr, () {
                    checkPermissionForOperation(AppConstants.roleUserWrite,
                            AppConstants.roleViewInventory)
                        .then((value) async {
                      if (value) {
                        if (AppConstants.isNotTap) {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeRight,
                          ]);
                        }
                        await Get.to(() => AddInventoryView(
                            inventoryModel: selectedInventory!));
                        // selectedInventory = HiveDataBase.inventoryModelBox.get("0");
                        // setState(() {});
                      }
                    });
                  }),
                  item(AppStrings.viewInventory.tr, () {
                    checkPermissionForOperation(AppConstants.roleUserRead,
                            AppConstants.roleViewInventory)
                        .then((value) {
                      if (value) {
                        Get.to(() => AllInventoryView(
                            inventoryModel: selectedInventory!));
                      }
                    });
                  }),
                  /*        Item("إنهاء الجرد", () {
                      checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewInventory).then((value) {
                         if (value) {
                           print(selectedInventory!.toJson());
                           FirebaseFirestore.instance.collection(Const.inventoryCollection).doc(selectedInventory!.inventoryId).set((selectedInventory!..isDone=true).toJson(),SetOptions(merge: true));
                           // HiveDataBase.inventoryModelBox.delete("0");
                           // selectedInventory = null;
                           // setState(() {});
                           controller.update();

                         }
                      });
                    }),
                    Item("حذف الجرد", () {
                      checkPermissionForOperation(Const.roleUserDelete, Const.roleViewInventory).then((value) {
                        if (value) {
                          confirmDeleteWidget().then((value) {
                            if(value){
                              FirebaseFirestore.instance.collection(Const.inventoryCollection).doc(selectedInventory!.inventoryId).delete();

                              controller.update();
                              // HiveDataBase.inventoryModelBox.delete("0");
                              // selectedInventory = null;
                              // setState(() {});
                            }

                          });
                        }
                      });
                    }),*/
                ],
              ),
            /*     Item("معاينة الجرد قديم", () {
                checkPermissionForOperation(Const.roleUserAdmin, Const.roleViewInventory).then((value) {
                  if (value) {
                    Get.defaultDialog(
                      title: "إختر احد الجرود",
                      content: SizedBox(
                        height: MediaQuery.sizeOf(context).width/4,
                        width: MediaQuery.sizeOf(context).width/4,
                        child: ListView.builder(
                          itemCount: inventoryViewModel.allInventory.length,
                          itemBuilder:(context, index) {
                            InventoryModel inv = inventoryViewModel.allInventory.values.toList()[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: (){
                                  Get.back();
                                  Get.to(() => AllInventoryView(inventoryModel: inv));
                                },
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${inv.inventoryName!}         قام به: "+getUserNameById(inv.inventoryUserId),textDirection: TextDirection.rtl,),
                            )),
                          );
                        },),
                      )
                    );

                  }
                });
              }),*/
          ],
        ),
      );
    });
  }

  Widget item(text, onTap) {
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
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )),
      ),
    );
  }
}
