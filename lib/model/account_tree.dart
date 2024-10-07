class AccountTree {
  String? name, id;
  List<AccountTree> list = [];
  AccountTree.fromJson(json, this.id, this.list) {
    name = json['name'];
  }
  toJson() {
    return {"name": name, 'id': id, "list": list.map((e) => e.toJson())};
  }
}
