
import 'package:hive/hive.dart';

import '../model/inventory_model.dart';


class InventoryModelAdapter extends TypeAdapter<InventoryModel>{
  @override
  InventoryModel read(BinaryReader reader) {
    return InventoryModel.fromJson(reader.read());
  }

  @override
  int get typeId => 7;

  @override
  void write(BinaryWriter writer, InventoryModel obj) {
   writer.write(obj.toJson());
  }
}