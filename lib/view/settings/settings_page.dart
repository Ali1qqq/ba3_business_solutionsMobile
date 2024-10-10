import 'package:ba3_business_solutions/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/translations/translation_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TranslationController translationController =
        Get.find<TranslationController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.settings.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.selectLanguage.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: Get.locale?.languageCode,
              items: [
                DropdownMenuItem(
                    value: 'ar', child: Text(AppStrings.languageArabic.tr)),
                DropdownMenuItem(
                    value: 'en', child: Text(AppStrings.languageEnglish.tr)),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  translationController.changeLang(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
