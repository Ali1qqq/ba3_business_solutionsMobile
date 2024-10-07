import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}
class _UserManagementState extends State<UserManagement> {

  @override
  void initState() {


  
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
    userManagementViewController.checkUserStatus();
    return const Scaffold(
        body: Center(
      child: Text("يتم تسجيل الدخول"),
    ));
  }
}
