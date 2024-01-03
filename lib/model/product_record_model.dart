import 'bond_record_model.dart';

class ProductRecordModel {
  String? invId, prodRecId, prodRecProduct, prodRecQuantity, prodRecSubTotal, prodRecTotal, prodType, prodRecSubVat;

  ProductRecordModel(this.invId, this.prodType, this.prodRecProduct, this.prodRecQuantity, this.prodRecId, this.prodRecTotal, this.prodRecSubTotal);

  ProductRecordModel.fromJson(Map<dynamic, dynamic> map, _invId) {
    invId = _invId;
    prodRecId = map['prodRecId'];
    prodRecProduct = map['prodRecProduct'];
    prodRecQuantity = map['prodRecQuantity'].toString();
    prodRecSubTotal = map['prodRecSubTotal'].toString();
    prodRecSubVat = map['prodRecSubVat'].toString();
    prodRecTotal = map['prodRecTotal'].toString();
    prodType = map['prodType'];
  }
  @override
  int get hashCode => prodRecId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BondRecordModel && runtimeType == other.runtimeType && invId == other.bondRecId;

  // Map<String, Map<String, dynamic>> getChanges(BondRecordModel other) {
  //   Map<String, dynamic> newChanges = {};
  //   Map<String, dynamic> oldChanges = {};
  //
  //   if (bondRecAccount != other.bondRecAccount) {
  //     newChanges['bondRecAccount'] =  other.bondRecAccount;
  //     oldChanges['bondRecAccount'] =  bondRecAccount;
  //   }
  //   if (bondRecCreditAmount != other.bondRecCreditAmount) {
  //     newChanges['bondRecCreditAmount'] =  other.bondRecCreditAmount;
  //     oldChanges['bondRecCreditAmount'] =  bondRecCreditAmount;
  //   }
  //   if (bondRecDebitAmount != other.bondRecDebitAmount) {
  //     newChanges['bondRecDebitAmount'] =  other.bondRecDebitAmount;
  //     oldChanges['bondRecDebitAmount'] =  bondRecDebitAmount;
  //   }
  //   if (bondRecDescription != other.bondRecDescription) {
  //     newChanges['bondRecDescription'] = other.bondRecDescription;
  //     oldChanges['bondRecDescription'] = bondRecDescription;
  //
  //   }
  //   if(newChanges.isNotEmpty) newChanges['bondRecId'] = other.bondRecId;
  //   if(oldChanges.isNotEmpty) oldChanges['bondRecId'] = bondRecId;
  //   return {
  //     "newData": newChanges,
  //     "oldData": oldChanges
  //   };
  // }

  String? affectedId() {
    return prodRecId;
  }

  toJson() {
    return {
      'invId': invId,
      'prodRecId': prodRecId,
      'prodRecProduct': prodRecProduct,
      'prodRecQuantity': prodRecQuantity,
      'prodRecSubTotal': prodRecSubTotal,
      'prodRecTotal': prodRecTotal,
      'prodType': prodType,
      'prodRecSubVat': prodRecSubVat,
    };
  }

  toFullJson() {
    return {
      'invId': invId,
      'prodRecId': prodRecId,
      'prodRecProduct': prodRecProduct,
      'prodRecQuantity': prodRecQuantity,
      'prodRecSubTotal': prodRecSubTotal,
      'prodRecTotal': prodRecTotal,
      'prodType': prodType,
      'prodRecSubVat': prodRecSubVat,
    };
  }
}
