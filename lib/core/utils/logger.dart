import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_constants.dart';
import '../helper/enums/enums.dart';

enum TransfersType { create, read, update, delete }

void logger(
    {dynamic oldData,
    dynamic newData,
    bool showInTerminal = false,
    TransfersType? transfersType}) {
  if (AppConstants.env == EnvType.release) {
    TransfersType? type = transfersType;
    DateTime date = DateTime.now();
    if (type == TransfersType.read) {
      FirebaseFirestore.instance
          .collection(AppConstants.logsCollection)
          .doc(date.microsecondsSinceEpoch.toString())
          .set({"type": "read", 'affectedId': newData.affectedId()});
    } else {
      Map<String, dynamic>? data = differenceOfTwoMap(oldData, newData);
      if (data == null) {
      } else {
        print(data);
        data['date'] = date.toString();
        FirebaseFirestore.instance
            .collection(AppConstants.logsCollection)
            .doc(date.microsecondsSinceEpoch.toString())
            .set(data);
      }
    }
  } else {
    print("it's debug");
  }
}

Map<String, dynamic>? differenceOfTwoMap(dynamic oldData, dynamic newData) {
  if (oldData == null) {
    return {
      "type": "create",
      "changes": {
        "newData": [newData.toFullJson()]
      },
      'affectedId': newData.affectedId()
    };
  }
  if (newData == null) {
    return {
      "type": "delete",
      "changes": {
        "oldData": [oldData.toFullJson()]
      },
      'affectedId': oldData.affectedId()
    };
  }
  return {
    "type": "edit",
    "changes": newData.difference(oldData),
    'affectedId': newData.affectedId()
  };
}
