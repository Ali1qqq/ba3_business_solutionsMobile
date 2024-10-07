import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../Dialogs/SearchAccuntTextDialog.dart';


class GetAccountEnterPlutoGridAction extends PlutoGridShortcutAction {
  const GetAccountEnterPlutoGridAction(this.controller,this.fieldTitle);

  final dynamic controller;
  final String fieldTitle;

  @override
  void execute({
    required PlutoKeyManagerEvent keyEvent,
    required PlutoGridStateManager stateManager,
  }) async {

    await getAccount(stateManager,controller,fieldTitle);
    // In SelectRow mode, the current Row is passed to the onSelected callback.
    if (stateManager.mode.isSelectMode && stateManager.onSelected != null) {
      stateManager.onSelected!(PlutoGridOnSelectedEvent(
        row: stateManager.currentRow,
        rowIdx: stateManager.currentRowIdx,
        cell: stateManager.currentCell,
        selectedRows: stateManager.mode.isMultiSelectMode ? stateManager.currentSelectingRows : null,
      ));
      return;
    }

    if (stateManager.configuration.enterKeyAction.isNone) {
      return;
    }

    if (!stateManager.isEditing && _isExpandableCell(stateManager)) {
      stateManager.toggleExpandedRowGroup(rowGroup: stateManager.currentRow!);
      return;
    }

    if (stateManager.configuration.enterKeyAction.isToggleEditing) {
      stateManager.toggleEditing(notify: false);
    } else {
      if (stateManager.isEditing == true || stateManager.currentColumn?.enableEditingMode == false) {
        final saveIsEditing = stateManager.isEditing;

        _moveCell(keyEvent, stateManager);

        stateManager.setEditing(saveIsEditing, notify: false);
      } else {
        stateManager.toggleEditing(notify: false);
      }
    }

    if (stateManager.autoEditing) {
      stateManager.setEditing(true, notify: false);
    }

    stateManager.notifyListeners();
  }

  getAccount(PlutoGridStateManager stateManager, dynamic controller,String fieldName) async {
    if (stateManager.currentColumn?.field == fieldName) {
      String? newValue = await searchAccountTextDialog(stateManager.currentCell?.value);
      if (newValue != "") {
        stateManager.changeCellValue(
          stateManager.currentRow!.cells[fieldName]!,
          newValue,
          notify: true,
        );

      } else {
        stateManager.changeCellValue(
          stateManager.currentRow!.cells[fieldName]!,
          '',
          notify: true,
        );
      }
    }
    stateManager.notifyListeners();
    controller.update();
  }

  bool _isExpandableCell(PlutoGridStateManager stateManager) {
    return stateManager.currentCell != null && stateManager.enabledRowGroups && stateManager.rowGroupDelegate?.isExpandableCell(stateManager.currentCell!) == true;
  }

  void _moveCell(
      PlutoKeyManagerEvent keyEvent,
      PlutoGridStateManager stateManager,
      ) {
    final enterKeyAction = stateManager.configuration.enterKeyAction;

    if (enterKeyAction.isNone) {
      return;
    }

    if (enterKeyAction.isEditingAndMoveDown) {
      if (HardwareKeyboard.instance.isShiftPressed) {
        stateManager.moveCurrentCell(
          PlutoMoveDirection.up,
          force: true,
          notify: true,
        );
      } else {
        stateManager.moveCurrentCell(
          PlutoMoveDirection.right,
          force: true,
          notify: true,
        );
      }
    } else if (enterKeyAction.isEditingAndMoveRight) {
      if (HardwareKeyboard.instance.isShiftPressed) {
        stateManager.moveCurrentCell(
          PlutoMoveDirection.right,
          force: true,
          notify: false,
        );
      } else {
        stateManager.moveCurrentCell(
          PlutoMoveDirection.right,
          force: true,
          notify: false,
        );
      }
    }
  }
}