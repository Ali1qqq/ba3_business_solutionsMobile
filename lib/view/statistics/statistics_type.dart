import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:ba3_business_solutions/view/statistics/statistics_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Const/const.dart';
import '../../controller/account_view_model.dart';
import '../../model/account_model.dart';

class StatisticsType extends StatefulWidget {
  const StatisticsType({super.key});

  @override
  State<StatisticsType> createState() => _StatisticsTypeState();
}

class _StatisticsTypeState extends State<StatisticsType> {
  PatternViewModel patternController=Get.find<PatternViewModel>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("الاحصائيات"),
        ),
        body: Column(
          children: [
            Item("إضافة حساب",() async {
              TextEditingController nameController = TextEditingController();
              List<AccountModel> accountList = [];
              await   Get.defaultDialog(
                  title: "اكتب اسم الحساب",
                  content: StatefulBuilder(
                      builder: (context, setstate) {
                        return SizedBox(
                          height: MediaQuery
                              .sizeOf(context)
                              .width / 4,
                          width: MediaQuery
                              .sizeOf(context)
                              .width / 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: TextFormField(
                                    textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(hintText: "اكتب اسم الحساب او رقمه",hintTextDirection: TextDirection.rtl),
                                    onChanged: (_){
                                      accountList = getAccountModelsFromName(_);
                                      print(accountList);
                                      setstate(() {});
                                    },
                                    controller: nameController,
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Expanded(child: accountList.isEmpty
                                    ? Center(child: Text("لا يوجد نتائج"),)
                                    : ListView.builder(
                                  itemCount: accountList.length,
                                  itemBuilder: (context, index) {
                                    AccountModel model = accountList[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                          onTap: () {
                                            HiveDataBase.statisticBox.put(model.accId, {
                                              "accName":model.accName,
                                              "accId":model.accId,
                                              });
                                            Get.back();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(model.accName.toString() + "   " + model.accCode.toString(),textDirection: TextDirection.rtl,),
                                          )),
                                    );
                                  },))
                              ],
                            ),
                          ),
                        );
                      }
                  )
              );
              setState(() {});
            }, ),
            for(var i in HiveDataBase.statisticBox.values.toList())
            Item("معاينة "+i["accName"].toString(),(){
              checkPermissionForOperation(Const.roleUserRead , Const.roleViewStore).then((value) {
                if(value) Get.to(()=>StatisticsView(accountId: i["accId"]!));
              });
            }),
          ],
        ),
      ),
    );
  }
  Widget Item(text,onTap){
    return   Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,

            decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Center(child: Text(text,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,))),
      ),
    );
  }
}
