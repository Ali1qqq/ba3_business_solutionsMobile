import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/cost_center_view_model.dart';
import 'package:ba3_business_solutions/model/cost_center_tree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';

var costCenterController = Get.find<CostCenterViewModel>();

class CostCenterView extends StatelessWidget {
  const CostCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tree of Truth"),
        actions: [
          ElevatedButton(
              onPressed: () {
                costCenterController.treeController?.collapseAll();
              },
              child: Text("-")),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () {
                costCenterController.treeController?.expandAll();
              },
              child: Text("+")),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () {
                var con = TextEditingController();
                Get.defaultDialog(content: TextFormField(controller: con), actions: [
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                        costCenterController.addChild(name: con.text);
                      },
                      child: Text("yes"))
                ]);
              },
              child: Text("add root children")),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(Const.costCenterCollection).snapshots(),
          builder: (context, snapshot) {
            return GetBuilder<CostCenterViewModel>(builder: (controller) {
              return costCenterController.allCost.isEmpty
                  ? const CircularProgressIndicator()
                  : TreeView<CostCenterTree>(
                      treeController: costCenterController.treeController!,
                      nodeBuilder: (BuildContext context, TreeEntry<CostCenterTree> entry) {
                        return MyTreeTile(
                          key: ValueKey(entry.node),
                          entry: entry,
                          onTap: () {
                            controller.lastIndex = entry.node.id;
                            costCenterController.treeController?.toggleExpansion(entry.node);
                          },
                        );
                      },
                    );
            });
          }),
    );
  }
}

class MyTreeTile extends StatelessWidget {
  const MyTreeTile({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final TreeEntry<CostCenterTree> entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TreeIndentation(
      entry: entry,
      guide: const IndentGuide.connectingLines(indent: 48),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
        child: SizedBox(
          width: 10,
          height: 50,
          child: GestureDetector(
            onSecondaryTapDown: (details) {
              showContextMenu(context, details.globalPosition, costCenterController);
            },
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FolderButton(
                  isOpen: entry.hasChildren ? entry.isExpanded : null,
                  onPressed: entry.hasChildren ? onTap : null,
                ),
                if (costCenterController.editItem != entry.node.id)
                  Text(entry.node.name ?? "error")
                else
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: costCenterController.editCon,
                      onFieldSubmitted: (_) {
                        costCenterController.endRenameChild();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showContextMenu(BuildContext parentContext, Offset tapPosition, CostCenterViewModel controller) {
    showMenu(
      context: parentContext,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx + 1.0,
        tapPosition.dy + 1.0,
      ),
      items: [
        const PopupMenuItem(
          value: 'add',
          child: ListTile(
            leading: Icon(Icons.copy),
            title: Text('add Child'),
          ),
        ),
        const PopupMenuItem(
          value: 'rename',
          child: ListTile(
            leading: Icon(Icons.copy),
            title: Text('rename'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.copy),
            title: Text('delete Child'),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'rename') {
        controller.startRenameChild(entry.node.id);
      } else if (value == 'delete') {
        controller.removeChild(parent: entry.parent?.node.id, id: entry.node.id);
      } else if (value == "add") {
        var con = TextEditingController();
        Get.defaultDialog(content: TextFormField(controller: con), actions: [
          ElevatedButton(
              onPressed: () {
                Get.back();
                controller.addChild(parent: entry.node.id, name: con.text);
              },
              child: Text("yes"))
        ]);
      }
    });
  }
}
