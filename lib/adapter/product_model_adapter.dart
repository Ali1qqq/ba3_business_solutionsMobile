import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:hive/hive.dart';


class ProductModelAdapter extends TypeAdapter<ProductModel>{
  @override
  ProductModel read(BinaryReader reader) {
    return ProductModel.fromJson(reader.read());
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, ProductModel obj) {
   writer.write(obj.toFullJson());
  }
}