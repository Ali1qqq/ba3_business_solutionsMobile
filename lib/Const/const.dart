
import 'package:ba3_business_solutions/controller/Account_Customer_View_Model.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/model/AccountCustomer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../utils/hive.dart';

enum EnvType { debug, release }

//release :
//      send data to logger
abstract class Const {
  static String dataName = '';
  static bool isFreeType = false;

  static init({String? oldData, bool? isFree}) async {
    if (dataName == '') {
      // await FirebaseFirestore.instance.collection(settingCollection).doc(dataCollection).get().then((value) {
      //   dataName=value.data()?['defaultDataName'];
      // });
      dataName = "2024";
    } else {
      dataName = oldData!;
    }
    await HiveDataBase.setDataName(dataName);
    globalCollection = dataName;
    if (isFree != null) {
      isFreeType = isFree;
    } else {
      isFreeType = HiveDataBase.isFree.get("isFreeType") ?? false;
    }
  }

  static const EnvType env = EnvType.debug; //"debug" or "release"
  static const vatGCC = 0.05;
  static const constHeightTextField = 35.0;
  static const vat0_01 = 0.01;
  static const rowCustomBondAmount = 'rowCustomBondAmount';
  static const rowBondId = 'id';
  static const rowBondCreditAmount = 'credit';
  static const rowBondDebitAmount = 'debit';
  static const rowBondAccount = 'secondary';
  static const rowBondDescription = 'description';
  static const noVatKey = 'noVat-';
  static const minMobileTarget = 1000;
  static const minOtherTarget = 1000;



  /*static String changesInvoiceCollection = "$dataName-Changes-invoice";
  static String changesProdCollection = "$dataName-Changes-prod";
  static String changesAccountCollection = "$dataName-Changes-account";
  static String changesWarrantyCollection = "$dataName-Changes-warranty";
  static String changesBondCollection = "$dataName-Changes-bond";
  static String changesChequeCollection = "$dataName-Changes-cheque";*/
  ////////////--------------------------------------------------
  static String changesCollection = "$dataName-Changes";
  static const recordCollection = 'Record';
  static String bondsCollection = 'Bonds';
  static String accountsCollection = 'Accounts';
  static String tasksCollection = 'Tasks';
  static String invoicesCollection = 'Invoices';
  static String warrantyCollection = 'Warranty';

  static String productsCollection = "Products";
  static String logsCollection = "Logs";
  static String patternCollection = "Patterns";
  static String storeCollection = "Stores";
  static String chequesCollection = "Cheques";
  static String costCenterCollection = "CostCenter";
  static String sellersCollection = "Sellers";
  static String usersCollection = "users";
  static String roleCollection = "Role";
  static String settingCollection = "Setting";
  static String readFlagsCollection = "ReadFlags";
  static String inventoryCollection = "Inventory";
  static String globalCollection = dataName;
  static String ba3Invoice = "ba3Invoice";
  static String dataCollection = "data";

  ////////////--------------------------------------------------
  static const rowAccountId = 'rowAccountId';
  static const rowAccountTotal = 'rowAccountTotal';
  static const rowAccountTotal2 = 'rowAccountTotal2';
  static const rowAccountType = 'rowAccountType';
  static const rowAccountName = 'rowAccountName';
  static const rowAccountDate = 'rowAccountDate';
  static const rowAccountBalance = 'rowAccountBalance';

  ////////////--------------------------------------------------
  static const rowInvId = "invId";
  static const rowInvProduct = "invProduct";
  static const rowInvGift = "rowInvGift";
  static const rowInvQuantity = "invQuantity";
  static const rowInvSubTotal = "invSubTotal";
  static const rowInvVat = "rowInvVat";
  static const rowInvTotal = "invTotal";
  static const rowInvTotalVat = "rowInvTotalVat";
  static const rowInvDiscountId = "rowInvDiscountId";
  static const rowInvDiscountAccount = "rowInvDiscountAccount";
  static const rowInvDisAddedTotal = "rowInvDisAddedTotal";
  static const rowInvDisAddedPercentage = "rowInvDisAddedPercentage";
  static const rowInvDisDiscountTotal = "rowInvDisDiscountTotal";
  static const rowInvDisDiscountPercentage = "rowInvDisDiscountPercentage";

  ////////////--------------------------------------------------
  static const rowViewAccountId = "rowViewAccountId";
  static const rowViewAccountName = "rowViewAccountName";
  static const rowViewAccountCode = "rowViewAccountCode";
  static const rowViewAccountBalance = "rowViewAccountBalance";
  static const rowViewAccountLength = "rowViewAccountLength";

  ////////////--------------------------------------------------
  static const rowProductRecProduct = "rowProductRecProduct";
  static const rowProductType = "rowProductType";
  static const rowProductQuantity = "rowProductQuantity";
  static const rowProductDate = "rowProductDate";
  static const rowProductTotal = "rowProductTotal";
  static const rowProductInvId = "rowProductInvId";
  static const productTypeService = "productTypeService";
  static const productTypeStore = "productTypeStore";

  ////////////--------------------------------------------------
  static const bondTypeDaily = /*"سند يومية";*/ "bondTypeDaily";
  static const bondTypeDebit = /*"سند قبض";*/ "bondTypeDebit";
  static const bondTypeCredit = /*"سند دفع";*/ "bondTypeCredit";
  static const bondTypeStart = /*"قيد افتتاحي";*/ "bondTypeStart";
  static const bondTypeInvoice = /*"سند قيد";*/ "bondTypeInvoice";

  ////////////--------------------------------------------------
  static const patId = "patId";
  static const patCode = "patCode";
  static const patPrimary = "patPrimary";
  static const patName = "patName";
  static const patType = "patType";

  ////////////--------------------------------------------------
  static const invoiceTypeSales = "invoiceTypeSales";
  static const invoiceTypeSalesWithPartner = "invoiceTypeSalesWithPartner";
  static const invoiceTypeBuy = 'invoiceTypeBuy';
  static const invoiceTypeAdd = "invoiceTypeAdd";
  static const invoiceTypeChange = "invoiceTypeChange";
  static const tabbySales = "م Tabby";
  static const stripSales = "م Strip";
  static const cardSales = "م Card";

  ////////////--------------------------------------------------
  static const stCode = "stCode";
  static const stId = "stId";
  static const stName = "stName";

  ////////////--------------------------------------------------
  static const rowViewCheqId = 'rowViewCheqId';
  static const rowViewChequeStatus = 'rowViewChequeStatus';
  static const rowViewChequePrimeryAccount = 'rowViewChequePrimeryAccount';
  static const rowViewChequeSecoundryAccount = 'rowViewChequeSecoundryAccount';
  static const rowViewChequeAllAmount = 'rowViewChequeAllAmount';
  static const chequeStatusPaid = 'chequeStatusPaid';
  static const chequeStatusNotPaid = 'chequeStatusNotPaid';
  static const chequeStatusNotAllPaid = 'chequeStatusNotAllPaid';
  static const chequeTypePay = 'chequeTypePay';
  static const chequeTypeCatch = 'chequeTypeCatch';
  static const chequeTypeList = [chequeTypePay, chequeTypeCatch];
  static const chequeRecTypeInit = 'chequeRecTypeInit';
  static const chequeRecTypeAllPayment = 'chequeRecTypeAllPayment';
  static const chequeRecTypePartPayment = 'chequeRecTypePartPayment';

  ////////////--------------------------------------------------
  static const accountTypeDefault = "accountTypeDefault";
  static const accountTypeFinalAccount = "accountTypeFinalAccount";
  static const accountTypeAggregateAccount = "accountTypeAggregateAccount";
  static const accountTypeList = [accountTypeDefault, accountTypeFinalAccount, accountTypeAggregateAccount];

  ////////////--------------------------------------------------
  static const rowSellerAllInvoiceInvId = "rowSellerAllInvoiceInvId";
  static const rowSellerAllInvoiceAmount = "rowSellerAllInvoiceAmount";
  static const rowSellerAllInvoiceDate = "rowSellerAllInvoiceDate";

  ////////////--------------------------------------------------
  static const rowImportName = "rowImportName";
  static const rowImportPrice = "rowImportPrice";
  static const rowImportBarcode = "rowImportBarcode";
  static const rowImportCode = "rowImportCode";
  static const rowImportGroupCode = "rowImportGroupCode";
  static const rowImportHasVat = "rowImportHasVat";

  ////////////--------------------------------------------------
  static const roleUserRead = "roleUserRead";
  static const roleUserWrite = "roleUserWrite";
  static const roleUserUpdate = "roleUserUpdate";
  static const roleUserDelete = "roleUserDelete";
  static const roleUserAdmin = "roleUserAdmin";
  static const roleViewBond = "roleViewBond";
  static const roleViewAccount = "roleViewAccount";
  static const roleViewInvoice = "roleViewInvoice";
  static const roleViewProduct = "roleViewProduct";
  static const roleViewStore = "roleViewStore";
  static const roleViewPattern = "roleViewPattern";
  static const roleViewCheques = "roleViewCheques";
  static const roleViewSeller = "roleViewSeller";
  static const roleViewReport = "roleViewReport";
  static const roleViewImport = "roleViewImport";
  static const roleViewTask = "roleViewTask";
  static const roleViewTarget = "roleViewTarget";
  static const roleViewInventory = "roleViewInventory";
  static const roleViewUserManagement = "roleViewUserManagement";
  static const roleViewDue = "roleViewDue";
  static const roleViewStatistics = "roleViewStatistics";
  static const roleViewTimer = "roleViewTimer";
  static const roleViewDataBase = "roleViewDataBase";
  static const roleViewCard = "roleViewCard";
  static const roleViewHome = "roleViewHome";
  static const allRolePage = [
    roleViewBond,
    roleViewAccount,
    roleViewInvoice,
    roleViewProduct,
    roleViewStore,
    roleViewPattern,
    roleViewCheques,
    roleViewSeller,
    roleViewReport,
    roleViewTarget,
    roleViewInventory,
    roleViewTask,
    roleViewImport,
    roleViewUserManagement,
    roleViewDue,
    roleViewStatistics,
    roleViewTimer,
    roleViewDataBase,
    roleViewCard,
    roleViewHome
  ];

  ////////////--------------------------------------------------
  static const invoiceChoosePriceMethodeCustomerPrice = "invoiceChoosePriceMethodeCustomerPrice";
  static const invoiceChoosePriceMethodeDefault = "invoiceChoosePriceMethodeCustomerPrice";
  static const invoiceChoosePriceMethodeLastPrice = "invoiceChoosePriceMethodeLastPrice";
  static const invoiceChoosePriceMethodeAveragePrice = "invoiceChoosePriceMethodeAveragePrice";
  static const invoiceChoosePriceMethodeHigher = "invoiceChoosePriceMethodeHigher";
  static const invoiceChoosePriceMethodeLower = "invoiceChoosePriceMethodeLower";
  static const invoiceChoosePriceMethodeMinPrice = "invoiceChoosePriceMethodeMinPrice";
  static const invoiceChoosePriceMethodeAverageBuyPrice = "invoiceChoosePriceMethodeAverageBuyPrice";
  static const invoiceChoosePriceMethodeWholePrice = "invoiceChoosePriceMethodeWholePrice";
  static const invoiceChoosePriceMethodeRetailPrice = "invoiceChoosePriceMethodeRetailPrice";
  static const invoiceChoosePriceMethodeCostPrice = "invoiceChoosePriceMethodeCostPrice";
  static const invoiceChoosePriceMethodeCustom = "invoiceChoosePriceMethodeCustom";

  ////////////--------------------------------------------------
  static const rowAccountAggregateName = "rowAccountAggregateName";

  ////////////---------------------------------------------------
  static const globalTypeInvoice = "globalTypeInvoice";
  static const globalTypeBond = "globalTypeBond";
  static const globalTypeCheque = "globalTypeCheque";
  static const globalTypeAccountDue = "globalAccountDue";
  static const globalTypeStartersBond = "globalTypeStartersBond";

  ////////////---------------------------------------------------
  static const invoiceRecordCollection = "invoiceRecord";
  static const bondRecordCollection = "bondRecord";
  static const chequeRecordCollection = "chequeRecord";

  ////////////----------------------------------------------------
  static const productsAllSubscription = "productsAllSubscription";

  ////////////----------------------------------------------------
  static const paidStatusFullUsed = "paidStatusFullUse";
  static const paidStatusNotUsed = "paidStatusNotUsed";
  static const paidStatusSemiUsed = "paidStatusSemiUsed";

  ////////////----------------------------------------------------
  static const userStatusOnline = "userStatusOnline";
  static const userStatusAway = "userStatusAway";

  ////////////----------------------------------------------------
  static const invPayTypeDue = "invPayTypeDue";
  static const invPayTypeCash = "invPayTypeCash";

  /////////////---------------------------------------------------
  static const taskTypeProduct = 'taskTypeProduct';
  static const taskTypeInventory = 'taskTypeInventory';

  static const typeAccountView = "typeAccountView";
  static const typeAccountDueView = "typeAccountDueView";

  static const salleTypeId = "pat1706468132863249";

  /////////////---------------------------------------------------
  static const mainVATCategory = "SR-التصنيف الأساسي";
  static const withoutVAT = "EX-معفى";
  static String vatAccountId = getAccountIdFromText("ضريبة القيمة المضافة رأس الخيمة");
  static String returnVatAccountId = getAccountIdFromText("استرداد ضريبة القيمة المضافة رأس الخيمة");

  /////////////---------------------------------------------------
  static const firstTimeEnter = "FirstTimeEnter";
  static const secondTimeEnter = "secondTimeEnter";
  static const firstTimeOut = "secondTimeEnter";
  static const secondTimeOut = "secondTimeEnter";
  static const breakTime = "secondTimeEnter";

  static bool isNotTap=true;
}

bool getIfAccountHaveCustomers(String accId) {
  if (accId.startsWith("acc")) {
    return getAccountModelFromId(accId)?.accCustomer?.firstOrNull != null;
  } else {
    return getAccountModelFromName(accId)?.accCustomer?.firstOrNull != null;
  }
}

bool getCustomerHaveVAT(String customerName) {
  bool withVAT = true;
  withVAT = Get.find<AccountCustomerViewModel>()
          .customerMap
          .values
          .where(
            (element) => element.customerAccountName == customerName && element.customerVAT == Const.mainVATCategory,
          )
          .firstOrNull !=
      null;
  return withVAT;
}

List<AccountCustomer> getAccountCustomers(String accId) {
  if (accId.startsWith("acc")) {
    return getAccountModelFromId(accId)!.accCustomer!;
  } else {
    return getAccountModelFromName(accId)!.accCustomer!;
  }
}

String getInvPayTypeFromEnum(String type) {
  switch (type) {
    case Const.invPayTypeCash:
      return "نقدي";
    case Const.invPayTypeDue:
      return "اجل";
  }

  return "UNKNOWN";
}

String getGlobalTypeFromEnum(String type) {
  switch (type) {
    case Const.globalTypeBond:
      return "سند";
    case Const.bondTypeCredit:
      return "سند  قبض";
    case Const.bondTypeDaily:
      return "سند يومية";
    case Const.bondTypeDebit:
      return "سند دفع";
    case Const.bondTypeInvoice:
      return "سند قيد";
    case Const.bondTypeStart:
      return "قيد افتتاحي";
    case Const.chequeTypeCatch:
      return "شيك قبض";
    case Const.chequeTypePay:
      return "شيك دفع";
  }

  return "فاتورة ${getPatModelFromPatternId(type).patName!}";
}

String getAccountPaidStatusFromEnum(String type, bool isPositive) {
  switch (type) {
    case Const.paidStatusFullUsed:
      return isPositive ? "مقبوض كليا" : "مدفوع كليا";
    case Const.paidStatusNotUsed:
      return isPositive ? "غير مقبوض" : "غير مدفوع";
    case Const.paidStatusSemiUsed:
      return isPositive ? "مقبوض جزئيا" : "مدفوع جزئيا";
  }
  return type;
}

String getUserStatusFromEnum(String type) {
  switch (type) {
    case Const.userStatusOnline:
      return "موجود";
    case Const.userStatusAway:
      return "في الخارج";
  }
  return type;
}

String getInvTypeFromEnum(String type) {
  switch (type) {
    case Const.invoiceTypeSales:
      return "بيع";
    case Const.invoiceTypeBuy:
      return "شراء";
    case Const.invoiceTypeAdd:
      return "إدخال";
    case Const.invoiceTypeChange:
      return "مناقلة";
    case Const.invoiceTypeSalesWithPartner:
      return "مبيعات مع نسبة شريك";
  }
  return type;
}

String getChequeTypeFromEnum(String type) {
  switch (type) {
    case Const.chequeTypeCatch:
      return "شيك قبض";
    case Const.chequeTypePay:
      return "شيك دفع";
  }
  return type;
}

List<String> getDatesBetween(DateTime startDate, DateTime endDate) {
  List<String> dates = [];
  DateTime currentDate = startDate;

  while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
    dates.add(currentDate.toString().split(" ")[0]);
    currentDate = currentDate.add(const Duration(days: 1));
  }

  return dates;
}

String getBondTypeFromEnum(String type) {
  switch (type) {
    case Const.bondTypeDaily:
      return "سند يومية";
    case Const.bondTypeDebit:
      return "سند دفع";
    case Const.bondTypeCredit:
      return "سند قبض";
    case Const.bondTypeStart:
      return "قيد افتتاحي";
    case Const.bondTypeInvoice:
      return "سند قيد";
  }

  return type;
}

String getBondEnumFromType(String type) {
  switch (type) {
    case "سند يومية":
      return Const.bondTypeDaily;
    case "سند دفع":
      return Const.bondTypeDebit;
    case "سند قبض":
      return Const.bondTypeCredit;
    case "قيد افتتاحي":
      return Const.bondTypeStart;
    case "سند قيد":
      return Const.bondTypeInvoice;
  }

  return type;
}

String getProductTypeFromEnum(String type) {
  switch (type) {
    case Const.productTypeService:
      return "مواد خدمية";
    case Const.productTypeStore:
      return "مواد مستودعية";
  }
  return type;
}

String getPatNameFromId(String id) {
// return "سند مولد من فاتورة ${Get.find<PatternViewModel>().patternModel[id]?.patName}";
  return Get.find<PatternViewModel>().patternModel[id]?.patName ?? "";
}

String getPatTypeFromId(String id) {
// return "سند مولد من فاتورة ${Get.find<PatternViewModel>().patternModel[id]?.patName}";
  return Get.find<PatternViewModel>().patternModel[id]?.patType ?? "";
}

String getAccountTypeFromEnum(String type) {
  switch (type) {
    case Const.accountTypeDefault:
      return "حساب عادي";
    case Const.accountTypeFinalAccount:
      return "حساب ختامي";
    case Const.accountTypeAggregateAccount:
      return "حساب تجميعي";
    // case Const.accountTypeChequeCatch:
    //   return "حساب شيكات قبض";
    // case Const.accountTypeChequePay:
    //   return "حساب شيكات دفع";
    // case Const.accountTypeBank:
    //   return "حساب مصرف";
  }
  return "error";
}

String getChequeStatusfromEnum(String type) {
  switch (type) {
    case Const.chequeStatusPaid:
      return "تم الدفع";
    case Const.chequeStatusNotPaid:
      return "لم يتم الدفع";
    case Const.chequeStatusNotAllPaid:
      return "تم الدفع جزئبا";
  }
  return "error";
}

double getVatFromName(text) {
  return text == "a"
      ? 0
      : text == "GCC"
          ? 0.05
          : 0;
}

String getRoleNameFromEnum(String type) {
  switch (type) {
    case Const.roleUserRead:
      return "القراءة";
    case Const.roleUserWrite:
      return "الكتابة";
    case Const.roleUserUpdate:
      return "التعديل";
    case Const.roleUserDelete:
      return "الحذف";
    case Const.roleUserAdmin:
      return "الإدارة";
  }
  return "error";
}

String getPageNameFromEnum(String type) {
  switch (type) {
    case Const.roleViewInvoice:
      return "الفواتير";
    case Const.roleViewBond:
      return "السندات";
    case Const.roleViewAccount:
      return "الحسابات";
    case Const.roleViewProduct:
      return "المواد";
    case Const.roleViewStore:
      return "المستودعات";
    case Const.roleViewPattern:
      return "انماط البيع";
    case Const.roleViewCheques:
      return "الشيكات";
    case Const.roleViewSeller:
      return "البائعون";
    case Const.roleViewReport:
      return "تقارير المبيعات";
    case Const.roleViewImport:
      return "استيراد المعلومات";
    case Const.roleViewTarget:
      return "التارغت";
    case Const.roleViewTask:
      return "التاسكات";
    case Const.roleViewInventory:
      return "الجرد";
    case Const.roleViewUserManagement:
      return "إدارة المستخدمين";
    case Const.roleViewDue:
      return "الاستحقاق";
    case Const.roleViewStatistics:
      return "التقارير";
    case Const.roleViewTimer:
      return "المؤقت";
    case Const.roleViewDataBase:
      return "ادارة قواعد البيانات";
    case Const.roleViewCard:
      return "ادارة البطاقات";
    case Const.roleViewHome:
      return "الصفحة الرئيسية";
  }
  return "error";
}

String getNameOfRoleFromEnum(String type) {
  switch (type) {
    case Const.roleUserRead:
      return "قراءة البيانات";
    case Const.roleUserWrite:
      return "كتابة البيانات";
    case Const.roleUserUpdate:
      return "تعديل البيانات";
    case Const.roleUserDelete:
      return "حذف البيانات";
    case Const.roleUserAdmin:
      return "إدارة البيانات";
  }
  return type;
}

String extractNumbersAndCalculate(String input) {
  // استبدال الفاصلة العربية بالنقطة

  input = replaceArabicNumbersWithEnglish(input);
  String cleanedInput = input.replaceAll('٫', '.');

  // تحقق مما إذا كانت السلسلة تحتوي على معاملات حسابية
  bool hasOperators = cleanedInput.contains(RegExp(r'[+\-*/]'));

  // معالجة الفواصل الزائدة بحيث تبقى فقط الفاصلة الأولى
  cleanedInput = cleanedInput.replaceAllMapped(RegExp(r'(\d+)\.(\d+)\.(\d+)'), (match) {
    return '${match.group(1)}.${match.group(2)}';
  });
  if (hasOperators) {
    // إذا كان هناك معاملات، قم باستخراج الأرقام والعمليات وإجراء الحسابات
    RegExp regex = RegExp(r'[0-9.]+|[+\-*/]');
    Iterable<Match> matches = regex.allMatches(cleanedInput);
    List<String> elements = matches.map((match) => match.group(0)!).toList();

    List<double> numbers = [];
    String? operation;

    for (var element in elements) {
      if (double.tryParse(element) != null) {
        double number = double.parse(element);
        if (operation == null) {
          numbers.add(number);
        } else {
          double lastNumber = numbers.removeLast();
          switch (operation) {
            case '+':
              numbers.add(lastNumber + number);
              break;
            case '-':
              numbers.add(lastNumber - number);
              break;
            case '*':
              numbers.add(lastNumber * number);
              break;
            case '/':
              numbers.add(lastNumber / number);
              break;
          }
          operation = null;
        }
      } else {
        operation = element;
      }
    }

    return numbers.isNotEmpty ? numbers.first.toString() : "0.0";
  } else {
    //! إذا لم يكن هناك معاملات، فقط استخرج الأرقام /
    RegExp regex = RegExp(r'[0-9.]+');
    Iterable<Match> matches = regex.allMatches(cleanedInput);
    List<double> numbers = matches.map((match) => double.parse(match.group(0)!)).toList();

    // إذا لم توجد أرقام، قم بإرجاع 0
    return numbers.isNotEmpty ? numbers.first.toString() : "0.0";
  }
}

String formatNumberWithCommas(int number) {
  // تحويل الرقم إلى سلسلة نصية وتنسيقه باستخدام RegExp لإضافة الفاصلة كل ثلاث خانات
  return number.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (Match match) => '${match[1]},',
      );
}

String formatDecimalNumberWithCommas(double number) {
  // ضبط الرقم العشري إلى رقمين بعد الفاصلة
  String formattedNumber = number.toStringAsFixed(2);

  // تحويل الرقم إلى سلسلة نصية وتجزئته إلى جزء صحيح وجزء عشري
  List<String> parts = formattedNumber.split('.');
  String integerPart = parts[0]; // الجزء الصحيح
  String decimalPart = parts[1]; // الجزء العشري المحدد إلى رقمين

  // تنسيق الجزء الصحيح باستخدام RegExp لإضافة الفاصلة كل ثلاث خانات
  String formattedIntegerPart = integerPart.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (Match match) => '${match[1]},',
  );

  return '$formattedIntegerPart.$decimalPart';
}

bool hasCommonElements(List<dynamic> list1, List<dynamic> list2) {
  // تحويل القائمتين إلى مجموعات (Sets)
  Set<dynamic> set1 = list1.toSet();
  Set<dynamic> set2 = list2.toSet();

  // التحقق من وجود أي عنصر مشترك بين المجموعتين
  return set1.intersection(set2).isNotEmpty;
}

DateTime getDueDate(String invTyp) {
  DateTime dueDate = DateTime.now();

  switch (invTyp) {
    case Const.tabbySales:
      dueDate = getNextMonday();
    case Const.stripSales:
      dueDate = DateTime.now().copyWith(day: dueDate.day + 5);
  }

  return dueDate;
}

bool getInvIsPay(String invTyp) {
  bool isPay = true;

  switch (invTyp) {
    case Const.invoiceTypeBuy:
      isPay = false;
    case Const.invoiceTypeSales:
      isPay = true;
    case Const.invoiceTypeSalesWithPartner:
      isPay = false;
    default:
      isPay = true;
  }

  return isPay;
}

DateTime getNextMonday() {
  DateTime now = DateTime.now();

  // حساب الأيام المتبقية للوصول إلى الاثنين القادم
  int daysUntilMonday = DateTime.monday - now.weekday;

  // إذا كان اليوم الاثنين بالفعل، اجعل الأيام +7 للوصول إلى الاثنين القادم
  if (daysUntilMonday <= 0) {
    daysUntilMonday += 7;
  }

  // إضافة الأيام المتبقية إلى التاريخ الحالي للحصول على الاثنين القادم
  return now.add(Duration(days: daysUntilMonday));
}

Future<Position?> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // تحقق من تمكين خدمات الموقع
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null; // إذا لم يتم تمكين الموقع
  }

  // تحقق من إذن الموقع
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null; // إذا تم رفض الإذن
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return null; // إذا تم رفض الإذن بشكل دائم
  }

  // الحصول على الموقع الحالي
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

bool isWithinRegion(Position position, double targetLatitude, double targetLongitude, double radiusInMeters) {
  double distanceInMeters = Geolocator.distanceBetween(
    position.latitude,
    position.longitude,
    targetLatitude,
    targetLongitude,
  );

  return distanceInMeters <= radiusInMeters;
}

bool checkLogin(Position? position) {
  if (position != null) {
    double targetLatitude = 25.79357172212387; // Latitude المنطقة المستهدفة
    double targetLongitude = 55.94839519940061; // Longitude المنطقة المستهدفة
    double radiusInMeters = 15; // نصف القطر بالمتر
    // 25.79357172212387, 55.94839519940061
    // 25.793297676709503, 55.94835295584547
    if (isWithinRegion(position, targetLatitude, targetLongitude, radiusInMeters)) {
      print("المستخدم داخل المنطقة");
      // السماح بتسجيل الدخول
      return true;
    } else {
      print("المستخدم خارج المنطقة");
      // منع تسجيل الدخول
      return false;
    }
  } else {
    print("لا يمكن الحصول على الموقع");
    return false;
  }
}

String formatDateTimeFromString(String isoString) {
  DateTime dateTime = DateTime.parse(isoString);

  // تحديد الفترة (AM/PM)
  String period = dateTime.hour >= 12 ? "PM" : "AM";

  // تحويل الساعة إلى تنسيق 12 ساعة
  int hour = dateTime.hour % 12;
  if (hour == 0) hour = 12; // تحويل الساعة 0 إلى 12

  // تنسيق التاريخ والوقت
  String formattedDateTime = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} \n"
      "${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period";

  return formattedDateTime;
}

void sendEmail(String url,String userEmail) async {

  String username = 'ba3rak.ae@gmail.com'; // بريدك الإلكتروني
  String password = 'ggicttcumjanxath'; // كلمة المرور للتطبيق

  final smtpServer = gmail(username, password);


  final message = Message()
    ..from = Address(username, 'اسم المرسل')
    ..recipients.add(userEmail) // البريد الإلكتروني للمستلم
    ..subject = 'الموضوع:فاتورتك الألكترونية من برج العرب للهواتف المتحركة بتاريخ ${Timestamp.now().toDate()}'
    // ..text = 'هذا هو نص الرسالة.'
    ..html = "<h1>شكرا لك لزيارتك محل برج العرب للهواتف المتحركة</h1>\n<p>لمراجعة الفاتورة يمكنك تتبع الرابط التالي \n $url</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('تم إرسال البريد الإلكتروني بنجاح: $sendReport');
  } on MailerException catch (e) {
    print('حدث خطأ أثناء الإرسال: ${e.toString()}');
    for (var p in e.problems) {
      print('مشكلة: ${p.code}: ${p.msg}');
    }
  }
}
