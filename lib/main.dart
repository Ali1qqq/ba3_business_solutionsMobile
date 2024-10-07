import 'dart:ui';
import 'package:ba3_business_solutions/core/bindings.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:ba3_business_solutions/view/user_management/account_management_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'Const/const.dart';
import 'controller/changes_view_model.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // WindowOptions windowOptions = const WindowOptions(
  //   size: Size(800, 600),
  //   center: true,
  //   backgroundColor: Colors.transparent,
  //   titleBarStyle: TitleBarStyle.hidden,
  // );
  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  // });



  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HiveDataBase.init();
  await Const.init();
  if(Const.isNotTap) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
  if(!Const.isNotTap) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }


  HardwareKeyboard.instance.addHandler(
    (event) {
      if (HardwareKeyboard.instance.isControlPressed &&
          HardwareKeyboard.instance.isShiftPressed &&
          HardwareKeyboard.instance
              .isPhysicalKeyPressed(PhysicalKeyboardKey.keyC)) {
        HiveDataBase.setIsFree(!HiveDataBase.getWithFree());

      return true;
      }
      return false;
    },
  );
  // FirebaseFirestore.instance.collection("2024").doc("bon1720282515909594").delete();
  //  HiveDataBase.globalModelBox.delete("bon1720282515909594");
  // FirebaseFirestore.instance.collection("2024").count().get().then((value) => print(value.count),);
  // HiveDataBase.globalModelBox.deleteFromDisk();
  runApp(const MyApp());


}


const Color backGroundColor =Color(0xffE6E6E6);
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: GetBinding(),
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      locale: const Locale("ar"),
      title: "Ba3 Business",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffE6E6E6),
        fontFamily: 'Almarai',
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xffE6E6E6),
            foregroundColor: Colors.black,
            surfaceTintColor:  Color(0xffE6E6E6),
            elevation: 0),
        elevatedButtonTheme:  ElevatedButtonThemeData(
            style: ButtonStyle(
              foregroundColor:  const WidgetStatePropertyAll(Colors.white),
          backgroundColor: WidgetStatePropertyAll(Colors.blue.shade700),
          elevation: const WidgetStatePropertyAll(5),
        )),
        colorScheme: ColorScheme.fromSeed(
            primary: Colors.black,
            seedColor: Colors.black,
            background: Colors.white),
        useMaterial3: true,
      ),
      home: const UserManagement(),
    );
  }
}
class AppScrollBehavior extends MaterialScrollBehavior{
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad
  };
}
//