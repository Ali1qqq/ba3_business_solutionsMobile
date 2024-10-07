import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tree_pro/flutter_tree.dart';
import 'package:get/get.dart';
import '../../controller/product_view_model.dart';
import '../../model/inventory_model.dart';
import '../../model/product_model.dart';
import '../../utils/hive.dart';

class NewInventoryView extends StatefulWidget {
  const NewInventoryView({Key? key}) : super(key: key);

  @override
  _NewInventoryViewState createState() => _NewInventoryViewState();
}

class _NewInventoryViewState extends State<NewInventoryView> {
  List<Map<String, dynamic>> treeListData = [];
  TextEditingController dateInventoryController = TextEditingController(text: "جرد بتاريخ ${DateTime.now().toString().split(" ")[0]}");
  List allData = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    // IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
    // isolateViewModel.init();
    ProductViewModel productViewModel = Get.find<ProductViewModel>();

    ProductModel a = ProductModel(prodName: "ALL DATA", prodId: 'prod1', prodParentId: "prod0", prodFullCode: "0");

    List<ProductModel> dataList = productViewModel.productDataMap.values.toList();
    dataList.add(a);

    List<Map<String, dynamic>> initialTreeData = [];

    treeListData = dataList.map((e) => e.toTree()).toList();
    for (var element in dataList) {
      print(element.prodId);
      if(element.prodId!="prod1") {
        ProductModel model = getProductModelFromId(element.prodId) ?? ProductModel();
        initialTreeData.add(model.toTree());
      }
    }
    treeListData=initialTreeData;
    /*compute<({List<dynamic> a, IsolateViewModel isolateViewModel}), ({List<Map<String, dynamic>> initialTreeData, List<Map<String, dynamic>> treeListData})>((message) {
      IsolateViewModel isolateViewModel = Get.put(message.isolateViewModel);

      ProductModel a = ProductModel(prodName: "ALL DATA", prodId: 'prod1', prodParentId: "prod0", prodFullCode: "0");

      List<ProductModel> dataList = isolateViewModel.productDataMap.values.toList();
      dataList.add(a);
      List<Map<String, dynamic>> treeListData = [];
      List<Map<String, dynamic>> initialTreeData = [];

      treeListData = dataList.map((e) => e.toTree()).toList();
      for (var element in (message.a)) {
        ProductModel model = getProductModelFromIdIsolate(element)!;
        initialTreeData.add(model.toTree());
      }
      return (initialTreeData: initialTreeData, treeListData: treeListData);
    }, (a: HiveDataBase.inventoryModelBox.get("0")?.inventoryTargetedProductList ?? [], isolateViewModel: isolateViewModel)).then((value) {
      treeListData = value.treeListData;

      setState(() {});
      print("${treeListData.length}-------");
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("إنشاء جرد"),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  // widget.inventoryModel.inventoryTargetedProductList = allData;
                  await HiveDataBase.inventoryModelBox
                      .put("0", InventoryModel(inventoryUserId: getMyUserUserId(), inventoryId: generateId(RecordType.inventory), inventoryDate: DateTime.now().toString().split(" ")[0], inventoryName: dateInventoryController.text, inventoryRecord: {}, inventoryTargetedProductList: {}));
                  setState(() {});
                  Get.back();
                },
                child: Text("موافق")),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "اسم الجرد: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                      height: 60,
                      width: 400,
                      child: TextFormField(
                        controller: dateInventoryController,
                        decoration: InputDecoration(hintText: "اسم الجرد"),
                      )),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "المواد المراد جردها",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: treeListData.length > 1
                      ? FlutterTreePro(
                          isExpanded: true,
                          listData: treeListData,
                          config: Config(
                            parentId: 'parentId',
                            dataType: DataType.DataList,
                            label: 'value',
                          ),
                          onChecked: (List<Map<String, dynamic>> checkedList) {
                            print(checkedList.length);
                            allData.clear();
                            if (checkedList == []) return;
                            addChild(checkedList);
                          },
                        )
                      : Center(child: CircularProgressIndicator()))
            ],
          ),
        ),
      ),
    );
  }

  addChild(list) {
    for (var element in list) {
      if (element['children'] == null) {
        allData.add("prod" + element['id'].toString());
      } else {
        addChild(element['children']);
      }
    }
  }
}
