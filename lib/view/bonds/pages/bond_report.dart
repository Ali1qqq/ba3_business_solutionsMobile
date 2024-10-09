import 'package:ba3_business_solutions/controller/account/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond/bond_view_model.dart';
import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../model/bond/bond_record_model.dart';

class BondReport extends StatefulWidget {
  const BondReport({super.key});

  @override
  State<BondReport> createState() => _BondReportState();
}

class _BondReportState extends State<BondReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<BondViewModel>(
        builder: (controller) {
          List<GlobalModel> allBond = controller.allBondsItem.values.toList();
          return Column(
            children: [
              const SizedBox(
                height: 55,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      child: Text(AppStrings.date,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(AppStrings.type,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                    ),
                    SizedBox(width: 100),
                    SizedBox(
                      width: 100,
                      child: Text(AppStrings.creditor,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                    ),
                    SizedBox(width: 100),
                    SizedBox(
                      width: 100,
                      child: Text(AppStrings.debtor,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: allBond.length,
                  itemBuilder: (context, index) {
                    GlobalModel model = allBond[index];
                    return Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 100,
                                child: Text(model.bondDate.toString()),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(getBondTypeFromEnum(
                                        model.bondType.toString()) +
                                    ": " +
                                    model.bondCode.toString()),
                              ),
                              const SizedBox(width: 100),
                              SizedBox(
                                width: 100,
                                child: Text(model.bondRecord!
                                    .map((e) => e.bondRecCreditAmount!)
                                    .reduce(
                                        (value, element) => value + element)
                                    .toStringAsFixed(2)),
                              ),
                              const SizedBox(width: 100),
                              SizedBox(
                                width: 100,
                                child: Text(model.bondRecord!
                                    .map((e) => e.bondRecDebitAmount!)
                                    .reduce(
                                        (value, element) => value + element)
                                    .toStringAsFixed(2)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              SizedBox(width: 100),
                              SizedBox(width: 100),
                              SizedBox(
                                width: 100,
                                child: Text(AppStrings.account,
                                    style: TextStyle(fontSize: 18)),
                              ),
                              SizedBox(width: 100),
                              SizedBox(
                                width: 100,
                                child: Text(AppStrings.creditor,
                                    style: TextStyle(fontSize: 18)),
                              ),
                              SizedBox(width: 100),
                              SizedBox(
                                width: 100,
                                child: Text(AppStrings.debtor,
                                    style: TextStyle(fontSize: 18)),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(AppStrings.description,
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ],
                          ),
                        ),
                        for (BondRecordModel i in model.bondRecord!)
                          SizedBox(
                            height: 100,
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                const SizedBox(width: 100),
                                const SizedBox(width: 100),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                      getAccountNameFromId(i.bondRecAccount)),
                                ),
                                const SizedBox(width: 100),
                                SizedBox(
                                  width: 100,
                                  child: Text(i.bondRecCreditAmount!
                                      .toStringAsFixed(2)),
                                ),
                                const SizedBox(width: 100),
                                SizedBox(
                                  width: 100,
                                  child: Text(i.bondRecDebitAmount!
                                      .toStringAsFixed(2)),
                                ),
                                SizedBox(
                                  child:
                                      Text(i.bondRecDescription.toString()),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          height: 5,
                          width: Get.width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
