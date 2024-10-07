class CostCenterTree {
  String? name, id;
  List<CostCenterTree> list = [];
  CostCenterTree.fromJson(json, this.id, this.list) {
    name = json['name'];
  }
  toJson() {
    return {"name": name, 'id': id, "list": list.map((e) => e.toJson())};
  }
}
