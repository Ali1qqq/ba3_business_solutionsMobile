import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Widgets/Bond_Record_Pluto_View_Model.dart';
import '../../Widgets/new_Pluto.dart';

import '../../utils/hive.dart';
import 'bond_details_view.dart';
import 'custom_bond_details_view.dart';

class AllBonds extends StatelessWidget {
  const AllBonds({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BondViewModel>(builder: (controller) {
      return CustomPlutoGridWithAppBar(
        title: "جميع السندات",
        onLoaded: (e) {},
        type: Const.globalTypeBond,
        onSelected: (p0) {
          Get.to(() => BondDetailsView(
            oldId: p0.row?.cells["bondId"]?.value,
            bondType: p0.row?.cells["نوع السند"]?.value,
          ),
          binding: BindingsBuilder(() => Get.lazyPut(() =>BondRecordPlutoViewModel(getBondEnumFromType( p0.row?.cells["نوع السند"]?.value)) ,),)
          );
        },
        modelList: controller.allBondsItem.values.where(
          (element) {
            if (HiveDataBase.getWithFree()) {
              return !(element.bondCode?.startsWith("F") ?? true);
            } else {
              return true;
            }
          },
        ).toList(),
      );
    });
  }
}
