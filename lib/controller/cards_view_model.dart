
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/card_model.dart';

class CardsViewModel extends GetxController {
  Map<String, CardModel> allCards = {};
  CardsViewModel() {
    getAllCard();
  }

  void getAllCard() {
    FirebaseFirestore.instance.collection("Cards").snapshots().listen((event) {
      allCards.clear();
      for (var element in event.docs) {
        allCards[element.id] = CardModel.fromJson(element.data());
      }
      update();
    });
  }


}

