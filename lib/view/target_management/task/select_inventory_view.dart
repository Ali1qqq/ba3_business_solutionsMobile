

import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tree_pro/flutter_tree.dart';
import 'package:get/get.dart';

import '../../../model/inventory_model.dart';



class SelectTaskInventory extends StatefulWidget {
   final  String userId;
  const SelectTaskInventory({Key? key, required this.userId}) : super(key: key);


  @override
  _SelectTaskInventoryState createState() => _SelectTaskInventoryState();
}

class _SelectTaskInventoryState extends State<SelectTaskInventory> {
  List<Map<String, dynamic>> treeListData = [];

  List allData  =[];

  @override
  void initState() {
    // loadData();
    super.initState();
  }

/*  loadData() async {

    IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
    isolateViewModel.init();

    compute<({List<dynamic> a ,IsolateViewModel isolateViewModel}),({List<Map<String, dynamic>> initialTreeData , List<Map<String, dynamic>> treeListData })>((message) {
// print(message)
      IsolateViewModel isolateViewModel = Get.put(message.isolateViewModel);

      ProductModel a = ProductModel(prodName: "ALL DATA",prodId: 'prod1',prodParentId: "prod0",prodFullCode: "0");

     List<ProductModel> dataList = isolateViewModel.productDataMap.values.toList();


     dataList.add(a);

     List<Map<String, dynamic>> treeListData = [];
     List<Map<String, dynamic>> initialTreeData = [];

      treeListData = dataList.map((e) => e.toTree()).toList();
      for (var element in (message.a)) {
        ProductModel model =getProductModelFromId(element)!;//isoLate
        initialTreeData.add(model.toTree());
      }
     return (initialTreeData:initialTreeData,treeListData:treeListData);
    }, (
    *//*a:HiveDataBase.inventoryModelBox.get("0")?.inventoryTargetedProductList??[],
    isolateViewModel:isolateViewModel)*//*).then((value) {

      treeListData=value.treeListData ;
      print(treeListData.length);
      setState(() { });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("إنشاء جرد"),
          actions: [
            ElevatedButton(onPressed: () async {
              // widget.inventoryModel.inventoryTargetedProductList = allData;
             // await HiveDataBase.inventoryModelBox.put("0", InventoryModel(inventoryUserId: getMyUserUserId(),inventoryId: generateId(RecordType.inventory), inventoryDate: DateTime.now().toString().split(" ")[0], inventoryName: nameController.text, inventoryRecord: {}, inventoryTargetedProductList: allData));
              InventoryModel _ =  InventoryModel(inventoryId: generateId(RecordType.inventory),
                  inventoryName: "جرد باسم: "+getUserNameById(widget.userId),
                  inventoryDate: DateTime.now().toString().split(".")[0],
                  inventoryRecord: {},
                  inventoryTargetedProductList: {},
                  inventoryUserId: widget.userId,
              );
              Get.back(result: _);
            }, child: Text("موافق")),
            SizedBox(width: 10,),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("المواد المراد جردها",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              Expanded(child: treeListData.isNotEmpty
                  ? FlutterTreePro(
                isExpanded: false,
                listData: treeListData,
                config: const Config(
                  parentId: 'parentId',
                  dataType: DataType.DataList,
                  label: 'value',
                ),
                onChecked: (List<Map<String, dynamic>> checkedList) {
                  allData.clear();
                  if(checkedList == [])return;
                  addChild(checkedList);
                },
              )
                  : const Center(child: CircularProgressIndicator()))
            ],
          ),
        ),
      ),
    );
  }
  addChild(list){
    for (var element in list) {
      if(element['children']==null){
        allData.add("prod"+element['id'].toString());
      }else{
        addChild(element['children']);
      }
    }
  }
}