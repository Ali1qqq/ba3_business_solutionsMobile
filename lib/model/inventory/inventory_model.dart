class InventoryModel {
  String? inventoryName,inventoryDate,inventoryId ,inventoryUserId;
  Map inventoryRecord = {};
  Map<String,dynamic> inventoryTargetedProductList = {};
  bool? isDone;
  InventoryModel({required this.inventoryId,required this.inventoryName,required this.inventoryDate ,required this.inventoryRecord,required this.inventoryTargetedProductList,required this.inventoryUserId,this.isDone});

  InventoryModel.fromJson(json){
    inventoryName = json['inventoryName'];
    isDone = json['isDone']??true;
    inventoryDate = json['inventoryDate'];
    inventoryUserId = json['inventoryUserId'];
    inventoryRecord =   json['inventoryRecord'];
    inventoryId =   json['inventoryId'];
    inventoryTargetedProductList =   json['inventoryTargetedProductList'];
    // inventoryRecord =   Map.fromEntries( json['inventoryRecord'].entries.map((e) => MapEntry(e.key.toString(), e.value.toString())).toList());

  }
  toJson() {
    return {
      'inventoryName': inventoryName,
      'inventoryId': inventoryId,
    'inventoryUserId': inventoryUserId,
    'isDone': isDone,
    'inventoryDate': inventoryDate,
      'inventoryRecord': inventoryRecord,
      'inventoryTargetedProductList': inventoryTargetedProductList,
  };
  }
}