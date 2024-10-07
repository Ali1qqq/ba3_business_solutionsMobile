import 'package:ba3_business_solutions/controller/cards_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../../model/card_model.dart';

class WriteCardView extends StatefulWidget {
  const WriteCardView({super.key});

  @override
  State<WriteCardView> createState() => _WriteCardViewState();
}

class _WriteCardViewState extends State<WriteCardView> {
  UserManagementViewModel userViewController = Get.find<UserManagementViewModel>();
  CardsViewModel cardViewController = Get.find<CardsViewModel>();
  // TextEditingController cardController = TextEditingController();
  String? userId;
  String? cardId;
  bool? isDisabled;
  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      print(tag.data);
      List<int> idList = tag.data["ndef"]['identifier'];
      String id ='';
      for(var e in idList){
        if(id==''){
          id="${e.toRadixString(16).padLeft(2,"0")}";
        }else{
          id="$id:${e.toRadixString(16).padLeft(2,"0")}";
        }
      }
      cardId=id.toUpperCase();
      if(cardViewController.allCards.containsKey(cardId)) {
        CardModel cardModel = cardViewController.allCards[cardId]!;
        userId = cardModel.userId;
        isDisabled=cardModel.isDisabled;
      }
      Get.back();
      setState(() {});
      print(cardId);
      NfcManager.instance.stopSession();
    });
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) => {
      Get.defaultDialog(
          title: "جارِ قراءة البطاقة",
          content:Text( "يرجى تقريب البطاقة"),
          actions: [ElevatedButton(onPressed: (){
            Get.back();
            NfcManager.instance.stopSession();
          }, child: Text("إلغاء"))]
      )
    });
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text("يرجى إختيار الحساب"),
            SizedBox(height: 10,),
            Text(cardId??""),
            SizedBox(height: 10,),
            Text("يرجى إختيار الحساب"),
            DropdownButton(
              value: userId,
              items:userViewController.allUserList.entries.map((e) => DropdownMenuItem(value: e.key,child: Text(e.value.userName!),)).toList(),onChanged: (_){
              userId=_;
                setState(() {});
              },
            ),
            Checkbox(value: isDisabled??false, onChanged: (_){
              isDisabled = _;
              setState(() {});
            }),
            ElevatedButton(onPressed: (){
              if(isDisabled==null){
                isDisabled=false;
              }
              if(userId!=null&&cardId!=null) {
                FirebaseFirestore.instance.collection("Cards").doc(cardId).set({
                  "userId":userId,
                  "cardId":cardId,
                  "isDisabled":isDisabled
                },SetOptions(merge: true));
              //   NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
              //     Get.back();
              //   var ndef = Ndef.from(tag);
              //   if (ndef == null || !ndef.isWritable) {
              //     // result.value = 'Tag is not ndef writable';
              //     // NfcManager.instance.stopSession(errorMessage: result.value);
              //     return;
              //   }
              //
              //   NdefMessage message = NdefMessage([
              //     NdefRecord.createText(cardId!),
              //     NdefRecord.createText(userId!),
              //   ]);
              //   try {
              //     await ndef.write(message);
              //
              //     NfcManager.instance.stopSession();
              //   } catch (e) {
              //     NfcManager.instance.stopSession(errorMessage:"" );
              //     return;
              //   }
              // });
              }else{
                Text("يرجى تعبئة جميع البيانات");
              }
            }, child: Text("إضافة"))
          ],
        ),
      ),
    ));
  }
}
