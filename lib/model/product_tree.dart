class ProductTree {
  String? name, id;
  List<ProductTree> list = [];
  ProductTree.fromJson(json, this.id, this.list) {
    name = json['name'];
  }
  toJson() {
    return {"name": name, 'id': id, "list": list.map((e) => e.toJson())};
  }
}
