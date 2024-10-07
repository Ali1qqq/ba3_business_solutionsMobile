import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/user_management_model.dart';
class TimeDetails extends StatefulWidget {
  final String oldKey;
  final String name;
  const TimeDetails({super.key, required this.oldKey, required this.name});

  @override
  State<TimeDetails> createState() => _TimeDetailsState();
}

class _TimeDetailsState extends State<TimeDetails> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: GetBuilder<UserManagementViewModel>(
          builder: (controller) {
            // UserModel userModel = controller.allUserList[widget.oldKey]!;
            return const SizedBox();
            // return ListView.builder(
            //   itemCount: userModel.userTimeRecord!.length,
            //   itemBuilder: (context, index) {
            //     UserTimeRecord model =  userModel.userTimeRecord![index];
            //   return Text(model.date.toString() +"  "+ model.time.toString());
            // },);
          },
        ),
      ),
    );
  }
}
