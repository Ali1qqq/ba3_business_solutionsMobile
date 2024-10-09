import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/model/account/account_customer.dart';
import 'package:ba3_business_solutions/model/account/account_record_model.dart';

import '../../controller/account/account_view_model.dart';
import '../../core/helper/functions/functions.dart';

class AccountModel {
  String? accId, accName, accComment, accType, accCode, accVat, accParentId;
  bool? accIsParent;
  List accChild = [];
  List accAggregateList = [];
  List<AccountRecordModel> accRecord = [];
  List<AccountCustomer>? accCustomer = [];
  double? finalBalance, fFinalBalance;

  AccountModel({
    this.accId,
    this.accName,
    this.accComment,
    this.accVat,
    this.accType,
    this.accCode,
    this.accParentId,
    this.accIsParent,
    this.finalBalance,
    this.fFinalBalance,
    this.accCustomer,
  });

  AccountModel.fromJson(Map<dynamic, dynamic> map) {
    accId = map['accId'];
    accName = map['accName'];
    accComment = map['accComment'];
    accType = map['accType'];
    accCode = map['accCode'];
    accVat = map['accVat'];

    ///this is new
    finalBalance = map['finalBalance'];
    fFinalBalance = map['fFinalBalance'];
    fFinalBalance = map['fFinalBalance'];
    accParentId = map['accParentId'];
    accIsParent = map['accIsParent'];
    if (map['accCustomer'] != null && map['accCustomer'] != []) {
      map['accCustomer'].forEach((element) {
            if (element.runtimeType == AccountCustomer) {
              accCustomer!.add(element);
            } else {
              accCustomer!.add(AccountCustomer.fromJson(element));
            }
          }) ??
          [];
    } else {
      accCustomer = [];
    }
    if (map['accRecord'] != null && map['accRecord'] != []) {
      map['accRecord'].forEach((element) {
            if (element.runtimeType == AccountRecordModel) {
              accRecord.add(element);
            } else {
              accRecord.add(AccountRecordModel.fromJson(element));
            }
          }) ??
          [];
    } else {
      accRecord = [];
    }
    accChild = map['accChild'] ?? [];
    accAggregateList = map['accAggregateList'] ?? [];
  }

  Map difference(AccountModel oldData) {
    assert(oldData.accId == accId && oldData.accId != null && accId != null || oldData.accId == accId && oldData.accId != null && accId != null);
    Map<String, dynamic> newChanges = {};
    Map<String, dynamic> oldChanges = {};

    if (accName != oldData.accName) {
      newChanges['accName'] = oldData.accName;
      oldChanges['accName'] = accName;
    }
    if (accCode != oldData.accCode) {
      newChanges['accCode'] = oldData.accCode;
      oldChanges['accCode'] = accCode;
    }
    if (accComment != oldData.accComment) {
      newChanges['accComment'] = oldData.accComment;
      oldChanges['accComment'] = accComment;
    }
    if (accType != oldData.accType) {
      newChanges['accType'] = oldData.accType;
      oldChanges['accType'] = accType;
    }
    if (accVat != oldData.accVat) {
      newChanges['accVat'] = oldData.accVat;
      oldChanges['accVat'] = accVat;
    }
    if (accParentId != oldData.accParentId) {
      newChanges['accParentId'] = oldData.accParentId;
      oldChanges['accParentId'] = accParentId;
    }
    if (accIsParent != oldData.accIsParent) {
      newChanges['accIsParent'] = oldData.accIsParent;
      oldChanges['accIsParent'] = accIsParent;
    }
    if (accChild != oldData.accChild) {
      newChanges['accChild'] = oldData.accChild;
      oldChanges['accChild'] = accChild;
    }
    if (accAggregateList != oldData.accAggregateList) {
      newChanges['accAggregateList'] = oldData.accAggregateList;
      oldChanges['accAggregateList'] = accAggregateList;
    }

    return {
      "newData": [newChanges],
      "oldData": [oldChanges]
    };
  }

  String? affectedId() {
    return accId;
  }

  String? affectedKey({String? type}) {
    return "accId";
  }

  toJson() {
    return {
      if (accId != null) 'accId': accId,
      if (accName != null) 'accName': accName,
      if (accComment != null) 'accComment': accComment,
      if (accType != null) 'accType': accType,
      if (accCode != null) 'accCode': accCode,
      if (accVat != null) 'accVat': accVat,
      if (accCustomer != null)
        'accCustomer': accCustomer
            ?.map(
              (e) => e.toJson(),
            )
            .toList(),
      if (accParentId != null) 'accParentId': accParentId,
      if (accIsParent != null) 'accIsParent': accIsParent,
      if (accChild.isNotEmpty) 'accChild': accChild,
      if (accAggregateList.isNotEmpty) 'accAggregateList': accAggregateList,
      if (finalBalance != null) 'finalBalance': finalBalance,
      if (fFinalBalance != null) 'fFinalBalance': fFinalBalance,
    };
  }

  toFullJson() {
    return {
      'accId': accId,
      'accName': accName,
      'accComment': accComment,
      'accType': accType,
      'accCode': accCode,
      'accVat': accVat,
      if (accCustomer != null)
        'accCustomer': accCustomer
            ?.map(
              (e) => e.toJson(),
            )
            .toList(),
      'fFinalBalance': fFinalBalance,
      'accParentId': accParentId,
      'accIsParent': accIsParent,
      'accChild': accChild,
      'finalBalance': finalBalance,
      'accAggregateList': accAggregateList,
      'accRecord': accRecord.map((e) => e.toJson()).toList(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'accId': accId,
      'رمز الحساب': accCode,
      'اسم الحساب': accName,
      'نوع الحساب': getAccountTypeFromEnum(accType ?? ""),
      'نوع الضريبة': accVat,
      'حساب الاب': getAccountNameFromId(accParentId),
      'الزبائن': accCustomer!.map((e) =>e.customerAccountName!,).toList().join(' , '),
      'الاولاد': accChild.map((e) =>getAccountNameFromId(e),).toList().join(' , '),
      // 'الوصف': accComment,
      // 'الرصيد': getAccountBalanceFromId(accId),
      'الرصيد': finalBalance,
    };
  }
}
