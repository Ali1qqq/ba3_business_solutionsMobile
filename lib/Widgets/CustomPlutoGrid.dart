import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'Pluto_View_Model.dart';

class CustomPlutoGrid extends StatelessWidget {
  const CustomPlutoGrid({super.key, required this.onLoaded, required this.onSelected, required this.modelList, this.onRowDoubleTap, required this.title, this.type});

  final Function(PlutoGridOnLoadedEvent) onLoaded;
  final List<dynamic> modelList;
  final Function(PlutoGridOnRowDoubleTapEvent)? onRowDoubleTap;
  final Function(PlutoGridOnSelectedEvent) onSelected;

  final String title;
  final String? type;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<PlutoViewModel>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: const SizedBox(),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Padding(padding: const EdgeInsets.all(8), child: Text("عدد العناصر المتأثرة: ${modelList.isEmpty ? modelList.length.toString() : modelList.length.toString()}")),
            ],
          ),
          body: PlutoGrid(
            key: controller.plutoKey,
            onLoaded: (event) {
              event.stateManager.setShowColumnFilter(true);
            },
            onSelected: onSelected,
            columns: controller.getColumns(modelList, type: type),
            rows: controller.getRows(modelList, type: type),
            mode: PlutoGridMode.selectWithOneTap,
            configuration: PlutoGridConfiguration(
              shortcut: const PlutoGridShortcut(),
              style: PlutoGridStyleConfig(
                enableRowColorAnimation: true,
                evenRowColor: Colors.blueAccent.withOpacity(0.5),
                columnTextStyle: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                activatedColor: Colors.white.withOpacity(0.5),
                // gridBackgroundColor: Colors.transparent,
                cellTextStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                gridPopupBorderRadius: const BorderRadius.all(Radius.circular(15)),
                gridBorderRadius: const BorderRadius.all(Radius.circular(15)),
                // gridBorderColor: Colors.transparent,
              ),
              localeText: const PlutoGridLocaleText.arabic(),
            ),
            createFooter: (stateManager) {
              stateManager.setPageSize(100, notify: false); // default 40
              return PlutoPagination(stateManager);
            },
          ),
        );
      }),
    );
  }
}
