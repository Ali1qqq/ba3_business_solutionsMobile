import 'package:ba3_business_solutions/controller/globle/global_view_model.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/constants/app_strings.dart';
import 'package:ba3_business_solutions/main.dart';
import 'package:ba3_business_solutions/view/invoices/pages/invoice_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tab_container/tab_container.dart';

import '../../inventory/pages/inventory_type.dart';
import '../../sellers/pages/seller_targets.dart';
import '../../sellers/pages/seller_type.dart';
import '../../settings/settings_page.dart';
import '../../userTime/pages/user_time_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  List<({String name, Widget widget, String role})> rowData = [
    // (name: "لوحة التحكم", widget: const DashboardView(), role: Const.roleViewHome),
    (
      name: AppStrings.invoices,
      widget: const InvoiceType(),
      role: AppConstants.roleViewInvoice
    ),
    Get.find<UserManagementViewModel>().myUserModel!.userSellerId != null
        ? (
            name: AppStrings.target,
            widget: SellerTarget(
              sellerId: Get.find<UserManagementViewModel>()
                  .myUserModel!
                  .userSellerId!,
            ),
            role: AppConstants.roleViewSeller
          )
        : (
            name: AppStrings.sellers,
            widget: const SellerType(),
            role: AppConstants.roleViewSeller
          ),
    (
      name: AppStrings.inventory,
      widget: const InventoryType(),
      role: AppConstants.roleViewInventory
    ),
    (
      name: AppStrings.attendance,
      widget: const UserTimeView(),
      role: AppConstants.roleViewInventory
    ),
    (
      name: AppStrings.settings,
      widget: const SettingsPage(),
      role: AppConstants.roleViewInventory
    ),
  ];
  List<({String name, Widget widget, String role})> allData = [];
  late PageController pageController;
  late TabController tabController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    allData = rowData.toList();
    tabController = TabController(
        length: allData.length, vsync: this, initialIndex: tabIndex);
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height,
                color: Colors.blue,
                child: TabContainer(
                  controller: tabController,
                  tabEdge:
                      View.of(context).platformDispatcher.locale.languageCode ==
                              'ar'
                          ? TabEdge.right
                          : TabEdge.left,
                  tabsEnd: 1,
                  tabsStart: 0,
                  tabMaxLength: 60,
                  tabExtent: MediaQuery.of(context).size.width * 0.35,
                  borderRadius: BorderRadius.circular(0),
                  tabBorderRadius: BorderRadius.circular(20),
                  childPadding: const EdgeInsets.all(0.0),
                  selectedTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                  unselectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                  ),
                  colors:
                      List.generate(rowData.length, (index) => backGroundColor),
                  tabs: List.generate(
                    rowData.length,
                    (index) {
                      return DrawerListTile(
                        index: index,
                        title: rowData[index].name.tr,
                        press: () {
                          tabController.animateTo(index);
                          tabIndex = index;
                          setState(() {});
                        },
                      );
                    },
                  ),
                  children: List.generate(
                    rowData.length,
                    (index) => const SizedBox(
                      width: 1,
                    ), // Placeholder widgets to match the tabs length
                  ), // Provide an empty list to avoid the assertion error
                )),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: allData[tabIndex].widget,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.index,
    required this.press,
  }) : super(key: key);

  final String title;
  final int index;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalViewModel>(builder: (controller) {
      return InkWell(
          onTap: press,
          child: Center(
              child: Row(
            children: [
              const SizedBox(
                width: 40,
              ),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          )));
    });
  }
}
