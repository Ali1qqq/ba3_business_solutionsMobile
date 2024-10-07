/*
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/utils/logger.dart';
import 'package:ba3_business_solutions/view/accounts/widget/account_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/sliver_list_widget.dart';

class AllAccountOLD extends StatelessWidget {
  const AllAccountOLD({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<AccountViewModel>(
          builder: (controller) {
            return SliverListWidget<AccountModel>(
              header: "الحسابات",
              hintText:"البحث عن حساب ",
              allElement:controller.accountList.values.toList() ,
              childBuilder: (BuildContext context, item, int index) {
                return _accountItemWidget(item ,controller );
              },
              where: (item, String search) {
                return item.accName!.toLowerCase().contains(search.toLowerCase()) ||item.accCode!.toLowerCase().contains(search.toLowerCase())  ;
              },
            );
          }
        ),
      ),
    );
  }
  Widget _accountItemWidget(AccountModel model,AccountViewModel controller){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          logger(newData: AccountModel(accId: model.accId), transfersType: TransfersType.read);
          Get.to(() => AccountDetails(modelKey: model.accId!));
        },
        child: Row(
          children: [
            Spacer(),
            Container(
                width: 150,
                child: Text(model.accCode.toString(),style: TextStyle(fontSize: 20),)),
            Spacer(flex: 3,),
            Container( width: 300,child: Text(model.accName ?? "not found",style: TextStyle(fontSize: 20),)),
            Spacer(flex: 3,),
            Text("الرصيد: "),
            Text(controller.getBalance(model.accId).toString() ,style: TextStyle(fontSize: 20),),
            Spacer(),
          ],
        ),
      ),
    );
  }

}
*/
