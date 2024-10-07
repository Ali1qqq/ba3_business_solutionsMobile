import 'package:ba3_business_solutions/Const/const.dart';

import 'package:ba3_business_solutions/model/entry_bond_record_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/view/entry_bond/entry_bond_details_view.dart';
import 'package:ba3_business_solutions/view/entry_bond/widget/bond_record_data_source.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';


class EntryBondViewModel extends GetxController {
  RxMap<String, GlobalModel> allEntryBonds = <String, GlobalModel>{}.obs;
  late EntryBondRecordDataSource recordDataSource;

  Map<String, String> codeList = {};
  String? lastEntryBondOpened;
  GlobalModel tempBondModel = GlobalModel();

  initCodeList() {
    codeList = {};
    // for (var element in allEntryBonds.values) {
    //   codeList[element.entryBondCode!] = element.globalId!;
    // }
    // codeList = Map.fromEntries(codeList.entries.toList()
    //   ..sort(
    //     (a, b) => int.parse(a.key).compareTo(int.parse(b.key)),
    //   ));
  }

  void initPage() {
    initTotal();
    recordDataSource = EntryBondRecordDataSource(recordData: tempBondModel);
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
      update();
    });
  }

  void initTotal() {
    double debit = 0;
    double credit = 0;
    tempBondModel.entryBondRecord?.forEach((element) {
      debit = debit + (element.bondRecDebitAmount ?? 0);
      credit = credit + (element.bondRecCreditAmount ?? 0);
    });
    tempBondModel.bondTotal = (debit - credit).toStringAsFixed(2);
  }

  prevBond() {
    initCodeList();
    var index = codeList.values.toList().indexOf(tempBondModel.entryBondId!);
    if (codeList.values.toList().first == codeList.values.toList()[index]) {
    } else {
      tempBondModel = GlobalModel.fromJson(allEntryBonds[codeList.values.toList()[index - 1]]?.toFullJson());
      Get.off(() => EntryBondDetailsView(oldId: tempBondModel.entryBondId));
      update();
      initPage();
    }
  }

  firstBond() {
    initCodeList();
    var index = codeList.values.toList().indexOf(tempBondModel.entryBondId!);
    if (codeList.values.toList().first == codeList.values.toList()[index]) {
    } else {
      tempBondModel = GlobalModel.fromJson(allEntryBonds[codeList.values.toList().first]?.toFullJson());
      Get.off(() => EntryBondDetailsView(oldId: tempBondModel.entryBondId));
      update();
      initPage();
    }
  }

  nextBond() {
    var index = codeList.values.toList().indexOf(tempBondModel.entryBondId!);
    if (codeList.values.toList().last == codeList.values.toList()[index]) {
    } else {
      tempBondModel = GlobalModel.fromJson(allEntryBonds[codeList.values.toList()[index + 1]]?.toFullJson());
      Get.off(() => EntryBondDetailsView(oldId: tempBondModel.entryBondId));
      initPage();
      update();
    }
  }

  lastBond() {
    var index = codeList.values.toList().indexOf(tempBondModel.entryBondId!);
    if (codeList.values.toList().last == codeList.values.toList()[index]) {
    } else {
      tempBondModel = GlobalModel.fromJson(allEntryBonds[codeList.values.toList().last]?.toFullJson());
      Get.off(() => EntryBondDetailsView(oldId: tempBondModel.entryBondId));
      initPage();
      update();
    }
  }

  void changeIndexCode({required String code}) {
    var model = allEntryBonds.values.toList().firstWhereOrNull((element) => element.entryBondCode == code);
    if (model == null) {
      Get.snackbar("خطأ", "غير موجود");
    } else {
      tempBondModel = GlobalModel.fromJson(model.toFullJson());
      Get.off(() => EntryBondDetailsView(oldId: tempBondModel.entryBondId));
      update();
    }
  }

/*  initGlobalInvoiceBond(GlobalModel globalModel) async {
    allEntryBonds[globalModel.entryBondId!] = globalModel;
    allEntryBonds[globalModel.entryBondId!]?.entryBondCode=globalModel.entryBondCode;
    allEntryBonds[globalModel.entryBondId!]?.entryBondRecord = globalModel.entryBondRecord;
    allEntryBonds[globalModel.entryBondId!]?.originId = globalModel.invId;
    allEntryBonds[globalModel.entryBondId!]?.bondType = Const.globalTypeBond;
    allEntryBonds[globalModel.entryBondId!]?.bondDate= globalModel.invDate??globalModel.bondDate;
    if (*//*allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.isEmpty == true || allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.isEmpty == null*//*true) {
      allEntryBonds[globalModel.entryBondId!]?.entryBondRecord = [];
      allEntryBonds[globalModel.entryBondId!]?.bondDescription = "${getGlobalTypeFromEnum(globalModel.patternId!)} تم التوليد بشكل تلقائي";
      int bondRecId = 0;

      allEntryBonds[globalModel.entryBondId!]?.firstPay = globalModel.firstPay;
      globalModel.invRecords?.forEach((element) {
        String dse = "${getInvTypeFromEnum(globalModel.invType!)} عدد ${element.invRecQuantity} من ${getProductNameFromId(element.invRecProduct)}";
        List<InvoiceDiscountRecordModel> discountList = (globalModel.invDiscountRecord!).isEmpty ? [] : (globalModel.invDiscountRecord!).where((e) => e.discountId != null && (e.discountTotal ?? 0) > 0).toList();
        List<InvoiceDiscountRecordModel> addedList = (globalModel.invDiscountRecord!).isEmpty ? [] : (globalModel.invDiscountRecord!).where((e) => e.discountId != null && (e.addedTotal ?? 0) > 0).toList();
        double totalDiscount = discountList
            .map(
              (e) => e.isChooseDiscountTotal! ? e.discountTotal! : e.discountPercentage!,
            )
            .fold(
              0,
              (value, element) => value + element,
            );
        double totalAdded = addedList
            .map(
              (e) => e.isChooseAddedTotal! ? e.addedTotal! : e.addedPercentage!,
            )
            .fold(
              0,
              (value, element) => value + element,
            );

        if (globalModel.invType == Const.invoiceTypeSales) {
          if ((element.invRecQuantity ?? 0) > 0) {
            //  allEntryBonds[globalModel.bondId!]?.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(), (element.invRecSubTotal!*element.invRecQuantity!-((element.invRecSubTotal!*element.invRecQuantity!)*(totalDiscount==0?0:(totalDiscount/100)))+((element.invRecSubTotal!*(element.invRecGift??0))*(totalAdded==0?0:(totalAdded/100)))).abs(), 0, allEntryBonds[globalModel.bondId!]?.invPrimaryAccount,dse ));
            allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(), (element.invRecSubTotal! * element.invRecQuantity!).abs(), 0, globalModel.invPrimaryAccount, dse));
            allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(), 0, element.invRecSubTotal! * element.invRecQuantity!, globalModel.invSecondaryAccount, dse));
          }
          if ((element.invRecGift ?? 0) > 0) {
            String giftDse = "هدية عدد ${element.invRecGift} من ${getProductNameFromId(element.invRecProduct)}";
            allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(), 0, element.invRecGiftTotal ?? 0, allEntryBonds[globalModel.entryBondId!]?.invGiftAccount, giftDse));
            allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(), element.invRecGiftTotal!, 0, allEntryBonds[globalModel.entryBondId!]?.invSecGiftAccount, giftDse));
          }
          if (totalDiscount > 0 || totalAdded > 0) {
            for (var model in globalModel.invDiscountRecord!) {
              if (model.discountTotal != 0) {
                var discountDes = "الخصم المعطى ${model.isChooseDiscountTotal! ? "بقيمة ${model.discountTotal}" : "بنسبة ${model.isChooseDiscountTotal! ? model.discountTotal! : model.discountPercentage!}%"}";
                allEntryBonds[globalModel.entryBondId!]
                    ?.entryBondRecord
                    ?.add(EntryBondRecordModel((bondRecId++).toString(), 0, model.isChooseDiscountTotal! ? model.discountTotal : (element.invRecSubTotal! * element.invRecQuantity!) * (model.discountPercentage == 0 ? 1 : (model.discountPercentage! / 100)), model.accountId, discountDes));
                allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(),
                    model.isChooseDiscountTotal! ? model.discountTotal : (element.invRecSubTotal! * element.invRecQuantity!) * (model.discountPercentage == 0 ? 1 : (model.discountPercentage! / 100)), 0, allEntryBonds[globalModel.entryBondId!]?.invSecondaryAccount, discountDes));
              } else {
                var discountDes = "الإضافة المعطى ${model.isChooseAddedTotal! ? "بقيمة ${model.addedTotal}" : "بنسبة ${model.isChooseAddedTotal! ? model.addedTotal! : model.addedPercentage!}%"}";
                allEntryBonds[globalModel.entryBondId!]
                    ?.entryBondRecord
                    ?.add(EntryBondRecordModel((bondRecId++).toString(), model.isChooseAddedTotal! ? model.addedTotal : (element.invRecSubTotal! * element.invRecQuantity!) * (model.addedPercentage == 0 ? 1 : (model.addedPercentage! / 100)), 0, model.accountId, discountDes));
                allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.add(EntryBondRecordModel(
                    (bondRecId++).toString(), 0, model.isChooseAddedTotal! ? model.addedTotal : (element.invRecSubTotal! * element.invRecQuantity!) * (model.addedPercentage == 0 ? 1 : (model.addedPercentage! / 100)), allEntryBonds[globalModel.entryBondId!]?.invSecondaryAccount, discountDes));
              }
            }
          }
        } else {
          allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(), 0, element.invRecSubTotal! * element.invRecQuantity!, allEntryBonds[globalModel.entryBondId!]?.invSecondaryAccount, dse));
          allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(), element.invRecSubTotal! * element.invRecQuantity!, 0, allEntryBonds[globalModel.entryBondId!]?.invPrimaryAccount, dse));
        }
        if (element.invRecVat != 0 && element.invRecQuantity != 0) {
          if (globalModel.invType == Const.invoiceTypeSales) {
            ///(element.invRecQuantity??1) cheek this
            allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(), (element.invRecVat ?? 1) * (element.invRecQuantity ?? 1), 0, allEntryBonds[globalModel.entryBondId!]?.invVatAccount, "ضريبة $dse"));
            allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(), 0, (element.invRecVat ?? 1) * (element.invRecQuantity ?? 1), allEntryBonds[globalModel.entryBondId!]?.invSecondaryAccount, "ضريبة $dse"));
          } else {
            allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(), element.invRecVat! * element.invRecQuantity!, 0, allEntryBonds[globalModel.entryBondId!]?.invPrimaryAccount, "ضريبة $dse"));
            allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(), 0, element.invRecVat! * element.invRecQuantity!, allEntryBonds[globalModel.entryBondId!]?.invVatAccount, "ضريبة $dse"));
          }
        }
      });

      if (globalModel.firstPay != null && globalModel.firstPay! > 0) {
        if (globalModel.invPayType == Const.invPayTypeDue) {
          allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(), globalModel.firstPay, 0, ""*//*getAccountIdFromText("الصندوق")*//*, "الدفعة الاولى مبيعات ${globalModel.invCode}"));
          allEntryBonds[globalModel.entryBondId!]?.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(), 0, globalModel.firstPay, globalModel.invSecondaryAccount, "الدفعة الاولى مبيعات ${globalModel.invCode}"));
        }
      }
    }
  }*/

  initGlobalBond(GlobalModel globalModel) {
    // GlobalModel _ = GlobalModel.fromJson(globalModel.toFullJson());
    // _.entryBondRecord = _.bondRecord?.map((e) => EntryBondRecordModel(e.bondRecId, e.bondRecCreditAmount, e.bondRecDebitAmount, e.bondRecAccount, e.bondRecDescription, invId: e.invId)).toList();
    // _.bondDescription = "تم التوليد من ${getBondTypeFromEnum(globalModel.bondType!)} رقم ${globalModel.bondCode}";
    allEntryBonds[globalModel.entryBondId!] = globalModel;
  }

  initGlobalChequeBond(GlobalModel globalModel) {
    allEntryBonds[globalModel.entryBondId!]=globalModel;
    // globalModel.cheqRecords?.forEach((element) {
    //   fastAddBondAddToModel(globalModel: globalModel, record: [
    //     EntryBondRecordModel("00", double.parse(element.cheqRecAmount!), 0, globalModel.cheqType == Const.chequeTypeCatch ? element.cheqRecPrimeryAccount! : element.cheqRecSecoundryAccount!, "تم التوليد من الشيكات", invId: globalModel.cheqId),
    //     EntryBondRecordModel("01", 0, double.parse(element.cheqRecAmount!), globalModel.cheqType == Const.chequeTypeCatch ? element.cheqRecSecoundryAccount! : element.cheqRecPrimeryAccount!, "تم التوليد من الشيكات", invId: globalModel.cheqId),
    //   ]);
    // });
  }

  void fastAddBondAddToModel({required GlobalModel globalModel, required List<EntryBondRecordModel> record}) {
    tempBondModel = globalModel;
    tempBondModel.globalType = Const.globalTypeCheque;
    tempBondModel.entryBondRecord = record;
    tempBondModel.originId = globalModel.originId;
    tempBondModel.cheqId = globalModel.cheqId;
    if (globalModel.entryBondId == null) {
      tempBondModel.entryBondId = generateId(RecordType.entryBond);
    } else {
      tempBondModel.entryBondId = globalModel.entryBondId;
    }
    // tempBondModel.bondTotal = globalModel.cheqAllAmount.toString();
    // tempBondModel.bondType = Const.bondTypeInvoice;
    // var bondCode = "";
    // tempBondModel.bondDate=bondDate;
    // tempBondModel.bondDate ??= DateTime.now().toString().split(" ")[0];
    // tempBondModel.entr = "تم التوليد من " + getChequeTypefromEnum(globalModel.cheqType.toString()) + " رقم " + globalModel.cheqCode.toString();
    allEntryBonds[tempBondModel.entryBondId!] = tempBondModel;
  }

  void deleteBondById(String? bondId) {
    allEntryBonds.removeWhere((key, value) => key == bondId);
    initPage();
    update();
  }
}

int getNextEntryBondCode() {
  int _ = 0;
  EntryBondViewModel entryBondViewModel = Get.find<EntryBondViewModel>();
  if (entryBondViewModel.allEntryBonds.isNotEmpty) {
    _ = int.parse(entryBondViewModel.allEntryBonds.values.last.entryBondCode ?? "0") + 1;
  }
  return _;
}
