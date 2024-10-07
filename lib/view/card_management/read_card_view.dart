import 'package:ba3_business_solutions/controller/cards_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/model/card_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';

class ReadCardView extends StatefulWidget {
  const ReadCardView({super.key});

  @override
  State<ReadCardView> createState() => _ReadCardViewState();
}

class _ReadCardViewState extends State<ReadCardView> {
  CardsViewModel cardsViewController = Get.find<CardsViewModel>();

  String? cardId;
  String? userId;
 CardModel? cardModel;
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
      if(cardsViewController.allCards.containsKey(cardId)){
        cardModel = cardsViewController.allCards[cardId]!;
        Get.back();
        setState(() {});
      }else{
        Get.back();
        Get.back();
        Get.snackbar("خطأ", "غير مدخلة");
      }
      print(cardId);
      NfcManager.instance.stopSession();
    });
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) => {
      Get.defaultDialog(
        title: "جارِ قراءة البطاقة",
        content:Text( "يرجى تقريب البطاقة"),
        actions: [ElevatedButton(onPressed: (){
          Get.back();
        }, child: Text("إلغاء"))]
      )
    });
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: cardModel==null
          ?Text("هذه البطاقة غير معرفة")
          :Column(
            children: [
              Text("رقم البطاقة",style: TextStyle(fontSize: 22),textDirection: TextDirection.ltr),
              SizedBox(height: 10),
              Text(cardModel!.cardId.toString(),style: TextStyle(fontSize: 22),textDirection: TextDirection.ltr),
              SizedBox(height: 40,),
              Text("صالحة لدخول الحساب",style: TextStyle(fontSize: 22),),
              SizedBox(height: 10,),
              Text(getUserNameById(cardModel!.userId.toString()),style: TextStyle(fontSize: 22),),
              SizedBox(height: 40,),
              Text("تم إلغائها؟ ",style: TextStyle(fontSize: 22),),
              SizedBox(height: 10,),
              Text(cardModel!.isDisabled!?"نعم":"لا",style: TextStyle(fontSize: 22),),
            ],
          ),
        ),
      ),
    );
  }
}
