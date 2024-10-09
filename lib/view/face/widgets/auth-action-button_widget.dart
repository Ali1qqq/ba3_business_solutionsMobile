// import 'package:ba3_business_solutions/Const/app_constants.dart';
// import 'package:ba3_business_solutions/controller/user_management_model.dart';
// import 'package:ba3_business_solutions/view/home/home_view.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../controller/faceController/ml_service.dart';
//
//
//
// class AuthActionButtonWidget extends StatefulWidget {
//   final Future _initializeControllerFuture;
//   final Function onPressed;
//   final bool isLogin;
//   final Function reload;
//   AuthActionButtonWidget(
//     this._initializeControllerFuture, {
//     Key? key,
//     required this.onPressed,
//     required this.isLogin,
//     required this.reload,
//   });
//
//   @override
//   _AuthActionButtonState createState() => _AuthActionButtonState();
// }
//
// class _AuthActionButtonState extends State<AuthActionButtonWidget> {
//   final MLService _mlService = Get.find<MLService>();
//
//
//   Future _signUpFaceId(context) async {
//     List predictedData = _mlService.predictedData!;
//     FirebaseFirestore.instance.collection(Const.usersCollection).doc(getMyUserUserId()).update({"userFaceId":predictedData});
//     _mlService.setPredictedData([]);
//     Get.off(()=>HomeView());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         try {
//           // Ensure that the camera is initialized.
//           await widget._initializeControllerFuture;
//           // onShot event (takes the image and predict output)
//           bool faceDetected = await widget.onPressed();
//
//           if (faceDetected) {
//             if (widget.isLogin) {
//             //  var user = await _predictUser();
//             //   if (user != null) {
//             //     predictedUser = user;
//             //   }
//             }
//             PersistentBottomSheetController bottomSheetController = Scaffold.of(context).showBottomSheet((context) => signSheet(context));
//
//             bottomSheetController.closed.whenComplete(() => widget.reload());
//           }
//         } catch (e) {
//           // If an error occurs, log the error to the console.
//           print(e);
//         }
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Color(0xFF0F0BDB),
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//               color: Colors.blue.withOpacity(0.1),
//               blurRadius: 1,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         alignment: Alignment.center,
//         padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//         width: MediaQuery.of(context).size.width * 0.8,
//         height: 60,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'CAPTURE',
//               style: TextStyle(color: Colors.white),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Icon(Icons.camera_alt, color: Colors.white)
//           ],
//         ),
//       ),
//     );
//   }
//
//   signSheet(context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       child:  !widget.isLogin
//           ? ElevatedButton(
//         child: Text('SIGN UP'),
//         onPressed: () async {
//           await _signUpFaceId(context);
//         },
//       )
//           : Container()
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
