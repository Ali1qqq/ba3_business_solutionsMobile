// import 'package:ba3_business_solutions/Const/const.dart';
// import 'package:ba3_business_solutions/controller/user_management_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'sign-in_screen.dart';
// import 'sign-up_screen.dart';
//
// class FaceView extends StatelessWidget {
//   const FaceView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           children: [
//             if(getMyUserFaceId()==null)
//               ElevatedButton(
//                   style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red.shade400)),
//                   onPressed: (){
//                     Get.to(()=> SignUpScreen());
//                   }, child: Text("Your Face Id Need To Configuration")),
//             if(getMyUserFaceId()!=null)
//               ElevatedButton(
//                   onPressed: (){
//                     Get.to(()=> SignIn());
//                   }, child: Text("Test Your Face")),
//             if(getMyUserFaceId()!=null)
//               ElevatedButton(onPressed: (){
//                 FirebaseFirestore.instance.collection(Const.usersCollection).doc(getMyUserUserId()).update({"userFaceId":null});
//               }, child: Text("delete face ")),
//           ],
//         ),
//       ),
//     );
//   }
// }
