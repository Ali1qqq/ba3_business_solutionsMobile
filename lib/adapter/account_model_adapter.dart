import 'package:hive/hive.dart';

import '../model/account_model.dart';


class AccountModelAdapter extends TypeAdapter<AccountModel>{
  @override
  AccountModel read(BinaryReader reader) {
    return AccountModel.fromJson(reader.read());
  }

  @override
  int get typeId => 2;

  @override
  void write(BinaryWriter writer, AccountModel obj) {
   writer.write(obj.toFullJson());
  }
}