import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class FilteringDataGrid<T> extends StatefulWidget {
  final void Function(int index, String id, void Function(String) init) onCellTap;
  final RxMap<String, T> dataGridSource;
  final String title;
  final T constructor;
  final String? globalType;
  final Future<InfoDataGridSource> Function() init;
  const FilteringDataGrid({super.key, required this.onCellTap, required this.dataGridSource, required this.title, required this.constructor, this.globalType, required this.init});

  @override
  State<FilteringDataGrid<T>> createState() => _FilteringDataGridState<T>();
}

class _FilteringDataGridState<T> extends State<FilteringDataGrid<T>> {
  String tab = "	";
  RegExp isArabic = RegExp(r"[\u0600-\u06FF]");
  String title = "UNKNOWN";
  InfoDataGridSource? infoDataGridSource;
  dynamic constructor;
  late ReceivePort receivePort;
  @override
  void initState() {
    widget.init().then((value) {
      infoDataGridSource = value;
      setState(() {});
    });

    widget.dataGridSource.listen(rebuild);
    title = widget.title;
    constructor = widget.constructor;
    super.initState();
  }

  @override
  void dispose() {
    infoDataGridSource = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: infoDataGridSource == null
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(title),
                actions: [
                  Text("عدد العناصر المتأثرة: ${infoDataGridSource!.effectiveRows.isEmpty ? infoDataGridSource!.dataGridRows.length.toString() : infoDataGridSource!.effectiveRows.length.toString()}"),
                  const SizedBox(
                    width: 25,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.lightBlue.shade100),
                        elevation: MaterialStatePropertyAll(0),
                      ),
                      onPressed: () {
                        exportData(infoDataGridSource!);
                      },
                      child: const Text("نسخ الجدول")),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
              body: title == "UNKNOWN"
                  ? Center(
                      child: Text("UNKNOWN TYPE"),
                    )
                  :
                  // infoDataGridSource!.effectiveRows.isEmpty && infoDataGridSource!.filterConditions.isNotEmpty
                  //     ? Center(
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Text("لايوجد بيانات لعرضها"),
                  //             SizedBox(
                  //               height: 20,
                  //             ),
                  //             ElevatedButton(
                  //                 onPressed: () {
                  //                   infoDataGridSource!.clearFilters();
                  //                   setState(() {});
                  //                   // infoDataGridSource!.buildDataGridRows();
                  //                 },
                  //                 child: Text("Clear"))
                  //           ],
                  //         ),
                  //       )
                  //     :
                  Builder(
                      // stream: widget.dataGridSource.stream,
                      builder: (context) {
                      print("The Grid Is setState");
                      return SfDataGrid(
                        onFilterChanged: (details) {},
                        allowSorting: true,
                        selectionMode: SelectionMode.none,
                        columnWidthMode: ColumnWidthMode.fill,
                        showHorizontalScrollbar: true,
                        showVerticalScrollbar: true,
                        allowFiltering: true,
                        isScrollbarAlwaysShown: false,
                        source: infoDataGridSource!,
                        onCellTap: (DataGridCellTapDetails dataGridCellTapDetails) {
                          if (dataGridCellTapDetails.rowColumnIndex.rowIndex - 1 >= 0) {
                            if (infoDataGridSource!.effectiveRows.isEmpty) {
                              widget.onCellTap(dataGridCellTapDetails.rowColumnIndex.rowIndex - 1, infoDataGridSource!.rows[dataGridCellTapDetails.rowColumnIndex.rowIndex - 1].getCells()[0].value,rebuild);
                            } else {
                              widget.onCellTap(dataGridCellTapDetails.rowColumnIndex.rowIndex - 1, infoDataGridSource!.effectiveRows[dataGridCellTapDetails.rowColumnIndex.rowIndex - 1].getCells()[0].value,rebuild);
                            }
                          }
                        },
                        columns: [
                          GridColumn(
                              visible: false,
                              // width: double.nan,
                              columnWidthMode: ColumnWidthMode.auto,
                              columnName: constructor.affectedKey(type: widget.globalType).toString(),
                              label: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          constructor.affectedKey(type: widget.globalType).toString() + tab,
                                          textDirection: isArabic.hasMatch(constructor.affectedKey(type: widget.globalType).toString()) ? TextDirection.rtl : TextDirection.ltr,
                                          style: TextStyle(fontSize: 16),
                                          maxLines: null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          ...(widget.globalType != null ? constructor.toMap(type: widget.globalType).entries : constructor.toMap().entries)
                              .map((e) => GridColumn(
                                  // width: double.nan,
                                  columnWidthMode: ColumnWidthMode.fill,
                                  columnName: e.key.toString(),
                                  label: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child:  Text(
                                              e.key.toString() == (widget.globalType != null ? constructor.toMap(type: widget.globalType).entries : constructor.toMap().entries).last.key ? e.key.toString() + '\n' : e.key.toString() + tab,
                                              textDirection: isArabic.hasMatch(e.toString()) ? TextDirection.rtl : TextDirection.ltr,
                                              style: TextStyle(fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: null,
                                            ),
                                      ),
                                    ],
                                  )))
                              .cast<GridColumn>()
                              .toList()
                        ],
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                      );
                    })),
    );
  }

  void rebuild( dart) async {
    Map<String, List<FilterCondition>> oldFilter = infoDataGridSource?.filterConditions ?? {};
    List<SortColumnDetails> oldSort = infoDataGridSource?.sortedColumns ?? [];
    widget.init().then((value) {
      infoDataGridSource = value;
      oldFilter.forEach((key, value) {
        for (var element in value) {
          infoDataGridSource!.addFilter(key, element);
        }
      });
      infoDataGridSource!.sortedColumns.addAll(oldSort);
      if (mounted) {
        WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) => setState(() {}));
      }
    });
  }
}

void exportData(InfoDataGridSource infoDataGridSource) async {
  String tab = "	";

  final allData = await compute<({List<DataGridRow> a, DataGridRow b}), String>((message) {
    String _ = "";
    List<List> data = [];
    data = (message.a.map((e) => e.getCells().map((e) => e.value).toList()).toList());
    String header = message.b.getCells().map((e) => e.columnName).toList().join(tab) + "\n";
    _ = header;
    _ = _ + data.map((e) => e.map((e) => e.toString()).join(tab)).join("\n");
    return _;
  }, (a: infoDataGridSource.effectiveRows, b: infoDataGridSource.dataGridRows[0]));

  Clipboard.setData(ClipboardData(text: allData));
  Get.snackbar("عملية ناجحة", "تم النسخ بنجاح");
}

class InfoDataGridSource extends DataGridSource {
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  String currencySymbol = '';

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = dataGridRows.indexOf(row);
    Color backgroundColor = Colors.transparent;
    if ((rowIndex % 2) == 0) {
      backgroundColor = Colors.white38;
    }
    RegExp isArabic = RegExp(r"[\u0600-\u06FF]");
    String tab = "	";

    return DataGridRowAdapter(
      color: backgroundColor,
      cells: List.generate(row.getCells().length, (index) {
        return Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.getCells().last.columnName == row.getCells()[index].columnName ? (row.getCells()[index].value??"").toString() + '\n' : (row.getCells()[index].value??"").toString() + tab,
                    textDirection: isArabic.hasMatch(row.getCells()[index].value.toString()) ? TextDirection.rtl : TextDirection.ltr,
                    style: TextStyle(fontSize: 12),
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
