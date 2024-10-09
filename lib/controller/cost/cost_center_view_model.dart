import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/model/cost/cost_center_model.dart';
import 'package:ba3_business_solutions/model/cost/cost_center_tree.dart';
import 'package:ba3_business_solutions/core/utils/generate_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';

class CostCenterViewModel extends GetxController {
  String? editItem;
  TextEditingController? editCon;

  CostCenterViewModel() {
    // getAllCostCenter();
  }

  var lastIndex;
  List<CostCenterTree> allCost = [];
  Map<String, CostCenterModle> costCenterModelList = {};

  TreeController<CostCenterTree>? treeController;

  void getAllCostCenter({String? goto}) {
    FirebaseFirestore.instance
        .collection(AppConstants.costCenterCollection)
        .snapshots()
        .listen((value) async {
      costCenterModelList.clear();
      for (var element in value.docs) {
        costCenterModelList[element.id] =
            CostCenterModle.fromJson(element.data(), element.id);
      }
      initModel();
      initPage();
      go(lastIndex);
      update();
    });
  }

  void initModel() {
    allCost.clear();
    List<CostCenterModle> rootList = costCenterModelList.values
        .toList()
        .where((element) => element.isParent ?? false)
        .toList();
    for (var element in rootList) {
      allCost.add(addToModel(element));
    }
  }

  CostCenterTree addToModel(CostCenterModle element) {
    var list =
        element.child?.map((e) => addToModel(costCenterModelList[e]!)).toList();
    CostCenterTree model =
        CostCenterTree.fromJson({"name": element.name}, element.id, list ?? []);
    return model;
  }

  initPage() {
    treeController = TreeController<CostCenterTree>(
      roots: allCost,
      childrenProvider: (CostCenterTree node) => node.list,
    );
    update();
  }

  var allPer = [];

  addChild({String? parent, name}) async {
    var id = generateId(RecordType.costCenter);
    FirebaseFirestore.instance
        .collection(AppConstants.costCenterCollection)
        .doc(id)
        .set({
      "name": name,
      if (parent != null) "parent": parent,
      "isParent": parent == null,
    });
    if (parent != null) {
      FirebaseFirestore.instance
          .collection(AppConstants.costCenterCollection)
          .doc(parent)
          .update({
        'child': FieldValue.arrayUnion([id]),
      });
    }
  }

  removeChild({String? parent, id}) async {
    FirebaseFirestore.instance
        .collection(AppConstants.costCenterCollection)
        .doc(id)
        .delete();
    if (parent != null) {
      FirebaseFirestore.instance
          .collection(AppConstants.costCenterCollection)
          .doc(parent)
          .update({
        'child': FieldValue.arrayRemove([id]),
      });
    }
  }

  void setupParentList(parent) {
    allPer.add(costCenterModelList[parent]!.id);
    if (costCenterModelList[parent]!.parent != null) {
      setupParentList(costCenterModelList[parent]!.parent);
    }
  }

  void go(String? parent) {
    if (parent != null) {
      allPer.clear();
      setupParentList(parent);
      var allper = allPer.reversed.toList();
      List<CostCenterTree> _ = treeController!.roots.toList();
      for (var i = 0; i < allper.length; i++) {
        if (_.isNotEmpty) {
          treeController
              ?.expand(_.firstWhere((element) => element.id == allper[i]));
          _ = _.firstWhereOrNull((element) => element.id == allper[i])?.list ??
              [];
        }
      }
    }
  }

  void startRenameChild(String? id) {
    editItem = id;
    editCon = TextEditingController(text: costCenterModelList[id]!.name!);
    update();
  }

  void endRenameChild() {
    FirebaseFirestore.instance
        .collection(AppConstants.costCenterCollection)
        .doc(editItem)
        .update({
      "name": editCon?.text,
    });
    editItem = null;
    update();
  }
}
