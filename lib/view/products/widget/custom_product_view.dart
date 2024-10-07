/*
import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/view/products/widget/product_details.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../utils/logger.dart';
import '../../widget/filtering_data_grid.dart';


class CustomAllProduct extends StatelessWidget {
  final Map<String, ProductModel> data ;
  const CustomAllProduct({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ProductViewModel productViewModel = Get.find<ProductViewModel>();
    // RxMap<String, ProductModel> data = Map.fromEntries(productViewModel.productDataMap.entries.where((element) => !element.value.prodIsGroup!).toList()).obs;
    // RxMap<String, ProductModel> data = productViewModel.productDataMap;
    return Scaffold(
      body: FilteringDataGrid<ProductModel>(
        title: "مواد",
        constructor: ProductModel(),
        dataGridSource:data.obs,
        onCellTap: (index,id,init) {
          ProductModel model = data[id]!;
          logger(newData: model, transfersType: TransfersType.read);
          Get.to(() => ProductDetails(
            oldKey: model.prodId,
          ));
        },
        init: ()async {
          // IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
          isolateViewModel.init();
          print("from product View");
          final a = await   compute<({Map<String, ProductModel> data ,IsolateViewModel isolateViewModel}),List<DataGridRow>>((message) {
            Get.put(message.isolateViewModel);
            List<DataGridRow> dataGridRow  = message.data.values.where((element) => !element.prodIsGroup!).toList()
                .map<DataGridRow>((order) => DataGridRow(cells: [
              DataGridCell(columnName: order.affectedKey()!, value: order.affectedId()),
              ...order
                  .toMap()
                  .entries
                  .map((mapEntry) {
                return DataGridCell<String>(columnName: mapEntry.key, value: mapEntry.value.toString());
              }).cast<DataGridCell<dynamic>>().toList()
            ])).toList();
            return dataGridRow;
          },(data:data,isolateViewModel:isolateViewModel));
          InfoDataGridSource  infoDataGridSource = InfoDataGridSource();
          infoDataGridSource.dataGridRows =a;
          return infoDataGridSource;

        },
      ),
    );
  }
}*/
