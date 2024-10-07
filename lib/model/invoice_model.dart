// class InvoiceModel {
//   String?
//   invId,
//       invName,
//       invTotal,
//       invSubTotal,
//       invPrimaryAccount,
//       invSecondaryAccount,
//       invStorehouse,
//       invComment,
//       invType;
//
//   List<String>? invRecords;
//
//   InvoiceModel({
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
//   });
//
//   InvoiceModel.fromJson(Map<dynamic, dynamic> map) {
//     if (map == null) {
//       return;
//     }
//     invId = map['invId'];
//     invName = map['invName'];
//     invTotal = map['invTotal'];
//     invSubTotal = map['invSubTotal'];
//     invPrimaryAccount = map['invPrimaryAccount'];
//     invSecondaryAccount = map['invSecondaryAccount'];
//     invStorehouse = map['invStorehouse'];
//     invComment = map['invComment'];
//     invType = map['invType'];
//     invRecords = map['invRecords'];
//   }
//
//   toJson() {
//     return {
//       'invId': invId,
//       'invName': invName,
//       'invTotal': invTotal,
//       'invSubTotal': invSubTotal,
//       'invPrimaryAccount': invPrimaryAccount,
//       'invSecondaryAccount': invSecondaryAccount,
//       'invStorehouse': invStorehouse,
//       'invComment': invComment,
//       'invType': invType,
//       'invRecords': invRecords,
//     };
//   }
// }
