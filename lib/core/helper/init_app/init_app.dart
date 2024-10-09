import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../firebase_options.dart';
import '../../constants/app_constants.dart';
import '../../utils/hive.dart';

Future initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HiveDataBase.init();
  await init();
  if (AppConstants.isNotTap) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
  if (!AppConstants.isNotTap) {
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
}

init({String? oldData, bool? isFree}) async {
  if (AppConstants.dataName == '') {
    // await FirebaseFirestore.instance.collection(settingCollection).doc(dataCollection).get().then((value) {
    //   dataName=value.data()?['defaultDataName'];
    // });
    AppConstants.dataName = "2024";
  } else {
    AppConstants.dataName = oldData!;
  }
  await HiveDataBase.setDataName(AppConstants.dataName);
  AppConstants.globalCollection = AppConstants.dataName;
  if (isFree != null) {
    AppConstants.isFreeType = isFree;
  } else {
    AppConstants.isFreeType = HiveDataBase.isFree.get("isFreeType") ?? false;
  }
}
