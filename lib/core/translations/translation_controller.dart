import 'dart:ui';

import 'package:get/get.dart';

class TranslationController extends GetxController {
  void changeLang(String langCode) {
    Locale locale = Locale(langCode);
    Get.updateLocale(locale);
  }
}
