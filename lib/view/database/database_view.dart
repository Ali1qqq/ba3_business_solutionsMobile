import 'package:ba3_business_solutions/controller/database_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DataBaseView extends StatelessWidget {
  const DataBaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataBaseViewModel>(
      builder: (controller) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text("اختر احد قواعد البيانات"),
            ),
            body: ListView.builder(
                itemCount: controller.databaseList.length,
                itemBuilder: (context,index){
              return Item(controller.databaseList[index],(){
                      controller.setDataBase(controller.databaseList[index],context);
              });
            }),
          ),
        );
      }
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
