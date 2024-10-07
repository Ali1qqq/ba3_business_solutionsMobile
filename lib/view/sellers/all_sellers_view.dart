import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'all_seller_invoice_view.dart';

class AllSellers extends StatelessWidget {
  const AllSellers({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("جميع البائعون"),
        ),
        body: GetBuilder<SellersViewModel>(builder: (controller) {
          return controller.allSellers.isEmpty
              ? const Center(child: Text("لا يوجد بائعون بعد"),)
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: Get.width,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                          children: List.generate(controller.allSellers.values.length, (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                Get.to(() => AllSellerInvoice(oldKey: controller.allSellers.values.toList()[index].sellerId));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5),borderRadius: BorderRadius.circular(10)),
                                height: 140,
                                width: 140,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(controller.allSellers.values.toList()[index].sellerCode??"",style: const TextStyle(fontSize: 24),),
                                    Text(controller.allSellers.values.toList()[index].sellerName??"",style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                  ],
                                ),
                              ),
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
