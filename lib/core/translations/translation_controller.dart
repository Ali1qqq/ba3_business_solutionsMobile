import 'dart:ui';

import 'package:ba3_business_solutions/core/utils/hive.dart';
import 'package:get/get.dart';

class TranslationController extends GetxController {
  String getLang() => HiveDataBase.getAppLangCode;

  Future<void> changeLang(String langCode) async {
    await HiveDataBase.setAppLangCode(langCode);
    Get.updateLocale(Locale(langCode));
  }
}
