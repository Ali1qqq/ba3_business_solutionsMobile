import 'package:ba3_business_solutions/Widgets/CustomerPlutoEditView.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/view/accounts/widget/add_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';

import '../../model/account_tree.dart';
import '../widget/CustomWindowTitleBar.dart';

class AccountTreeView extends StatelessWidget {
  AccountTreeView({super.key});

  final AccountViewModel accountController = Get.find<AccountViewModel>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("شجرة الحسابات"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  accountController.treeController?.collapseAll();
                },
                child: const Text("-")),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  accountController.treeController?.expandAll();
                },
                child: const Text("+")),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => const AddAccount(),binding: BindingsBuilder(

                        () => Get.lazyPut(()=>CustomerPlutoEditViewModel()),
                  ));

                },
                child: const Text("اضافة حساب")),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: StreamBuilder(
            stream: accountController.accountList.stream,
            builder: (context, snapshot) {
              return GetBuilder<AccountViewModel>(builder: (controller) {
                return accountController.allCost.isEmpty
                    ? const CircularProgressIndicator()
                    : TreeView<AccountTree>(
                        treeController: accountController.treeController!,
                        nodeBuilder: (BuildContext context, TreeEntry<AccountTree> entry) {
                          return myTreeTile(
                            context: context,
                            key: ValueKey(entry.node),
                            entry: entry,
                            onTap: () {
                              controller.lastIndex = entry.node.id;
                              accountController.treeController?.toggleExpansion(entry.node);
                            },
                          );
                        },
                      );
              });
            }),
      ),
    );
  }

  myTreeTile({context, required ValueKey<AccountTree> key, required VoidCallback onTap, required TreeEntry<AccountTree> entry}) {
    return TreeIndentation(
      key: key,
      entry: entry,
      guide: const IndentGuide.connectingLines(indent: 48),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
        child: SizedBox(
          width: 10,
          height: 50,
          child: GestureDetector(
            onSecondaryTapDown: (details) {
              showContextMenu(context, details.globalPosition, accountController, entry);
            },
            onLongPressStart: (details) {
              showContextMenu(context, details.globalPosition, accountController, entry);
            },
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FolderButton(
                  isOpen: entry.hasChildren ? entry.isExpanded : null,
                  onPressed: entry.hasChildren ? onTap : null,
                ),
                if (accountController.editItem != entry.node.id)
                  Row(
                    children: [
                      Text(entry.node.name!),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(getAccountModelFromId(entry.node.id)!.accCode.toString()),
                    ],
                  )
                else
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: accountController.editCon,
                      onFieldSubmitted: (_) {
                        accountController.endRenameChild();
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

  void showContextMenu(BuildContext parentContext, Offset tapPosition, AccountViewModel controller, entry) {
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
          value: 'seeDetails',
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('عرض تفاصيل'),
          ),
        ),
        const PopupMenuItem(
          value: 'add',
          child: ListTile(
            leading: Icon(Icons.copy),
            title: Text('إضافة ابن'),
          ),
        ),
        const PopupMenuItem(
          value: 'rename',
          child: ListTile(
            leading: Icon(Icons.copy),
            title: Text('اعادة تسمية'),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'seeDetails') {
        ///ToDO
        // Get.to(() => AccountDetails(modelKey: entry.node.id!));
      } else if (value == 'rename') {
        controller.startRenameChild(entry.node.id);
      } else if (value == "add") {
        Get.to(AddAccount(oldParent: entry.node.id),binding: BindingsBuilder(

              () => Get.lazyPut(()=>CustomerPlutoEditViewModel()),
        ));
      }
    });
  }
}
