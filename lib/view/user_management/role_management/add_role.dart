import 'package:ba3_business_solutions/controller/user_management.dart';
import 'package:ba3_business_solutions/model/role_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Const/const.dart';


class AddRoleView extends StatefulWidget {
  AddRoleView({super.key, this.oldKey});
  final String? oldKey;

  @override
  State<AddRoleView> createState() => _AddRoleViewState();
}

class _AddRoleViewState extends State<AddRoleView> {
Map<String,List<String>>allMap={};
var userManagementController = Get.find<UserManagementViewModel>();
TextEditingController nameController=TextEditingController();
@override
  void initState() {

    super.initState();
    if(widget.oldKey==null){
      userManagementController.roleModel=RoleModel(roles: {});
    }else{
      userManagementController.roleModel=userManagementController.allRole[widget.oldKey];
      allMap= userManagementController.allRole[widget.oldKey]?.roles??{};
      nameController.text=userManagementController.allRole[widget.oldKey]?.roleName??"";
    }
  }
  @override
  Widget build(BuildContext context) {
    // var all=["bond","account","product"];
    return GetBuilder<UserManagementViewModel>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.roleModel?.roleId??"new"),
            actions: [
              ElevatedButton(onPressed: (){
                controller.addRole();
              }, child: Text(controller.roleModel?.roleId==null?"add":"update"))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView(
              children: [
                Text("name"),
                 Container(
                   color: Colors.grey.shade200,
                   child: TextFormField(
                     controller: nameController,
                    onChanged: (_){
                      controller.roleModel?.roleName=_.toString();
                    },
                ),
                 ),
                for(var i in Const.allRolePage)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(i.toString(),style: TextStyle(fontSize: 25),),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Column(
                            children: [
                              checkBoxWidget(i,Const.roleUserRead,controller),
                              checkBoxWidget(i,Const.roleUserWrite,controller),
                              checkBoxWidget(i,Const.roleUserUpdate,controller),
                              checkBoxWidget(i,Const.roleUserDelete,controller),
                              checkBoxWidget(i,Const.roleUserAdmin,controller),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget checkBoxWidget(keys,text,UserManagementViewModel controller){
    return  Row(
      children: [
        StatefulBuilder(
          builder: (context,setstate) {
            return Checkbox(value: (allMap[keys]?.contains(text)??false), onChanged: (_){
              if(_!) {
                if(allMap[keys]==null){
                  allMap[keys]=[text];
                }else{
                  allMap[keys]?.add(text);
                }
              }else{
                allMap[keys]?.remove(text);
              }
              print(allMap);
              controller.roleModel?.roles=allMap;
              setstate((){});
            });
          }
        ),
        Text(text)
      ],
    );
  }
}
