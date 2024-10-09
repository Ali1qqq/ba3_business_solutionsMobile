// import 'package:ba3_business_solutions/model/cheque_rec_model.dart';
//
// class ChequeModel {
//   String?
      // cheqId,
      // cheqName,
      // cheqAllAmount,
      // cheqRemainingAmount,
      // cheqPrimeryAccount,
      // cheqSecoundryAccount,
      // cheqCode,
      // cheqDate,
      // cheqStatus,
      // cheqType,
      // cheqBankAccount;
//   List<ChequeRecModel>? cheqRecords = [];
//
//   ChequeModel({this.cheqId, this.cheqName, this.cheqRecords, this.cheqCode, this.cheqAllAmount, this.cheqDate, this.cheqPrimeryAccount, this.cheqRemainingAmount, this.cheqSecoundryAccount, this.cheqStatus, this.cheqBankAccount, this.cheqType});
//
//   ChequeModel.fromJson(Map<dynamic, dynamic> map, id, List<ChequeRecModel> records) {
//     cheqId = id;
//     cheqName = map['cheqName'];
//     cheqAllAmount = map['cheqAllAmount'];
//     cheqRemainingAmount = map['cheqRemainingAmount'];
//     cheqPrimeryAccount = map['cheqPrimeryAccount'];
//     cheqSecoundryAccount = map['cheqSecoundryAccount'];
//     cheqCode = map['cheqCode'];
//     cheqDate = map['cheqDate'];
//     cheqStatus = map['cheqStatus'];
//     cheqType = map['cheqType'];
//     cheqBankAccount = map['cheqBankAccount'];
//     cheqRecords = records;
//   }
//   Map difference(ChequeModel oldData) {
//     assert(oldData.cheqId == cheqId && oldData.cheqId != null && cheqId != null);
//     Map<String, dynamic> newChanges = {};
//     Map<String, dynamic> oldChanges = {};
//
//     if (cheqName != oldData.cheqName) {
//       newChanges['cheqName'] = oldData.cheqName;
//       oldChanges['cheqName'] = cheqName;
//     }
//     if (cheqAllAmount != oldData.cheqAllAmount) {
//       newChanges['cheqAllAmount'] = oldData.cheqAllAmount;
//       oldChanges['cheqAllAmount'] = cheqAllAmount;
//     }
//
//     if (cheqRemainingAmount != oldData.cheqRemainingAmount) {
//       newChanges['cheqRemainingAmount'] = oldData.cheqRemainingAmount;
//       oldChanges['cheqRemainingAmount'] = cheqRemainingAmount;
//     }
//     if (cheqPrimeryAccount != oldData.cheqPrimeryAccount) {
//       newChanges['cheqPrimeryAccount'] = oldData.cheqPrimeryAccount;
//       oldChanges['cheqPrimeryAccount'] = cheqPrimeryAccount;
//     }
//     if (cheqSecoundryAccount != oldData.cheqSecoundryAccount) {
//       newChanges['cheqSecoundryAccount'] = oldData.cheqSecoundryAccount;
//       oldChanges['cheqSecoundryAccount'] = cheqSecoundryAccount;
//     }
//     if (cheqCode != oldData.cheqCode) {
//       newChanges['cheqCode'] = oldData.cheqCode;
//       oldChanges['cheqCode'] = cheqCode;
//     }
//     if (cheqDate != oldData.cheqDate) {
//       newChanges['cheqDate'] = oldData.cheqDate;
//       oldChanges['cheqDate'] = cheqDate;
//     }
//     if (cheqStatus != oldData.cheqStatus) {
//       newChanges['cheqStatus'] = oldData.cheqStatus;
//       oldChanges['cheqStatus'] = cheqStatus;
//     }
//     if (cheqType != oldData.cheqType) {
//       newChanges['cheqType'] = oldData.cheqType;
//       oldChanges['cheqType'] = cheqType;
//     }
//     if (cheqBankAccount != oldData.cheqBankAccount) {
//       newChanges['cheqBankAccount'] = oldData.cheqBankAccount;
//       oldChanges['cheqBankAccount'] = cheqBankAccount;
//     }
//
//     return {
//       "newData": [newChanges],
//       "oldData": [oldChanges]
//     };
//   }
//
//   String? affectedId() {
//     return cheqId;
//   }
//
//   toJson() {
//     return {
//       'cheqId': cheqId,
//       'cheqName': cheqName,
//       'cheqAllAmount': cheqAllAmount,
//       'cheqRemainingAmount': cheqRemainingAmount,
//       'cheqPrimeryAccount': cheqPrimeryAccount,
//       'cheqSecoundryAccount': cheqSecoundryAccount,
//       'cheqCode': cheqCode,
//       'cheqDate': cheqDate,
//       'cheqStatus': cheqStatus,
//       'cheqType': cheqType,
//       'cheqBankAccount': cheqBankAccount,
//     };
//   }
//
//   toFullJson() {
//     return {'cheqId': cheqId, 'cheqName': cheqName, 'cheqAllAmount': cheqAllAmount, 'cheqRemainingAmount': cheqRemainingAmount, 'cheqPrimeryAccount': cheqPrimeryAccount, 'cheqSecoundryAccount': cheqSecoundryAccount, 'cheqCode': cheqCode, 'cheqDate': cheqDate, 'cheqStatus': cheqStatus, 'cheqType': cheqType, 'cheqRecords': cheqRecords, 'cheqBankAccount': cheqBankAccount};
//   }
//
//   ChequeModel.fromFullJson(Map<dynamic, dynamic> map) {
//     cheqId = map['cheqId'];
//     cheqName = map['cheqName'];
//     cheqAllAmount = map['cheqAllAmount'];
//     cheqRemainingAmount = map['cheqRemainingAmount'];
//     cheqPrimeryAccount = map['cheqPrimeryAccount'];
//     cheqSecoundryAccount = map['cheqSecoundryAccount'];
//     cheqCode = map['cheqCode'];
//     cheqDate = map['cheqDate'];
//     cheqStatus = map['cheqStatus'];
//     cheqRecords = map['cheqRecords'];
//     cheqType = map['cheqType'];
//     cheqBankAccount = map['cheqBankAccount'];
//   }
// }
