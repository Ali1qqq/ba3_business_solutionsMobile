import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/target_view_model.dart';
import 'package:ba3_business_solutions/model/inventory_model.dart';
import 'package:ba3_business_solutions/model/task_model.dart';
import 'package:ba3_business_solutions/utils/date_month_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../Const/const.dart';
import '../../../controller/user_management_model.dart';
import '../../../model/seller_model.dart';
import '../../invoices/widget/custom_TextField.dart';

class AddTaskView extends StatefulWidget {
  final String? oldKey;

  const AddTaskView({super.key, this.oldKey});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TargetViewModel targetViewModel = Get.find<TargetViewModel>();
  List<String> allUser =[];
  late TaskModel taskModel;
  InventoryModel? inventoryModel ;
  String? taskDate ;

  @override
  void initState() {
    if (widget.oldKey == null) {
      taskModel = TaskModel(taskType: Const.taskTypeProduct);
      taskDate = "${DateTime.now().year}-${DateTime.now().month}";
      allUser.clear();
    } else {
      taskModel = TaskModel.fromJson(targetViewModel.allTarget[widget.oldKey]!.toJson());
      productNameController.text = getProductNameFromId(taskModel.taskProductId);
      quantityController.text = taskModel.taskQuantity.toString();
      allUser.assignAll(taskModel.taskSellerListId);
      taskDate = taskModel.taskDate;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<TargetViewModel>(
          builder: (controller) {
            return Scaffold(
                appBar: AppBar(title: Text(widget.oldKey == null ? "إضافة التاسك" : "تعديل التاسك"),),
                body: SingleChildScrollView(
                  child: Container(
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GetBuilder<SellersViewModel>(builder: (controller) {
                          return StatefulBuilder(
                              builder: (context,setstate) {
                                return Column(
                                  children: [
                                    const Text("المستخدمين :"),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    for(SellerModel i in controller.allSellers.values.toList())
                                     ...[ Row(
                                        children: [
                                          const SizedBox(width: 15,),
                                          Checkbox(value: allUser.contains(i.sellerId),
                                              fillColor: WidgetStatePropertyAll(Colors.blue.shade800),
                                              checkColor: Colors.white,

                                              onChanged: (_){

                                            if (allUser.contains(i.sellerId)) {
                                              allUser.remove(i.sellerId!);
                                            } else {
                                              if(taskModel.taskType == Const.taskTypeProduct){
                                                allUser.add(i.sellerId!);
                                              }else{
                                                allUser.assign(i.sellerId!);
                                              }
                                            }
                                            setstate((){});
                                          }),
                                          const SizedBox(width: 10,),
                                          Text(i.sellerName.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)

                                        ],
                                      ),
                                       const Divider()
                                     ]

                                  ],
                                );
                              }
                          );
                        }),
                        const SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Column(
                            children: [
                              SizedBox(
                                width: Get.width / 2.5,
                                child: Row(
                                  children: [
                                    const Text("المادة :"),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Expanded(
                                      child: CustomTextFieldWithIcon(
                                     controller:    productNameController,
                                      onSubmitted:       (text) async {
                                          var a = await controller.getComplete(text);
                                          if (a.isNotEmpty) {
                                            taskModel.taskProductId = getProductIdFromName(a);
                                            productNameController.text = a;
                                            setState(() {});
                                          }
                                        },

                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    if(taskModel.taskProductId != null)
                                      Icon(Icons.check),
                                  ],
                                ),
                              ),
                              SizedBox(height: 50,),
                              SizedBox(
                                width: Get.width / 5,
                                child: Row(
                                  children: [
                                    const Text("العدد المطلوب :"),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            border: OutlineInputBorder(

                                              borderSide: const BorderSide(
                                                color: Colors.black,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(5.0), // Adjust border radius
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.blue, // Change the border color when focused
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                                          ),
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          controller: quantityController,
                                          onChanged: (_) {
                                            taskModel.taskQuantity = int.tryParse(quantityController.text);
                                          }
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50,),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("التاريخ:"),
                              const SizedBox(width: 10,),
                              DateMonthPicker(
                                initDate: taskDate,
                                onSubmit: (date) {
                                taskDate = "${date.year}-${date.month}";
                                setState(() {});
                              },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                if (taskDate == null) {
                                  Get.snackbar("خطأ", "يرجى كتابة تاريخ");
                                } else if (taskModel.taskProductId?.isEmpty ?? true) {
                                  Get.snackbar("خطأ", "يرجى كتابة اسم المادة");
                                } else if (taskModel.taskQuantity == null || taskModel.taskQuantity == 0) {
                                  Get.snackbar("خطأ", "يرجى كتابة عدد");
                                } else if ((allUser).isEmpty) {
                                  Get.snackbar("خطأ", "يرجى إضافة مستخدمين");
                                }  else {
                                  taskModel.taskSellerListId = allUser;
                                  taskModel.taskDate = taskDate;
                                  if (taskModel.taskId != null) {
                                    checkPermissionForOperation(Const.roleUserRead, Const.roleViewTask).then((value) {
                                      if (value) controller.updateTask(taskModel);
                                    });
                                  } else {
                                    checkPermissionForOperation(Const.roleUserRead, Const.roleViewTask).then((value) {
                                      if (value) controller.addTask(taskModel);
                                    });
                                  }
                                }
                              },
                              child: Text(taskModel.taskId != null ? "تعديل" : "إنشاء")),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                )
            );
          }
      ),
    );
  }
}
