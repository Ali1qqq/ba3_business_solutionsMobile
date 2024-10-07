import 'package:hive/hive.dart';

import '../model/global_model.dart';

class GlobalModelAdapter extends TypeAdapter<GlobalModel>{
  @override
  GlobalModel read(BinaryReader reader) {
    return GlobalModel.fromJson(reader.read());
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, GlobalModel obj) {
   writer.write(obj.toFullJson());
  }
}