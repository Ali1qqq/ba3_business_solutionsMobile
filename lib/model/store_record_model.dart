import 'package:ba3_business_solutions/model/product_model.dart';

import '../controller/product_view_model.dart';

class StoreRecordModel {
  String? storeRecId;
  String? storeRecInvId;
  Map<String, StoreRecProductModel>? storeRecProduct={};

  StoreRecordModel({this.storeRecId, this.storeRecInvId, this.storeRecProduct});

  factory StoreRecordModel.fromJson(Map<dynamic, dynamic> json) {
    Map<dynamic, dynamic> storeRecProductJson = json['storeRecProduct'];
    Map<String, StoreRecProductModel> storeRecProductMap={};

    storeRecProductMap = storeRecProductJson.map((key, value) {
      return MapEntry(key, StoreRecProductModel.fromJson(value));
    });

    return StoreRecordModel(
      storeRecId: json['storeRecId'],
      storeRecInvId: json['StoreRecInvId'],
      storeRecProduct: storeRecProductMap,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> storeRecProductJson = {};
    storeRecProduct?.forEach((key, value) {
      storeRecProductJson[key] = value.toJson();
    });

    return {
      'storeRecId': storeRecId,
      'StoreRecInvId': storeRecInvId,
      'storeRecProduct': storeRecProductJson,
    };
  }
}

class StoreRecProductModel {
  String? storeRecProductId;
  String? storeRecProductQuantity;
  String? storeRecProductPrice;
  String? storeRecProductTotal;

  StoreRecProductModel({
    this.storeRecProductId,
    this.storeRecProductQuantity,
    this.storeRecProductPrice,
    this.storeRecProductTotal,
  });

  factory StoreRecProductModel.fromJson(Map<dynamic, dynamic> json) {
    return StoreRecProductModel(
      storeRecProductId: json['storeRecProductId'],
      storeRecProductQuantity: json['storeRecProductQuantity'],
      storeRecProductPrice: json['storeRecProductPrice'],
      storeRecProductTotal: json['storeRecProductTotal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeRecProductId': storeRecProductId,
      'storeRecProductQuantity': storeRecProductQuantity,
      'storeRecProductPrice': storeRecProductPrice,
      'storeRecProductTotal': storeRecProductTotal,
    };
  }
}

class StoreRecordView{
  String?  productId , total  ;
  StoreRecordView({this.productId, this.total});

  String? affectedId() {
    return productId;
  }

  String? affectedKey({String? type}) {
    return "productId";
  }
  toMap(){
    print(productId);
    ProductModel productModel = getProductModelFromId(productId)??ProductModel(prodName: "XXXXXXXXXXX");///Isolate
    return {
      "id":productId,
       "رمز المادة":productModel.prodFullCode,
       "المادة":productModel.prodName,
       "الكمية":total=="hello"?15:double.parse(total??"0").toInt()
    };
    
  }

}