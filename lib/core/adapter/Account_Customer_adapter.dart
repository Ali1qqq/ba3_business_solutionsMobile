import 'package:ba3_business_solutions/model/account/account_customer.dart';
import 'package:hive/hive.dart';




class AccountCustomerAdapter extends TypeAdapter<AccountCustomer>{
  @override
  AccountCustomer read(BinaryReader reader) {
    return AccountCustomer.fromJson(reader.read());
  }

  @override
  int get typeId => 8;

  @override
  void write(BinaryWriter writer, AccountCustomer obj) {
    writer.write(obj.toJson());
  }
}