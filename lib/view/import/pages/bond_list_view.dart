import 'package:ba3_business_solutions/controller/account/account_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/databsae/import_view_model.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../model/bond/bond_record_model.dart';
import '../../../model/global/global_model.dart';

class BondListView extends StatelessWidget {
  final List<GlobalModel> bondList;

  BondListView({super.key, required this.bondList});

  final ImportViewModel importViewModel = Get.find<ImportViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () {
                if (importViewModel.checkAllAccount(bondList)) {
                  importViewModel.addBond(bondList);
                }
              },
              child: const Text("add"))
        ],
      ),
      body: ListView.builder(
          itemCount: bondList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(bondList[index].bondId.toString()),
                      Text("المجموع: ${bondList[index].bondTotal}"),
                      Text("الوقت: ${bondList[index].bondDate}"),
                      Text(
                          "نوع الفاتورة: ${getBondTypeFromEnum(bondList[index].bondType.toString())}"),
                      Text("الرمز: ${bondList[index].bondCode}"),
                      Text("الرمز: ${bondList[index].bondType}"),
                      Text("origin: ${bondList[index].originAmenId}"),
                      Text("الوصف: ${bondList[index].bondDescription}"),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                            width: 50,
                            child: Text(
                              "الوصف",
                              style: TextStyle(fontSize: 20),
                            )),
                        Container(
                          height: 30,
                          width: 2,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(
                            width: 50,
                            child: Text(
                              "دائن",
                              style: TextStyle(fontSize: 20),
                            )),
                        Container(
                          height: 30,
                          width: 2,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(
                            width: 50,
                            child: Text(
                              "مدين",
                              style: TextStyle(fontSize: 20),
                            )),
                        Container(
                          height: 30,
                          width: 2,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(
                            width: 300,
                            child: Text(
                              "الحساب",
                              style: TextStyle(fontSize: 20),
                            )),
                        Container(
                          height: 30,
                          width: 2,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(
                            width: 50,
                            child: Text(
                              "الرمز",
                              style: TextStyle(fontSize: 20),
                            )),
                      ],
                    ),
                  ),
                  for (BondRecordModel e in bondList[index].bondRecord ?? [])
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: 50,
                              child: Text(e.bondRecDescription.toString())),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(
                              width: 50,
                              child: Text(e.bondRecCreditAmount.toString())),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(
                              width: 50,
                              child: Text(e.bondRecDebitAmount.toString())),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(
                              width: 300,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (getAccountNameFromId(e.bondRecAccount) ==
                                      "")
                                    Text(
                                      "غير موجود${e.bondRecAccount}",
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  Expanded(
                                      child: Text(
                                          "${e.bondRecAccount} ${getAccountNameFromId(e.bondRecAccount)}")),
                                ],
                              )),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(
                              width: 50, child: Text(e.bondRecId.toString())),
                        ],
                      ),
                    ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
