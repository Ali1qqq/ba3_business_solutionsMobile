import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TargetPointerWidget extends StatefulWidget {
  final int value;
  const TargetPointerWidget({super.key, required this.value});

  @override
  State<TargetPointerWidget> createState() => TargetPointerWidgetState();
}

class TargetPointerWidgetState extends State<TargetPointerWidget> {

  late Timer _timer;
  int _value = 0;
  int limit = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildWidgetPointerExample(context),
        Container(
          height: 50,
          width: 110,
          decoration: BoxDecoration(color: const Color.fromRGBO(33, 33, 33, 1),borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
                '$_value',
                maxLines: 1,
                style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                ),),
          )
        ),
      ],
    );
  }


  @override
  void initState() {
    limit = widget.value;
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  void _startTimer() {
    if (mounted) {
      _timer = Timer.periodic(const Duration(microseconds: 500), (Timer timer) {
        _incrementPointerValue();
      });
    }
  }

  void _incrementPointerValue() {
    setState(() {
      if (_value == limit) {
        _timer.cancel();
      } else {
        _value++;
      }
    });
  }

  void addValue(int _){
    limit = _;
    _startTimer();
  }

  void removeValue(int _){
    limit = _;
    _startReverceTimer();
  }
  void _startReverceTimer() {
    if (mounted) {
      _timer = Timer.periodic(const Duration(microseconds: 500), (Timer timer) {
        _decrementPointerValue();
      });
    }
  }void _decrementPointerValue() {
    setState(() {
      if (_value == limit) {
        _timer.cancel();
      } else {
        _value--;
      }
    });
  }

  SfRadialGauge _buildWidgetPointerExample(BuildContext context)
  {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          interval: 5000,
          labelOffset: 0.150,
          tickOffset: .25,
          minorTicksPerInterval: 0,
          labelsPosition: ElementsPosition.outside,
          offsetUnit: GaugeSizeUnit.factor,
          showAxisLine: false,
          showLastLabel: true,
          maximum: 75000,
          pointers: <GaugePointer>[
            NeedlePointer(
            needleEndWidth: 5,
            needleLength: 0.7,
            value: _value.toDouble(),
            knobStyle: const KnobStyle(knobRadius: 0)),
            // WidgetPointer(
            //     value: _value.toDouble(),
            //     child: Container(
            //       decoration: BoxDecoration(
            //           color: const Color.fromRGBO(33, 33, 33, 1),
            //           borderRadius: BorderRadius.circular(20),
            //           boxShadow: <BoxShadow>[
            //             BoxShadow(
            //               color: Colors.white.withOpacity(0.2),
            //               blurRadius: 4.0,
            //             ),
            //           ],
            //           border: Border.all(
            //             color: Colors.white.withOpacity(0.1),
            //           )),
            //       height: 60,
            //       width: 100,
            //       child: Center(
            //         child: Text(
            //           '$_value',
            //           maxLines: 1,
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 25,
            //           ),
            //         ),
            //       )
            //     )
            //   )
          ],
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 50000,
              startWidth: 25,
              endWidth: 25,
              color: const Color.fromRGBO(74, 177, 70, 1),
            ),
            GaugeRange(
              startValue: 50000,
              endValue: 65000,
              startWidth: 25,
              endWidth: 25,
              color: const Color.fromRGBO(251, 190, 32, 1),
            ),
            GaugeRange(
              startValue: 65000,
              endValue: 75000,
              startWidth: 25,
              endWidth: 25,
              color: const Color.fromRGBO(237, 34, 35, 1),
            )
          ],
        )
      ],
    );
  }
}



