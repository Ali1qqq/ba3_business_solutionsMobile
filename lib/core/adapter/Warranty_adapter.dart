import 'package:ba3_business_solutions/model/warranty/Warranty_Model.dart';
import 'package:hive/hive.dart';

class WarrantyAdapter extends TypeAdapter<WarrantyModel> {
  @override
  WarrantyModel read(BinaryReader reader) {
    return WarrantyModel.fromJson(reader.read());
  }

  @override
  int get typeId => 9;

  @override
  void write(BinaryWriter writer, WarrantyModel obj) {
    writer.write(obj.toJson());
  }
}
