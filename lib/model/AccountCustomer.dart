import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:pluto_grid/pluto_grid.dart';

class AccountCustomer {
  String? customerVAT;
  String? customerCardNumber;
  String? customerAccountName;
  String? mainAccount;
  String? customerAccountId;

  // Constructor
  AccountCustomer({
    this.customerVAT,
    this.customerCardNumber,
    this.customerAccountName,
    this.mainAccount,
    this.customerAccountId,
  });
  // fromJson: لتحويل البيانات من JSON إلى كائن AccountCustomer
   AccountCustomer.fromJson(Map<dynamic, dynamic> json) {

      customerVAT= json['customerVAT'];
      customerCardNumber= json['customerCardNumber'];
      customerAccountName= json['customerAccountName'];
      mainAccount= json['mainAccount'];
      customerAccountId= json['customerAccountId'] ;

  }
  AccountCustomer.fromJsonPluto(Map<dynamic, dynamic> json,String mainAccountId) {

    customerVAT= json['customerVAT'];
    customerCardNumber= json['customerCardNumber'];
    customerAccountName= json['customerAccountName'];
    mainAccount=mainAccountId;
    customerAccountId= json['customerAccountId']??generateId(RecordType.accCustomer) ;

  }

  // toJson: لتحويل كائن AccountCustomer إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'customerVAT': customerVAT,
      'customerCardNumber': customerCardNumber,
      'customerAccountName': customerAccountName,
      'mainAccount': mainAccount,
      'customerAccountId': customerAccountId,
    };
  }

  Map<PlutoColumn, dynamic> toEditedMap() {
    return {
      PlutoColumn(
        title: 'الرقم',
        field: 'customerAccountId',
        readOnly: true,
        hide: true,
        type: PlutoColumnType.text(),
      ): customerAccountId,
      PlutoColumn(
        title: 'رقم بطاقة الزبون',
        field: 'customerCardNumber',
        type: PlutoColumnType.text()
      ): customerCardNumber,

      PlutoColumn(
        title: 'اسم الزبون',
        field: 'customerAccountName',
        type: PlutoColumnType.text(),

      ): customerAccountName,

      PlutoColumn(
        title: 'نوع الضريبة',
        field: 'customerVAT',
        type: PlutoColumnType.select([Const.mainVATCategory,Const.withoutVAT]),
      ): customerVAT,


    };
  }
  Map<String, dynamic> toMap() {
    return {
      'customerAccountId': customerAccountId,
      'رقم بطاقة الزبون': customerCardNumber,
      'اسم الزبون': customerAccountName,
      'الحساب': getAccountNameFromId(mainAccount),
      'نوع الضريبة': customerVAT,

    };
  }

  // Override for toString: عرض معلومات الكائن بشكل نصي
  @override
  String toString() {
    return 'AccountCustomer(customerVAT: $customerVAT, customerCardNumber: $customerCardNumber, customerAccountName: $customerAccountName, mainAccount: $mainAccount, account: $customerAccountId)';
  }

  // Override for hashCode: لتمثيل الكائن برمز خاص لاستخدامه في مجموعات
  @override
  int get hashCode {
    return customerVAT.hashCode ^
    customerCardNumber.hashCode ^
    customerAccountName.hashCode ^
    mainAccount.hashCode ^
    customerAccountId.hashCode;
  }

  // Override for equality (==): للمقارنة بين الكائنات
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccountCustomer &&
        other.customerVAT == customerVAT &&
        other.customerCardNumber == customerCardNumber &&
        other.customerAccountName == customerAccountName &&
        other.mainAccount == mainAccount &&
        other.customerAccountId == customerAccountId;
  }
}

