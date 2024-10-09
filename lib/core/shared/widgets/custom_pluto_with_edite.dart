import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'custom_pluto_grid_style_config.dart';

class CustomPlutoWithEdite extends StatelessWidget {
  const CustomPlutoWithEdite({
    super.key,
    required this.controller,
    this.shortCut,
    this.onChanged,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.evenRowColor = Colors.blueAccent,
  });

  final dynamic controller;
  final PlutoGridShortcut? shortCut;
  final Function(PlutoGridOnChangedEvent)? onChanged;
  final Function(PlutoGridOnRowSecondaryTapEvent)? onRowSecondaryTap;
  final Function(PlutoGridOnRowDoubleTapEvent)? onRowDoubleTap;
  final Color evenRowColor;

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: controller.columns,
      rows: controller.rows,
      onRowDoubleTap: onRowDoubleTap,
      onRowSecondaryTap: onRowSecondaryTap,
      onChanged: onChanged,
      configuration: PlutoGridConfiguration(
        shortcut: shortCut ?? const PlutoGridShortcut(),
        style: buildGridStyleConfig(evenRowColor: evenRowColor),
        localeText: const PlutoGridLocaleText.arabic(),
      ),
      onLoaded: (PlutoGridOnLoadedEvent event) {
        controller.stateManager = event.stateManager;
        final newRows = controller.stateManager.getNewRows(count: 30);
        controller.stateManager.appendRows(newRows);
      },
    );
  }
}
