// import 'package:ba3_business_solutions/controller/user_management_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../Const/app_constants.dart';
// import '../../../controller/sellers_view_model.dart';
//
// class rec {
//   late String date;
//   late double amount;
//   rec(this.date,this.amount);
// }
// class SellerChart extends StatefulWidget {
//   const SellerChart({super.key});
//
//   @override
//   State<SellerChart> createState() => _SellerChartState();
// }
//
// class _SellerChartState extends State<SellerChart> {
//   SellersViewModel sellerController = Get.find<SellersViewModel>();
//
//   List left=[0,0.25,0.5,0.75,1];
//   @override
//   void initState() {
//     super.initState();
//     sellerController.initChart();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection(Const.sellersCollection).doc(getMyUserSellerId()).snapshots(),
//       builder: (context,snapshot) {
//         return GetBuilder<SellersViewModel>(
//           builder: (controller) {
//             controller.initChart();
//             print(snapshot.data?.data());
//             return Column(
//               children: [
//                 SizedBox(
//                   height: 400,
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: LineChart(
//                       LineChartData(
//                         lineTouchData: LineTouchData(
//                           handleBuiltInTouches: true,
//                           enabled: true,
//                           touchTooltipData: LineTouchTooltipData(
//                             tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
//                           ),
//                         ),
//                         gridData: gridData,
//                         titlesData: FlTitlesData(
//                           bottomTitles: AxisTitles(
//                             sideTitles: bottomTitles,
//                           ),
//                           rightTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                           topTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               getTitlesWidget: (a,b)=>leftTitleWidgets(a,b,controller),
//                               showTitles: true,
//                               interval: 1,
//                               reservedSize: 40,
//                             ),
//                           ),
//                         ),
//                         borderData: borderData,
//                         lineBarsData: controller.userMoney.entries.toList().map((e) => lineChartBarData1_1(e.value,e.key,controller)).toList(),
//                         minX: 0,
//                         maxX: 31,
//                         maxY: controller.high,
//                         minY: 0,
//                       ),
//                       swapAnimationDuration: const Duration(milliseconds: 250),
//                     ),
//                   ),
//                 ),
//                 for(var i =0;i<controller.userMoney.length;i++)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Row(children: [
//                       Text(controller.userMoney.keys.toList()[i].toString()+" month"),
//                       SizedBox(width: 20,),
//                       Container(width: 30,height: 5,color: controller.colorMap[controller.userMoney.keys.toList()[i]],)
//                     ],),
//                   )
//
//               ],
//             );
//           }
//         );
//       }
//     );
//   }
//
//   // LineChartData get sampleData1 =>
//
//   // LineTouchData get lineTouchData1 =>
//
//
//   // FlTitlesData get titlesData1 =>
//
//
//   // List<LineChartBarData> get lineBarsData1 =>;
//       // [
//       //   lineChartBarData1_1,
//       //   // lineChartBarData1_2,
//       //   // lineChartBarData1_3,
//       // ];
//
//   Widget leftTitleWidgets(double value, TitleMeta meta,controller) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     );
//     String text;
//     if(controller.high==value){
//       text="${value.toInt().toString()} AED";
//     } else if(controller.high*0.25==value){
//       text="${value.toInt().toString()} AED";
//     }else if(controller.high*0.50==value){
//       text="${value.toInt().toString()} AED";
//     }else if(controller.high*0.75==value){
//       text="${value.toInt().toString()} AED";
//     } else if(0==value){
//       text="0 AED";
//     }
//     else{
//       return Container();
//     }
//     // switch (value.toInt()) {
//     //   case 100:
//     //     text = '1m';
//     //     break;
//     //   case 200:
//     //     text = '2m';
//     //     break;
//     //   case 300:
//     //     text = '3m';
//     //     break;
//     //   case 400:
//     //     text = '5m';
//     //     break;
//     //   case 500:
//     //     text = '6m';
//     //     break;
//     //   default:
//     //     return Container();
//     // }
//
//     return Text(text, style: style, textAlign: TextAlign.center);
//   }
//
//   // SideTitles leftTitles() =>
//
//
//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 16,
//     );
//     Widget text;
//     // switch (value.toInt()) {
//     //   case 1:
//     //     text = const Text('1 month', style: style);
//     //     break;
//     //   case 2:
//     //     text = const Text('2 month', style: style);
//     //     break;
//     //   case 12:
//     //     text = const Text('12 month', style: style);
//     //     break;
//     //   default:
//     //     text = const Text('');
//     //     break;
//     // }
//     if(value==0) return SizedBox();
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 10,
//       child:
//       Text((value).toInt().toString()),
//     );
//   }
//
//   SideTitles get bottomTitles =>
//       SideTitles(
//         showTitles: true,
//         reservedSize: 32,
//         interval: 1,
//         getTitlesWidget: bottomTitleWidgets,
//       );
//
//   FlGridData get gridData => FlGridData(show: false);
//
//   FlBorderData get borderData =>
//       FlBorderData(
//         show: true,
//         border: Border(
//           bottom:
//           BorderSide(color: Colors.blue.withOpacity(0.2), width: 4),
//           left: const BorderSide(color: Colors.transparent),
//           right: const BorderSide(color: Colors.transparent),
//           top: const BorderSide(color: Colors.transparent),
//         ),
//       );
//
//   LineChartBarData  lineChartBarData1_1 (Map<String,double> money,key,controller) {
//   return  LineChartBarData(
//         isCurved: true,
//         color: controller.colorMap[key],
//         barWidth: 8,
//         isStrokeCapRound: true,
//         dotData: FlDotData(show: false),
//         belowBarData: BarAreaData(show: false),
//         spots: money.entries.toList().map((e) => FlSpot(double.parse(e.key),e.value)).toList()
//         );
//   }
//
//
// }
