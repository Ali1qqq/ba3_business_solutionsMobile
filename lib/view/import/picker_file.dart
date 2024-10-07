import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/import_view_model.dart';

class FilePickerWidget extends StatelessWidget {

   FilePickerWidget({super.key});

   final List allSeparator=["Tab (  )","comma (,)","semicolon (;)"];
   final List allSeparatorValue=["	",",",";"];

   @override
  Widget build(BuildContext context) {
     final importViewModel = Get.find<ImportViewModel>();

     var separator;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatefulBuilder(
                  builder: (context,setState) {
                    return DropdownButton(
                        value: separator,
                        items: allSeparator.map((e) => DropdownMenuItem(value: allSeparatorValue[allSeparator.indexOf(e)],child: Text(e))).toList(), onChanged: (_){
                      setState((){
                        separator=_;
                      });
                    });
                  }
              ),
              const SizedBox(height: 50,),
              ElevatedButton(
                onPressed: () {
                  if(separator!=null){
                    importViewModel.pickFile(separator);
                    //TODO:firebase
                    // checkPermissionForOperation(Const.roleUserAdmin,Const.roleViewImport).then((value) {
                    //   if(value);
                    // });
                  }else{
                    Get.snackbar("error", "plz select separator");
                  }
                },
                child: const Text("استيراد"),
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () {
                  if(separator!=null){
                    print("free");
                    // importViewModel.pickBondFile(separator);
                    importViewModel.pickBondFileFree(separator);
                  }else{
                    Get.snackbar("error", "plz select separator");
                  }
                },
                child: const Text("سندات"),
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () {
                  if(separator!=null){
                    print("free");
                    importViewModel.pickInvoiceFileFree(separator);
                    // importViewModel.pickInvoiceFile(separator);
                  }else{
                    Get.snackbar("error", "plz select separator");
                  }
                },
                child: const Text("فواتير"),
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () {
                  if(separator!=null){
                    importViewModel.pickNewType(separator);
                  }else{
                    Get.snackbar("error", "plz select separator");
                  }
                },
                child: const Text("تصحيح الفواتير"),
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () {
                    importViewModel.syncLocalAndFireBase();
                    // importViewModel.pickNewType(separator);
                },
                child: const Text("مزامنة"),
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () {
                  print("free");
                  // importViewModel.pickStarterBondFile(separator);
                  importViewModel.pickStarterBondFileFree(separator);
                },
                child: const Text("سندات القيد"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
