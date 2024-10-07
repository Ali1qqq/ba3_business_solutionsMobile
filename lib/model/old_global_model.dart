// import 'bond_record_model.dart';
// import 'invoice_record_model.dart';
//
// class GlobalModel {
//   String?
//   bondId,
//       bondDescription,
//       bondTotal,
//       bondDate,
//       bondCode,
//       bondType,
//       invId,
//       invName,
//       invSubTotal,
//       invPrimaryAccount,
//       invMobileNumber,
//       invSecondaryAccount,
//       invStorehouse,
//       invComment,
//       invType,
//       invRecId,
//       invRecProduct,
//       invRecAmount,
//       invRecSubTotal,
//       invRecTotal,
//       invoiceAccount,
//       invRecQuantity,
//       originId,
//       patternId,
//       invCode,
//       invSeller,
//       invDate;
//   double? invTotal;
//
//   List<BondRecordModel>? bondRecord = [];
//   List<InvoiceRecordModel>? invRecords = [];
//
//   Map<String, dynamic> toJson() {
//     return {
//       if (invId != null) 'invId': invId,
//       if (bondId != null) 'bondId': bondId,
//       if (bondDescription != null) 'bondDescription': bondDescription,
//       if (bondTotal != null) 'bondTotal': bondTotal,
//       if (bondDate != null) 'bondDate': bondDate,
//       if (bondCode != null) 'bondCode': bondCode,
//       if (bondType != null) 'bondType': bondType,
//       //  if(bondRecord!=null)"bondRecord": bondRecord?.map((record) => record.toJson()).toList(),
//       if (invName != null) 'invName': invName,
//       if (invTotal != null) 'invTotal': invTotal,
//       if (invSubTotal != null) 'invSubTotal': invSubTotal,
//       if (invPrimaryAccount != null) 'invPrimaryAccount': invPrimaryAccount,
//       if (invSecondaryAccount != null) 'invSecondaryAccount': invSecondaryAccount,
//       if (invStorehouse != null) 'invStorehouse': invStorehouse,
//       if (invComment != null) 'invComment': invComment,
//       if (invType != null) 'invType': invType,
//       if (originId != null) 'originId': originId,
//       if (invRecords != null) "invRecords": invRecords?.map((record) => record.toJson()).toList(),
//       if (invCode != null) "invCode": invCode,
//       if (patternId != null) "patternId": patternId,
//       if (invSeller != null) "invSeller": invSeller,
//       if (invDate != null) "invDate": invDate,
//       if (invMobileNumber != null) "invMobileNumber": invMobileNumber,
//       // if(patternModel != null)"pattrenModel"
//     };
//   }
//
//   Map<String, dynamic> toFullJson() {
//     return {
//       if (invId != null) 'invId': invId,
//       if (bondId != null) 'bondId': bondId,
//       if (bondDescription != null) 'bondDescription': bondDescription,
//       if (bondTotal != null) 'bondTotal': bondTotal,
//       if (bondDate != null) 'bondDate': bondDate,
//       if (bondCode != null) 'bondCode': bondCode,
//       if (bondType != null) 'bondType': bondType,
//       if (bondRecord != null) "bondRecord": bondRecord?.map((record) => record.toJson()).toList(),
//       if (invName != null) 'invName': invName,
//       if (invTotal != null) 'invTotal': invTotal,
//       if (invSubTotal != null) 'invSubTotal': invSubTotal,
//       if (invPrimaryAccount != null) 'invPrimaryAccount': invPrimaryAccount,
//       if (invSecondaryAccount != null) 'invSecondaryAccount': invSecondaryAccount,
//       if (invStorehouse != null) 'invStorehouse': invStorehouse,
//       if (invComment != null) 'invComment': invComment,
//       if (invType != null) 'invType': invType,
//       if (originId != null) 'originId': originId,
//       if (invRecords != null) "invRecords": invRecords?.map((record) => record.toJson()).toList(),
//       if (invCode != null) "invCode": invCode,
//       if (patternId != null) "patternId": patternId,
//       if (invSeller != null) "invSeller": invSeller,
//       if (invDate != null) "invDate": invDate,
//       if (invMobileNumber != null) "invMobileNumber": invMobileNumber,
//     };
//   }
//
//   factory GlobalModel.fromJson(json) {
//     List<BondRecordModel>? bondRecordList = json['bondRecord']?.map<BondRecordModel>((Map<String, dynamic> e) => BondRecordModel.fromJson(e)).toList();
//     return GlobalModel(
//       bondId: json['bondId'],
//       bondDescription: json['bondDescription'],
//       bondTotal: json['bondTotal'],
//       bondDate: json['bondDate'],
//       bondCode: json['bondCode'],
//       bondType: json['bondType'],
//       bondRecord: bondRecordList,
//       invId: json['invId'],
//       invName: json['invName'],
//       invTotal: json['invTotal'] == null ? null : double.parse(json['invTotal'].toString()),
//       invSubTotal: json['invSubTotal'],
//       invPrimaryAccount: json['invPrimaryAccount'],
//       invSecondaryAccount: json['invSecondaryAccount'],
//       invStorehouse: json['invStorehouse'],
//       invComment: json['invComment'],
//       invType: json['invType'],
//       originId: json['originId'],
//       //    invRecords:invRecords,
//       invoiceAccount: json['invoiceAccount'],
//       invCode: json['invCode'],
//       patternId: json['patternId'],
//       invSeller: json['invSeller'],
//       invDate: json['invDate'],
//       invMobileNumber: json['invMobileNumber'],
//     );
//   }
//   Map difference(GlobalModel oldData) {
//     Map<String, Map<String, dynamic>> finalMap = {
//       "oldData": {"bondRecord": [], "invRecords": []},
//       "newData": {"bondRecord": [], "invRecords": []}
//     };
//     assert(oldData.bondId == bondId && oldData.bondId != null && bondId != null || oldData.invId == invId && oldData.invId != null && invId != null);
//     print("_ _ " * 20);
//     print(invRecords);
//     print(invRecords?.length);
//
//     if (bondRecord != null || oldData.bondRecord != null || (bondRecord?.isNotEmpty ?? false) || (oldData.bondRecord?.isNotEmpty ?? false)) {
//       for (BondRecordModel newItem in bondRecord!) {
//         if (oldData.bondRecord!.contains(newItem)) {
//           BondRecordModel oldItem = oldData.bondRecord![oldData.bondRecord!.indexOf(newItem)];
//           Map<String, Map<String, dynamic>> changes = oldItem.getChanges(newItem);
//           if (changes['newData']!.isNotEmpty) {
//             finalMap['newData']?['bondRecord']?.add(changes['newData']!);
//             finalMap['oldData']?['bondRecord']?.add(changes['oldData']!);
//           } else {
//             print("its empty");
//           }
//         }
//         if (!oldData.bondRecord!.contains(newItem)) {
//           finalMap['newData']?['bondRecord']?.add(newItem.toJson());
//         }
//       }
//     }
//     if (invRecords != null || oldData.invRecords != null || (invRecords?.isNotEmpty ?? false) || (oldData.invRecords?.isNotEmpty ?? false)) {
//       for (InvoiceRecordModel newItem in invRecords!) {
//         if (oldData.invRecords!.contains(newItem)) {
//           InvoiceRecordModel oldItem = oldData.invRecords![oldData.invRecords!.indexOf(newItem)];
//           Map<String, Map<String, dynamic>> changes = oldItem.getChanges(newItem);
//           if (changes['newData']!.isNotEmpty) {
//             finalMap['newData']?['invRecords']?.add(changes['newData']!);
//             finalMap['oldData']?['invRecords']?.add(changes['oldData']!);
//           } else {
//             print("its empty");
//           }
//         }
//         if (!oldData.invRecords!.contains(newItem)) {
//           finalMap['newData']?['invRecords']?.add(newItem.toJson());
//         }
//       }
//       for (InvoiceRecordModel newItem in oldData.invRecords!) {
//         if (!invRecords!.contains(newItem)) {
//           finalMap['oldData']?['invRecords']?.add(newItem.toJson());
//         }
//       }
//     }
//     if (bondCode != oldData.bondCode) {
//       finalMap['newData']?['bondCode'] = bondCode;
//       finalMap['oldData']?['bondCode'] = oldData.bondCode;
//     }
//     if (bondDescription != oldData.bondDescription) {
//       finalMap['newData']?['bondDescription'] = bondDescription;
//       finalMap['oldData']?['bondDescription'] = oldData.bondDescription;
//     }
//     if (bondDate != oldData.bondDate) {
//       finalMap['newData']?['bondDate'] = bondDate;
//       finalMap['oldData']?['bondDate'] = oldData.bondDate;
//     }
//     if (bondTotal != oldData.bondTotal) {
//       finalMap['newData']?['bondTotal'] = bondTotal;
//       finalMap['oldData']?['bondTotal'] = oldData.bondTotal;
//     }
//     if (invComment != oldData.invComment) {
//       finalMap['newData']?['invComment'] = invComment;
//       finalMap['oldData']?['invComment'] = oldData.invComment;
//     }
//     if (invTotal != oldData.invTotal) {
//       finalMap['newData']?['invTotal'] = invTotal;
//       finalMap['oldData']?['invTotal'] = oldData.invTotal;
//     }
//     if (invTotal != oldData.invTotal) {
//       finalMap['newData']?['invTotal'] = invTotal;
//       finalMap['oldData']?['invTotal'] = oldData.invTotal;
//     }
//     if (invSubTotal != oldData.invSubTotal) {
//       finalMap['newData']?['invSubTotal'] = invSubTotal;
//       finalMap['oldData']?['invSubTotal'] = oldData.invSubTotal;
//     }
//     if (invPrimaryAccount != oldData.invPrimaryAccount) {
//       finalMap['newData']?['invPrimaryAccount'] = invPrimaryAccount;
//       finalMap['oldData']?['invPrimaryAccount'] = oldData.invPrimaryAccount;
//     }
//     if (invSecondaryAccount != oldData.invSecondaryAccount) {
//       finalMap['newData']?['invSecondaryAccount'] = invSecondaryAccount;
//       finalMap['oldData']?['invSecondaryAccount'] = oldData.invSecondaryAccount;
//     }
//     if (invStorehouse != oldData.invStorehouse) {
//       finalMap['newData']?['invStorehouse'] = invStorehouse;
//       finalMap['oldData']?['invStorehouse'] = oldData.invStorehouse;
//     }
//     if (invType != oldData.invType) {
//       finalMap['newData']?['invType'] = invType;
//       finalMap['oldData']?['invType'] = oldData.invType;
//     }
//     if (invoiceAccount != oldData.invoiceAccount) {
//       finalMap['newData']?['invoiceAccount'] = invoiceAccount;
//       finalMap['oldData']?['invoiceAccount'] = oldData.invoiceAccount;
//     }
//     if (originId != oldData.originId) {
//       finalMap['newData']?['originId'] = originId;
//       finalMap['oldData']?['originId'] = oldData.originId;
//     }
//     if (invCode != oldData.invCode) {
//       finalMap['newData']?['invCode'] = invCode;
//       finalMap['oldData']?['invCode'] = oldData.invCode;
//     }
//     if (patternId != oldData.patternId) {
//       finalMap['newData']?['patternId'] = patternId;
//       finalMap['oldData']?['patternId'] = oldData.patternId;
//     }
//     if (invSeller != oldData.invSeller) {
//       finalMap['newData']?['invSeller'] = invSeller;
//       finalMap['oldData']?['invSeller'] = oldData.invSeller;
//     }
//     if (invDate != oldData.invDate) {
//       finalMap['newData']?['invDate'] = invDate;
//       finalMap['oldData']?['invDate'] = oldData.invDate;
//     }
//     if (invMobileNumber != oldData.invMobileNumber) {
//       finalMap['newData']?['invMobileNumber'] = invMobileNumber;
//       finalMap['oldData']?['invMobileNumber'] = oldData.invMobileNumber;
//     }
//     if (finalMap['newData']?['bondRecord'].length == 0 && finalMap['oldData']?['bondRecord'].length == 0) {
//       finalMap['newData']?.remove('bondRecord');
//       finalMap['oldData']?.remove('bondRecord');
//     }
//     if (finalMap['newData']?['invRecords'].length == 0 && finalMap['oldData']?['invRecords'].length == 0) {
//       finalMap['newData']?.remove('invRecords');
//       finalMap['oldData']?.remove('invRecords');
//     }
//     return finalMap;
//   }
//
//   String? affectedId() {
//     return invId ?? bondId;
//   }
//
//   GlobalModel({
//     this.bondId,
//     this.bondDescription,
//     this.bondTotal,
//     this.bondDate,
//     this.bondCode,
//     this.bondRecord,
//     this.bondType,
//     this.invId,
//     this.invName,
//     this.invTotal,
//     this.invSubTotal,
//     this.invPrimaryAccount,
//     this.invSecondaryAccount,
//     this.invStorehouse,
//     this.invComment,
//     this.invType,
//     this.invRecords,
//     this.invoiceAccount,
//     this.originId,
//     this.invCode,
//     this.patternId,
//     this.invSeller,
//     this.invDate,
//     this.invMobileNumber,
//   });
// }
//
// GlobalModel getBondData() {
//   return GlobalModel(bondId: null, bondTotal: "0", bondRecord: [
//     BondRecordModel('00', 0, 0, "", ""),
//   ]);
// }
