import 'package:ba3_business_solutions/controller/account_view_model.dart';

import 'package:ba3_business_solutions/view/statistics/widget/chart_widget2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class StatisticsView extends StatefulWidget {
  final String accountId;

  const StatisticsView({super.key, required this.accountId});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  Map<String, double> allRec = {};
  List allMonth = [];
  bool isDay = false;
  GlobalKey chartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: GetBuilder<AccountViewModel>(builder: (controller) {
          allMonth.clear();
          controller.accountList[widget.accountId]!.accRecord.toList().forEach(
            (element) {
              String date = element.date!.split(" ")[0];
              String year = date.split("-")[0];
              String month = date.split("-")[1];
              if (!allMonth.contains("$year-$month")) {
                allMonth.add("$year-$month");
              }
            },
          );
          return Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 10,),
                  ElevatedButton(
                      onPressed: () {
                        allRec.clear();
                        controller.accountList[widget.accountId]!.accRecord.toList().forEach(
                              (element) {
                            String a = element.date!.split("-")[1];
                              double total = element.total == "NaN"?0:double.tryParse(element.total!)!.roundToDouble();
                            if (allRec[a] == null) {
                              allRec[a] = total;
                            } else {
                              allRec[a] = total + allRec[a]!;
                            }
                          },
                        );
                        allRec = Map.fromEntries(allRec.entries.toList()..sort((a, b) => a.key.compareTo(b.key),));
                        isDay = false;
                        chartKey = GlobalKey();
                        setState(() {});
                      },
                      child: Text("عرض بالأشهر")),
                  SizedBox(width: 10,),
                  ElevatedButton(
                      onPressed: () {
                        allRec.clear();
                        controller.accountList[widget.accountId]!.accRecord.toList().forEach(
                          (element) {
                            String date = element.date!.split(" ")[0];
                        String year = date.split("-")[0];
                        String month = date.split("-")[1];
                        String day = date.split("-")[2];
                        String monthNow = DateTime.now().toString().split(" ")[0].split("-")[1];
                        String yearNow = DateTime.now().toString().split(" ")[0].split("-")[0];
                        if (year == yearNow&&month == monthNow) {
                          double total = element.total == "NaN"?0:double.tryParse(element.total!)!.roundToDouble();
                            if (allRec[day] == null) {
                              allRec[day] = total;
                            } else {
                              allRec[day] = total + allRec[day]!;
                             }
                        }
                          },
                        );
                        allRec = Map.fromEntries(allRec.entries.toList()..sort((a, b) => a.key.compareTo(b.key),));
                        chartKey = GlobalKey();
                        isDay = true;
                        print("object");
                        setState(() {});
                      },
                      child: Text("هذا الشهر")),
                  SizedBox(width: 10,),
                  for (var i in allMonth)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ElevatedButton(
                          onPressed: () {
                            allRec.clear();
                            controller.accountList[widget.accountId]!.accRecord.toList().forEach(
                              (element) {
                                    String date = element.date!.split(" ")[0];
                                String year = date.split("-")[0];
                                String month = date.split("-")[1];
                                String day = date.split("-")[2];
                                if (year == i.toString().split("-")[0]&&month == i.toString().split("-")[1]) {
                                    double total = element.total == "NaN"?0:double.tryParse(element.total!)!.roundToDouble();
                                  if (allRec[day] == null) {
                                    allRec[day] =total;
                                  } else {
                                    allRec[day] =total + allRec[day]!;
                                  }
                                }
                              },
                            );
                            allRec = Map.fromEntries(allRec.entries.toList()
                              ..sort(
                                (a, b) => a.key.compareTo(b.key),
                              ));
                            isDay = true;
                            chartKey = GlobalKey();
                            setState(() {});
                          },
                          child: Text(i.toString())),
                    ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                  child: allRec.isEmpty
                      ? Center(
                          child: Text("اختر احد التصنيفات"),
                        )
                      : SizedBox(
                    width: MediaQuery.sizeOf(context).width-20,
                        height: 100,
                        child: LineChartWidget2(
                            key: chartKey,
                            allSpots: allRec.entries
                                .map(
                                  (entrie) => FlSpot(double.parse(entrie.key), entrie.value),
                                )
                                .toList(),
                            keys: allRec.keys.toList(),
                          isDay: isDay,),
                      )),
            ],
          );
        }),
      ),
    );
  }
}
