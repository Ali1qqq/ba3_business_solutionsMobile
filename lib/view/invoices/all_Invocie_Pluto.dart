// import 'package:ba3_business_solutions/controller/invoice_view_model.dart';
// import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
// import 'package:ba3_business_solutions/view/widget/Custom_Pluto_Grid.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pluto_grid/pluto_grid.dart';
//
// import '../../Widgets/new_Pluto.dart';
// import '../../model/global_model.dart';
//
//
// class AllInvoice extends StatelessWidget {
//   AllInvoice({super.key});
//
//   final Map<String, PlutoColumnType> data = {
//     "الرمز": PlutoColumnType.text(),
//     "User Name": PlutoColumnType.text(),
//     "الاسم الكامل": PlutoColumnType.text(),
//     "كامة السر": PlutoColumnType.text(),
//     "الدور": PlutoColumnType.text(),
//     "الحالة": PlutoColumnType.text(),
//     "رقم الموبايل": PlutoColumnType.text(),
//     "العنوان": PlutoColumnType.text(),
//     "الجنسية": PlutoColumnType.text(),
//     "الجنس": PlutoColumnType.text(),
//     "العمر": PlutoColumnType.text(),
//     "الوظيفة": PlutoColumnType.text(),
//     "العقد": PlutoColumnType.text(),
//     "الحافلة": PlutoColumnType.text(),
//     "تاريخ البداية": PlutoColumnType.text(),
//     "سجل الاحداث": PlutoColumnType.text(),
//     "موافقة المدير": PlutoColumnType.text(),
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     InvoiceViewModel invoiceViewModel = Get.find<InvoiceViewModel>();
//     RxMap<String, GlobalModel> data = invoiceViewModel.invoiceModel;
//     return Scaffold(
//       body: CustomPlutoGrid(
//         init: () async {
//           IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
//           isolateViewModel.init();
//           print("from invoice View");
//           final a = await compute<({List<dynamic> a, IsolateViewModel isolateViewModel}), List<PlutoCell>>((message) {
//             Get.put(message.isolateViewModel);
//             List<PlutoCell> dataGridRow = message.a
//                 .map<PlutoCell>((order) => PlutoCell(value: [
//                       PlutoCell(key: order.affectedKey(), value: order.affectedId()),
//                       ...order!
//                           .toMap()
//                           .entries
//                           .map((mapEntry) {
//                             return PlutoCell(key: mapEntry.key, value: mapEntry.value.toString());
//                           })
//                           .cast<PlutoCell>()
//                           .toList()
//                     ]))
//                 .toList();
//             return dataGridRow;
//           }, (a: data.values.toList(), isolateViewModel: isolateViewModel));
//
//           return a;
//         },
//         rows: [],
//         columns: [],
//         onSelected: (event) {},
//       ),
//     );
//   }
// }
