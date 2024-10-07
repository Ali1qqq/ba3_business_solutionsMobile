import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';

import 'Warranty_record_model.dart';

class WarrantyModel {
  String? invId;
  String? sellerId;
  String? invDate;
  String? invCode;
  String? customerName, customerPhone,invNots;
  bool? done;
  List<WarrantyRecordModel>? invRecords = [];

  WarrantyModel({this.invId, this.sellerId, this.invDate, this.invRecords, this.done, this.customerName, this.customerPhone,this.invNots,this.invCode});

  // fromJson: تحويل JSON إلى WarrantyModel
  factory WarrantyModel.fromJson(Map<dynamic, dynamic> json) {
    return WarrantyModel(
      invId: json['invId']!,
      invCode: json['invCode'] ?? "",
      customerPhone: json['customerPhone'] ?? "",
      customerName: json['customerName'] ?? "",
      invNots: json['invNots'] ?? "",
      done: json['done'] ?? false,
      sellerId: json['sellerId'] ?? "",
      invDate: json['invDate'] ?? "",
      invRecords: (json['invRecords'] as List<dynamic>?)
          ?.map((item) => WarrantyRecordModel.fromJson(item))
          .toList() ?? <WarrantyRecordModel>[],
    );
  }

  // toJson: تحويل WarrantyModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'invId': invId,
      'sellerId': sellerId,
      'invCode': invCode,
      'invNots': invNots,
      'done': done,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'invDate': invDate,
      'invRecords': invRecords?.map((record) => record.toJson()).toList(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'invId': invId,
      'اسم البائع': getSellerNameFromId(sellerId),
      'رقم الفاتورة': invCode,
      'البيان': invNots,
      'التسليم': done==true?'تم التسليم':'لم يتم التسليم',
      'اسم الزبون': customerName,
      'رقم الزبون': customerPhone,
      'تاريخ الفاتورة': invDate,
      'المواد': invRecords?.map((record) => getProductNameFromId(record.invRecProduct)).toList().join(", "),
    };
  }
}
