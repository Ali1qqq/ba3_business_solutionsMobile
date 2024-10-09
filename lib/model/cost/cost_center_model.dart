class CostCenterModle {
  String? id, name, parent;
  bool? isParent;
  List<dynamic>? child = [];

  CostCenterModle({
    this.id,
    this.name,
    this.parent,
    this.isParent,
    this.child,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parent': parent,
      'isParent': isParent,
      'child': child,
    };
  }

  CostCenterModle.fromJson(Map<String, dynamic> json, this.id) {
    name = json['name'];
    parent = json['parent'];
    isParent = json['isParent'];
    child = json['child'];
  }
}
