import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../../../controller/account/account_customer_view_model.dart';
import '../../../controller/account/account_view_model.dart';
import '../../../controller/pattern/pattern_model_view.dart';
import '../../../controller/product/product_view_model.dart';
import '../../../model/account/account_customer.dart';
import '../../constants/app_constants.dart';

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
            (element) =>
                element.customerAccountName == customerName &&
                element.customerVAT == AppConstants.mainVATCategory,
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
    case AppConstants.invPayTypeCash:
      return "نقدي";
    case AppConstants.invPayTypeDue:
      return "اجل";
  }

  return "UNKNOWN";
}

String getGlobalTypeFromEnum(String type) {
  switch (type) {
    case AppConstants.globalTypeBond:
      return "سند";
    case AppConstants.bondTypeCredit:
      return "سند  قبض";
    case AppConstants.bondTypeDaily:
      return "سند يومية";
    case AppConstants.bondTypeDebit:
      return "سند دفع";
    case AppConstants.bondTypeInvoice:
      return "سند قيد";
    case AppConstants.bondTypeStart:
      return "قيد افتتاحي";
    case AppConstants.chequeTypeCatch:
      return "شيك قبض";
    case AppConstants.chequeTypePay:
      return "شيك دفع";
  }

  return "فاتورة ${getPatModelFromPatternId(type).patName!}";
}

String getAccountPaidStatusFromEnum(String type, bool isPositive) {
  switch (type) {
    case AppConstants.paidStatusFullUsed:
      return isPositive ? "مقبوض كليا" : "مدفوع كليا";
    case AppConstants.paidStatusNotUsed:
      return isPositive ? "غير مقبوض" : "غير مدفوع";
    case AppConstants.paidStatusSemiUsed:
      return isPositive ? "مقبوض جزئيا" : "مدفوع جزئيا";
  }
  return type;
}

String getUserStatusFromEnum(String type) {
  switch (type) {
    case AppConstants.userStatusOnline:
      return "موجود";
    case AppConstants.userStatusAway:
      return "في الخارج";
  }
  return type;
}

String getInvTypeFromEnum(String type) {
  switch (type) {
    case AppConstants.invoiceTypeSales:
      return "بيع";
    case AppConstants.invoiceTypeBuy:
      return "شراء";
    case AppConstants.invoiceTypeAdd:
      return "إدخال";
    case AppConstants.invoiceTypeChange:
      return "مناقلة";
    case AppConstants.invoiceTypeSalesWithPartner:
      return "مبيعات مع نسبة شريك";
  }
  return type;
}

String getChequeTypeFromEnum(String type) {
  switch (type) {
    case AppConstants.chequeTypeCatch:
      return "شيك قبض";
    case AppConstants.chequeTypePay:
      return "شيك دفع";
  }
  return type;
}

List<String> getDatesBetween(DateTime startDate, DateTime endDate) {
  List<String> dates = [];
  DateTime currentDate = startDate;

  while (
      currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
    dates.add(currentDate.toString().split(" ")[0]);
    currentDate = currentDate.add(const Duration(days: 1));
  }

  return dates;
}

String getBondTypeFromEnum(String type) {
  switch (type) {
    case AppConstants.bondTypeDaily:
      return "سند يومية";
    case AppConstants.bondTypeDebit:
      return "سند دفع";
    case AppConstants.bondTypeCredit:
      return "سند قبض";
    case AppConstants.bondTypeStart:
      return "قيد افتتاحي";
    case AppConstants.bondTypeInvoice:
      return "سند قيد";
  }

  return type;
}

String getBondEnumFromType(String type) {
  switch (type) {
    case "سند يومية":
      return AppConstants.bondTypeDaily;
    case "سند دفع":
      return AppConstants.bondTypeDebit;
    case "سند قبض":
      return AppConstants.bondTypeCredit;
    case "قيد افتتاحي":
      return AppConstants.bondTypeStart;
    case "سند قيد":
      return AppConstants.bondTypeInvoice;
  }

  return type;
}

String getProductTypeFromEnum(String type) {
  switch (type) {
    case AppConstants.productTypeService:
      return "مواد خدمية";
    case AppConstants.productTypeStore:
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
    case AppConstants.accountTypeDefault:
      return "حساب عادي";
    case AppConstants.accountTypeFinalAccount:
      return "حساب ختامي";
    case AppConstants.accountTypeAggregateAccount:
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
    case AppConstants.chequeStatusPaid:
      return "تم الدفع";
    case AppConstants.chequeStatusNotPaid:
      return "لم يتم الدفع";
    case AppConstants.chequeStatusNotAllPaid:
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
    case AppConstants.roleUserRead:
      return "القراءة";
    case AppConstants.roleUserWrite:
      return "الكتابة";
    case AppConstants.roleUserUpdate:
      return "التعديل";
    case AppConstants.roleUserDelete:
      return "الحذف";
    case AppConstants.roleUserAdmin:
      return "الإدارة";
  }
  return "error";
}

String getPageNameFromEnum(String type) {
  switch (type) {
    case AppConstants.roleViewInvoice:
      return "الفواتير";
    case AppConstants.roleViewBond:
      return "السندات";
    case AppConstants.roleViewAccount:
      return "الحسابات";
    case AppConstants.roleViewProduct:
      return "المواد";
    case AppConstants.roleViewStore:
      return "المستودعات";
    case AppConstants.roleViewPattern:
      return "انماط البيع";
    case AppConstants.roleViewCheques:
      return "الشيكات";
    case AppConstants.roleViewSeller:
      return "البائعون";
    case AppConstants.roleViewReport:
      return "تقارير المبيعات";
    case AppConstants.roleViewImport:
      return "استيراد المعلومات";
    case AppConstants.roleViewTarget:
      return "التارغت";
    case AppConstants.roleViewTask:
      return "التاسكات";
    case AppConstants.roleViewInventory:
      return "الجرد";
    case AppConstants.roleViewUserManagement:
      return "إدارة المستخدمين";
    case AppConstants.roleViewDue:
      return "الاستحقاق";
    case AppConstants.roleViewStatistics:
      return "التقارير";
    case AppConstants.roleViewTimer:
      return "المؤقت";
    case AppConstants.roleViewDataBase:
      return "ادارة قواعد البيانات";
    case AppConstants.roleViewCard:
      return "ادارة البطاقات";
    case AppConstants.roleViewHome:
      return "الصفحة الرئيسية";
  }
  return "error";
}

String getNameOfRoleFromEnum(String type) {
  switch (type) {
    case AppConstants.roleUserRead:
      return "قراءة البيانات";
    case AppConstants.roleUserWrite:
      return "كتابة البيانات";
    case AppConstants.roleUserUpdate:
      return "تعديل البيانات";
    case AppConstants.roleUserDelete:
      return "حذف البيانات";
    case AppConstants.roleUserAdmin:
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
  cleanedInput =
      cleanedInput.replaceAllMapped(RegExp(r'(\d+)\.(\d+)\.(\d+)'), (match) {
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
    List<double> numbers =
        matches.map((match) => double.parse(match.group(0)!)).toList();

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
    case AppConstants.tabbySales:
      dueDate = getNextMonday();
    case AppConstants.stripSales:
      dueDate = DateTime.now().copyWith(day: dueDate.day + 5);
  }

  return dueDate;
}

bool getInvIsPay(String invTyp) {
  bool isPay = true;

  switch (invTyp) {
    case AppConstants.invoiceTypeBuy:
      isPay = false;
    case AppConstants.invoiceTypeSales:
      isPay = true;
    case AppConstants.invoiceTypeSalesWithPartner:
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
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

bool isWithinRegion(Position position, double targetLatitude,
    double targetLongitude, double radiusInMeters) {
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
    if (isWithinRegion(
        position, targetLatitude, targetLongitude, radiusInMeters)) {
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
  String formattedDateTime =
      "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} \n"
      "${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period";

  return formattedDateTime;
}

void sendEmail(String url, String userEmail) async {
  String username = 'ba3rak.ae@gmail.com'; // بريدك الإلكتروني
  String password = 'ggicttcumjanxath'; // كلمة المرور للتطبيق

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'اسم المرسل')
    ..recipients.add(userEmail) // البريد الإلكتروني للمستلم
    ..subject =
        'الموضوع:فاتورتك الألكترونية من برج العرب للهواتف المتحركة بتاريخ ${Timestamp.now().toDate()}'
    // ..text = 'هذا هو نص الرسالة.'
    ..html =
        "<h1>شكرا لك لزيارتك محل برج العرب للهواتف المتحركة</h1>\n<p>لمراجعة الفاتورة يمكنك تتبع الرابط التالي \n $url</p>";

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
