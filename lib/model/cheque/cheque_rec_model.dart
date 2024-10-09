class ChequeRecModel {
  String? cheqRecEntryBondId, cheqRecType, cheqRecAmount, cheqRecId, cheqRecSecoundryAccount, cheqRecPrimeryAccount, cheqRecChequeType;

  ChequeRecModel({this.cheqRecAmount, this.cheqRecEntryBondId, this.cheqRecChequeType, this.cheqRecId, this.cheqRecPrimeryAccount, this.cheqRecSecoundryAccount, this.cheqRecType});

  ChequeRecModel.fromJson(Map<dynamic, dynamic> map) {
    cheqRecType = map['cheqRecType'];
    cheqRecEntryBondId = map['cheqRecEntryBondId'];
    cheqRecAmount = map['cheqRecAmount'];
    cheqRecId = map['cheqRecId'];
    cheqRecSecoundryAccount = map['cheqRecSecoundryAccount'];
    cheqRecPrimeryAccount = map['cheqRecPrimeryAccount'];
    cheqRecChequeType = map['cheqRecChequeType'];
  }
  toJson() {
    return {
      'cheqRecType': cheqRecType,
      'cheqRecAmount': cheqRecAmount,
      'cheqRecEntryBondId': cheqRecEntryBondId,
      'cheqRecId': cheqRecId,
      'cheqRecSecoundryAccount': cheqRecSecoundryAccount,
      'cheqRecPrimeryAccount': cheqRecPrimeryAccount,
      'cheqRecChequeType': cheqRecChequeType,
    };
  }
}
