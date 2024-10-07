import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateMonthPicker extends StatefulWidget {
  final Function(DateTime date ) onSubmit;
  final String? initDate;
  const DateMonthPicker({super.key, required this.onSubmit, this.initDate});

  @override
  State<DateMonthPicker> createState() => _DateMonthPickerState();
}


class _DateMonthPickerState extends State<DateMonthPicker> {
  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all()),
      width: 150,
      height: 40,
      child: InkWell(
          onTap: () {
            Get.defaultDialog(
                title: "اختر يوم",
                content: SizedBox(
                  height: MediaQuery.sizeOf(context).height/1.6,
                  width: MediaQuery.sizeOf(context).height/1,
                  child: SfDateRangePicker(
                    initialDisplayDate: DateTime(int.parse(widget.initDate!.split("-")[0]) , int.parse(widget.initDate!.split("-")[1]),01),
                    enableMultiView: true,
                    backgroundColor: Colors.transparent,
                    view: DateRangePickerView.year,
                    monthViewSettings: DateRangePickerMonthViewSettings(),
                    allowViewNavigation: false,
                    headerStyle: DateRangePickerHeaderStyle(backgroundColor: Colors.transparent),
                    navigationDirection: DateRangePickerNavigationDirection.vertical,
                    selectionMode: DateRangePickerSelectionMode.single,
                    // monthViewSettings: const DateRangePickerMonthViewSettings(enableSwipeSelection: false),
                    showNavigationArrow: true,
                    navigationMode: DateRangePickerNavigationMode.scroll,
                    onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                      DateTime _ = dateRangePickerSelectionChangedArgs.value as DateTime;
                      _date = _;
                    },
                  ),
                ),
                actions: [

                  ElevatedButton(
                      onPressed: () {
                        if (_date != null) {
                          widget.onSubmit(_date!);
                        }
                        Get.back();
                        setState(() {});
                      },
                      child: Text("تم")),
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("إلغاء"))
                ]);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(widget.initDate != null
                    ? widget.initDate.toString().split(" ").first
                    : _date == null
                        ? "اختر شهر"
                        : _date!.year.toString() + "-" + _date!.month.toString()),
                Spacer(),
                Icon(Icons.date_range)
              ],
            ),
          )),
    );
  }
}
