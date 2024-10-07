import '../controller/account_view_model.dart';

class EntryBondRecordModel {
  String? bondRecId, bondRecAccount, bondRecDescription, invId;
  double? bondRecCreditAmount, bondRecDebitAmount;

  EntryBondRecordModel(this.bondRecId, this.bondRecCreditAmount, this.bondRecDebitAmount, this.bondRecAccount, this.bondRecDescription, {this.invId});
  EntryBondRecordModel.fromJson(json) {
    bondRecId = json['bondRecId'];
    bondRecAccount = json['bondRecAccount'];
    bondRecDescription = json['bondRecDescription'];
    bondRecCreditAmount =double.tryParse(json['bondRecCreditAmount'].toString())?? 0.0;
    bondRecDebitAmount = double.tryParse(json['bondRecDebitAmount'].toString())?? 0.0;
    invId = json['invId'];
  }
  EntryBondRecordModel.fromPlutoJson(json) {
    bondRecId = json['bondRecId'];
    bondRecAccount = getAccountIdFromText(json['bondRecAccount']);
    bondRecDescription = json['bondRecDescription'];
    bondRecCreditAmount =double.tryParse(json['bondRecCreditAmount'].toString())?? 0.0;
    bondRecDebitAmount = double.tryParse(json['bondRecDebitAmount'].toString())?? 0.0;
    invId = json['invId'];
  }

  Map<String, dynamic> toJson() {
    return {"bondRecId": bondRecId, "bondRecAccount": bondRecAccount, "bondRecDescription": bondRecDescription, "bondRecCreditAmount": bondRecCreditAmount, "bondRecDebitAmount": bondRecDebitAmount, if (invId != null) 'invId': invId};
  }

  // Override hashCode and operator == for proper set comparison
  @override
  int get hashCode => bondRecId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EntryBondRecordModel && runtimeType == other.runtimeType && bondRecId == other.bondRecId;

  Map<String, Map<String, dynamic>> getChanges(EntryBondRecordModel other) {
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
