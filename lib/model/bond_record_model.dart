class BondRecordModel {
  String? bondRecId, bondRecAccount, bondRecDescription, invId;
  double? bondRecCreditAmount, bondRecDebitAmount;

  BondRecordModel(this.bondRecId, this.bondRecCreditAmount, this.bondRecDebitAmount, this.bondRecAccount, this.bondRecDescription, {this.invId});
  BondRecordModel.fromJson(json) {
    bondRecId = json['bondRecId'];
    bondRecAccount = json['bondRecAccount'];
    bondRecDescription = json['bondRecDescription'];
    bondRecCreditAmount = double.parse(json['bondRecCreditAmount'].toString());
    bondRecDebitAmount = double.parse(json['bondRecDebitAmount'].toString());
    invId = json['invId'];
  }

  Map<String, dynamic> toJson() {
    return {"bondRecId": bondRecId, "bondRecAccount": bondRecAccount, "bondRecDescription": bondRecDescription, "bondRecCreditAmount": bondRecCreditAmount, "bondRecDebitAmount": bondRecDebitAmount, if (invId != null) 'invId': invId};
  }

  // Override hashCode and operator == for proper set comparison
  @override
  int get hashCode => bondRecId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BondRecordModel && runtimeType == other.runtimeType && bondRecId == other.bondRecId;

  Map<String, Map<String, dynamic>> getChanges(BondRecordModel other) {
    Map<String, dynamic> newChanges = {};
    Map<String, dynamic> oldChanges = {};

    if (bondRecAccount != other.bondRecAccount) {
      newChanges['bondRecAccount'] = other.bondRecAccount;
      oldChanges['bondRecAccount'] = bondRecAccount;
    }
    if (bondRecCreditAmount != other.bondRecCreditAmount) {
      newChanges['bondRecCreditAmount'] = other.bondRecCreditAmount;
      oldChanges['bondRecCreditAmount'] = bondRecCreditAmount;
    }
    if (bondRecDebitAmount != other.bondRecDebitAmount) {
      newChanges['bondRecDebitAmount'] = other.bondRecDebitAmount;
      oldChanges['bondRecDebitAmount'] = bondRecDebitAmount;
    }
    if (bondRecDescription != other.bondRecDescription) {
      newChanges['bondRecDescription'] = other.bondRecDescription;
      oldChanges['bondRecDescription'] = bondRecDescription;
    }
    if (newChanges.isNotEmpty) newChanges['bondRecId'] = other.bondRecId;
    if (oldChanges.isNotEmpty) oldChanges['bondRecId'] = bondRecId;
    return {"newData": newChanges, "oldData": oldChanges};
  }
}
