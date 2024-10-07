import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

List<PlutoColumn> toPlutoAR(Map<String, PlutoColumnType> data) {
  List<PlutoColumn> columns = data.entries.map((entry) {

    return PlutoColumn(
      title: entry.key.toString().tr,
      field: entry.key,
      type: entry.value,
      enableAutoEditing: false,
      enableColumnDrag: false,
      enableEditingMode: false,
      hide: entry.key == data.keys.first,
    );
  }).toList();

  return columns;
}