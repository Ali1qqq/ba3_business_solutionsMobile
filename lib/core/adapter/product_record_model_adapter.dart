
import 'package:ba3_business_solutions/model/product/product_record_model.dart';

import 'package:hive/hive.dart';


class ProductRecordModelAdapter extends TypeAdapter<ProductRecordModel>{
  @override
  ProductRecordModel read(BinaryReader reader) {
    return ProductRecordModel.fromJson(reader.read());
  }

  @override
  int get typeId => 6;

  @override
  void write(BinaryWriter writer, ProductRecordModel obj) {
   writer.write(obj.toFullJson());
  }
}