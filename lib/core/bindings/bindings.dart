import 'package:ba3_business_solutions/controller/account/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/user/cards_view_model.dart';
import 'package:ba3_business_solutions/controller/cheque/cheque_view_model.dart';
import 'package:ba3_business_solutions/controller/cost/cost_center_view_model.dart';
import 'package:ba3_business_solutions/controller/bond/entry_bond_view_model.dart';

import 'package:ba3_business_solutions/controller/databsae/import_view_model.dart';
import 'package:ba3_business_solutions/controller/inventory/inventory_view_model.dart';
import 'package:ba3_business_solutions/controller/invoice/invoice_view_model.dart';
import 'package:ba3_business_solutions/controller/isolate/isolate_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/print/print_view_model.dart';
import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store/store_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/target_view_model.dart';
import 'package:ba3_business_solutions/view/invoices/Controller/Screen_View_Model.dart';
import 'package:ba3_business_solutions/view/invoices/Controller/Search_View_Controller.dart';
import 'package:get/get.dart';
import '../../controller/pluto/pluto_view_model.dart';
import '../../controller/account/account_customer_view_model.dart';
import '../../controller/databsae/database_view_model.dart';

import '../../controller/globle/changes_view_model.dart';
import '../../controller/user/user_management_model.dart';
import '../../controller/warranty/warranty_view_model.dart';

class GetBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ScreenViewModel());
    // Get.put(GlobalViewModel());
    Get.put(SearchViewController());
    Get.put(EntryBondViewModel());
    Get.put(ImportViewModel());
    Get.put(ProductViewModel());
    Get.put(UserManagementViewModel());
    Get.put(AccountViewModel());
    Get.put(StoreViewModel());
    Get.put(BondViewModel());
    Get.put(PatternViewModel());
    Get.put(SellersViewModel());
    Get.put(InvoiceViewModel());
    Get.put(ChequeViewModel());
    Get.put(CostCenterViewModel());
    Get.put(InventoryViewModel());
    Get.put(AccountCustomerViewModel());
    Get.put(WarrantyViewModel());

    // Get.put(IsolateViewModel());
    Get.put(DataBaseViewModel());
    Get.put(CardsViewModel());
    Get.put(TargetViewModel());
    Get.put(PrintViewModel());
    Get.put(PlutoViewModel());

    Get.lazyPut(() => ChangesViewModel(), fenix: true);
  }
}
