import 'store_record_model.dart';

class StoreModel {
  String? stId, stName, stCode;

  // Map<String, StoreRecordModel>stRecords ={};
  List<StoreRecordModel> stRecords = [];

  StoreModel({this.stId, this.stCode, this.stName});

  StoreModel.fromJson(Map<dynamic, dynamic> map) {
    List<StoreRecordModel>? stRecord = map['stRecords']?.map<StoreRecordModel>((dynamic e) => StoreRecordModel.fromJson(e)).toList();
    stId = map['stId'];
    stCode = map['stCode'];
    stName = map['stName'];
    stRecords = stRecord ?? [];
  }

  Map<String, dynamic> toJson() {
    return {'stId': stId, 'stCode': stCode, 'stName': stName};
  }

  Map<String, dynamic> toFullJson() {
    return {'stId': stId, 'stCode': stCode, 'stName': stName, "stRecords": stRecords.map((value) => value.toJson()).toList()};
  }

  Map<String, dynamic> toMap() {
    return {
      'stId': stId,
      'الرمز': stCode,
      'الاسم': stName,
    };
  }
}
