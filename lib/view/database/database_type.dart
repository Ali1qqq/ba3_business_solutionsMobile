import 'package:ba3_business_solutions/controller/database_view_model.dart';

import 'package:ba3_business_solutions/view/database/database_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DataBaseType extends StatefulWidget {
  const DataBaseType({super.key});

  @override
  State<DataBaseType> createState() => _DataBaseTypeState();
}

class _DataBaseTypeState extends State<DataBaseType> {
  DataBaseViewModel dataBaseController=Get.find<DataBaseViewModel>();
bool isAdmin = false;
  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
    //   checkPermissionForOperation(Const.roleUserAdmin,Const.roleViewDataBase).then((value) {
    //     print(value);
    //     if (value) {
    //       isAdmin = true;
    //       setState(() {

    //       });
    //     }
    //   });
    // });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("إدارة قواعد البيانات"),
        ),
        body:Column(
          children: [
            Item("إضافة قاعدة بيانات",(){
              TextEditingController textController = TextEditingController();
              Get.defaultDialog(content: SizedBox(
                height: 100,
                width: 200,
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: textController,

                      ),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        if(textController.text.isNotEmpty&&!dataBaseController.databaseList.contains(textController.text)){
                          Get.back();
                          dataBaseController.newDataBase(textController.text);
                        }
                      },
                      child: Container(
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color:Colors.lightBlue.shade100,
                      ),
                        child: Center(child: Text("موافق")),
                      ),
                    )
                  ],
                ),
              ));
            }),

            Item("تحديد قاعدة البيانات الافتراضية",(){
              Get.defaultDialog(content: SizedBox(
                height: MediaQuery.sizeOf(context).height/2,
                width: MediaQuery.sizeOf(context).height/2,
                child: ListView.builder(
                    itemCount: dataBaseController.databaseList.length,
                    itemBuilder: (context,index){
                  var text = dataBaseController.databaseList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: (){
                          Get.back();
                          dataBaseController.setDefaultDataBase(text);
                        },
                        child: Text(text,textDirection: TextDirection.rtl,style: TextStyle(fontSize: 22),)),
                  );
                })
              ));
              // Get.defaultDialog(content: SizedBox(
              //   height: 100,
              //   width: 200,
              //   child: TextFormField(onFieldSubmitted: (_){
              //     Get.back();
              //     // dataBaseController.setDefaultDataBase(_);
              //   },),
              // ));

            }),
            Item("تغيير قاعدة البيانات",(){
              Get.to(()=> DataBaseView());
              // checkPermissionForOperation(Const.roleUserRead , Const.roleViewPattern).then((value) {
              //   if(value) Get.to(()=>AllPattern());
              // });
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
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Text(text,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,)),
      ),
    );
  }
}
