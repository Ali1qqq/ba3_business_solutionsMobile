import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showLoadingDialog({required int total,required Future<void> Function(int index) fun}) async {
  await Get.defaultDialog(
    title: "يرجى الانتظار",
    barrierDismissible: false,
    content:  _LoadingView(total:total, fun: fun,)
  );
}
class _LoadingView extends StatefulWidget {
  final int total ;
  final Future<void> Function(int index) fun;
  const _LoadingView({ required this.total, required this.fun});
  @override
  State<_LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<_LoadingView> {
  bool isCancel = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
      Future.sync(() async {
        await longTask();
        Get.back();
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("$i  /  ${widget.total}"),
        const SizedBox(height: 10,),
        const CircularProgressIndicator(),
        const SizedBox(height: 10,),
        ElevatedButton(onPressed: (){
          isCancel=true;
        }, child: const Text("cancel"))
      ],
    );
  }

  int i = 0;
  Future<void> longTask() async {
    for (int index=0 ;index < widget.total;index++) {
      if(isCancel)return;
      i++;
      print(i.toString());
      setState(() {});
      await widget.fun(index);
    }
  }
}
