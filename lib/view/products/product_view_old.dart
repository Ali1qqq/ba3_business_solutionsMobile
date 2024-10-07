import 'package:ba3_business_solutions/utils/logger.dart';
import 'package:ba3_business_solutions/view/products/widget/product_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/sliver_list_widget.dart';
import '../../controller/product_view_model.dart';
import '../../model/product_model.dart';

class AllProductOLD extends StatelessWidget {
  const AllProductOLD({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<ProductViewModel>(
          builder: (controller) {
            return SliverListWidget<ProductModel>(
              header: "المواد",
              hintText:"البحث عن منتج",
              allElement:controller.productDataMap.values.toList().where((element) => !element.prodIsGroup!).toList() ,
              childBuilder: (BuildContext context, item, int index) {
                return _prodItemWidget(item ,controller );
              },
              where: (item, String search) {
                return item.prodName!.toLowerCase().contains(search.toLowerCase()) ||item.prodFullCode!.toLowerCase().contains(search.toLowerCase())  ;
              },
            );
          }
        ),
      ),
    );
  }
  Widget _prodItemWidget(ProductModel model,controller){
    // PrintViewModel printViewModel = Get.find<PrintViewModel>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          logger(newData: model, transfersType: TransfersType.read);
          Get.to(() => ProductDetails(
            oldKey: model.prodId,
          ));
        },
        child: Row(
          children: [
            SizedBox(
                width: 150,
                child: Text(model.prodFullCode.toString(),style: const TextStyle(fontSize: 20),)),
            const SizedBox(width: 10,),
            Expanded(child: Text(model.prodName!,style: const TextStyle(fontSize: 20),)),
            const SizedBox(width: 30,),
            const Text("النوع: "),
            Text(model.prodIsLocal! ?"LOCAL":"FREE",style: const TextStyle(fontSize: 20),),
          ],
        ),
      ),
    );
  }

}
