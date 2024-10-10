import 'package:ba3_business_solutions/core/bindings/bindings.dart';
import 'package:ba3_business_solutions/core/translations/my_translations.dart';
import 'package:ba3_business_solutions/view/user_management/pages/account_management_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/constants/app_constants.dart';
import 'core/helper/init_app/init_app.dart';
import 'core/shared/widgets/app_scroll_behavior.dart';
import 'core/styling/app_themes.dart';
import 'core/translations/translation_controller.dart';

void main() async {
  await initializeApp();
  runApp(const MyApp());
}

const Color backGroundColor = Color(0xffE6E6E6);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TranslationController translationController =
        Get.put(TranslationController());
    return GetMaterialApp(
      initialBinding: GetBinding(),
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      locale: Locale(translationController.getLang()),
      translations: MyTranslations(),
      title: AppConstants.appTitle,
      theme: AppThemes.defaultTheme,
      home: const UserManagement(),
    );
  }
}
