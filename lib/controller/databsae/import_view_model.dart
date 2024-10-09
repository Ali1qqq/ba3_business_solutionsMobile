import 'dart:io';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/controller/account/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/globle/global_view_model.dart';
import 'package:ba3_business_solutions/controller/invoice/invoice_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store/store_view_model.dart';
import 'package:ba3_business_solutions/model/patterens/Pattern_model.dart';
import 'package:ba3_business_solutions/model/bond/entry_bond_record_model.dart';
import 'package:ba3_business_solutions/model/invoice/invoice_record_model.dart';
import 'package:ba3_business_solutions/core/utils/generate_id.dart';
import 'package:ba3_business_solutions/core/utils/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/bond/bond_record_model.dart';
import '../../model/global/global_model.dart';
import '../../core/utils/hive.dart';
import '../../view/import/pages/bond_list_view.dart';
import '../../view/import/pages/entry_bond_list_view.dart';
import '../../view/import/pages/invoice_list_view.dart';
import '../../view/import/pages/preview_list_view.dart';

class ImportViewModel extends GetxController {
  // ImportViewModel(){
  //   MongoDB.productCollection.find({"a":"bb"}).listen((event) {
  //     print(event);
  //   });
  // //
  // }

  bool checkAllAccount(List<GlobalModel> bondList) {
    List<String> finalList = [];
    for (var e in bondList) {
      e.bondRecord?.forEach((element) {
        if (element.bondRecAccount == "") {
          print(element.toJson());
          finalList.add(element.bondRecAccount!);
        }
      });
    }

    if (finalList.isEmpty) {
      return true;
    } else {
      print(finalList.toString());
      Get.defaultDialog(
          middleText: finalList.length.toString() + " account is not defined",
          cancel: Column(
            children: [
              for (var i = 0; i < finalList.length; i++) Text(finalList[i]),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("ok"))
            ],
          ));
      return false;
    }
  }

  int addedBond = 0;

  Future<void> addBond(List<GlobalModel> bondList) async {
    addedBond = 0;

    await showLoadingDialog(
        total: bondList.length,
        fun: (index) async {
          GlobalModel element = bondList[index];
          await Get.find<GlobalViewModel>().addBondToFirebase(element);

          //   await bondController.fastAddBondToFirebase(
          //       entryBondId: element.entryBondId ?? "",
          //
          //       // bondId:a,
          //       oldBondCode: element.bondCode,
          //       amenCode: element.originAmenId,
          //       bondId: element.bondId,
          //       bondDes: element.bondDescription,
          //       originId: null,
          //       total: double.parse("0.00"),
          //       record: element.bondRecord!,
          //       bondDate: element.bondDate,
          //       bondType: element.bondType);
        });
  }

  Future<void> addInvoice(List<GlobalModel> invList) async {
    GlobalViewModel globalController = Get.find<GlobalViewModel>();
    // for (var element in invList) {
    //   GlobalModel _ = globalController.correctInvRecord(element);
    //   globalController.addInvoiceToFirebase(_);
    // }

    await showLoadingDialog(
        total: invList.length,
        fun: (index) async {
          GlobalModel element = invList[index];
          element.entryBondId = generateId(RecordType.entryBond);
          element.invId = generateId(RecordType.invoice);
          print("-" * 10);
          print(element.invId);
          print("-" * 10);
          GlobalModel _ = globalController.correctInvRecord(element);
          await globalController.addInvoiceToFirebase(_);
        });
  }

  void pickBondFile(separator) async {
    List row = [];
    List row2 = [];
    var indexOfDate;
    var indexOfType;
    var indexOfDetails;
    var indexOfNumber;
    var indexOfAccount;
    var indexOfCredit;
    var indexOfDebit;
    var indexOfTotal;
    var indexOfSmallDes;
    // int codeBond=0;
    // int codeBond=2304;
    // int codeBond=2350;
    // int codeBond=2412;
    // int codeBond = 2456;
    // int codeBond = 2453;
    // int codeBond = 2250;
    // int codeBond = 2251;
    // int codeBond = 2600;
    List<GlobalModel> bondList = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {} else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(separator);
      row2 = file[2].split(separator);
      file.removeAt(0);

      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }
      List<List<String>> dataList = file.map((e) => e.split(separator))
          .toList();
      row.forEach((element) {
        indexOfDate = row.indexOf("التاريخ");
        indexOfType = row.indexOf("أصل السند");
        indexOfTotal = row.indexOf("مدين");
        indexOfDetails = row.indexOf("البيان");
        indexOfNumber = row.indexOf("رقم السند");
      });

      row2.forEach((element) {
        indexOfAccount = row2.indexOf("الحساب");
        indexOfCredit = row2.indexOf("دائن");
        indexOfDebit = row2.indexOf("مدين");
        indexOfSmallDes = row2.indexOf("البيان");
      });

      List<List<String>> accountList = [];
      List<List<String>> creditList = [];
      List<List<String>> debitList = [];
      List<List<String>> smallDesList = [];
      List<String> oreginCode = [];
      List<String> dateList = [];
      List<String> codeList = [];
      List<String> typeList = [];
      List<String> totalList = [];
      List<String> desList = [];
      List<String> numberList = [];
      List<String> accountTemp = [];
      List<String> creditTemp = [];
      List<String> debitTemp = [];
      List<String> smallDesTemp = [];

      for (var element in dataList) {
        // print(element[indexOfAccount]);
        if (element[indexOfAccount] == "الحساب") {
          if (accountTemp.length != 0) {
            accountList.add(accountTemp.toList());
            creditList.add(creditTemp.toList());
            debitList.add(debitTemp.toList());
            smallDesList.add(smallDesTemp.toList());
            accountTemp.clear();
            debitTemp.clear();
            creditTemp.clear();
            smallDesTemp.clear();
          }
        } else if (element[indexOfAccount] == "") {
          dateList.add(element[0]);
          desList.add(element[indexOfDetails]);
          numberList.add(element[indexOfNumber]);
          totalList.add(element[indexOfTotal]);
          // print(element[indexOfType].split(":"));
          // if (element[indexOfType] == "" || element[indexOfType].split(":")[0].removeAllWhitespace == "يومية".removeAllWhitespace) {
          //   // codeBond++;
          // }
          print(element[indexOfType]);
          codeList.add(element[indexOfType].split(":")[1].removeAllWhitespace);
          oreginCode.add(element[indexOfNumber]);
          typeList.add(element[indexOfType].split(":")[0]);
        } else {
          accountTemp.add(
              element[indexOfAccount].replaceFirst("-", "").replaceAll(
                  element[indexOfAccount].split("-")[0], ""));
          creditTemp.add(element[indexOfCredit].toString());
          debitTemp.add(element[indexOfDebit].toString());
          smallDesTemp.add(element[indexOfSmallDes].toString());
        }
        if (dataList.indexOf(element) + 1 == dataList.length) {
          accountList.add(accountTemp.toList());
          creditList.add(creditTemp.toList());
          debitList.add(debitTemp.toList());
          smallDesList.add(smallDesTemp.toList());
          accountTemp.clear();
          debitTemp.clear();
          smallDesTemp.clear();
          creditTemp.clear();
        }
      }

      for (var i = 0; i < accountList.length; i++) {
        List<BondRecordModel> recordTemp = [];
        for (var j = 0; j < accountList[i].length; j++) {
          int pad = 2;
          if (accountList[i][j] != '') {
            if (accountList[i].length > 99) {
              pad = 3;
            }

            String name = getAccountIdFromText(
                accountList[i][j].replaceAll("-", " "));
            if (name == '') {
              print(name);
              print(accountList[i][j].replaceAll("-", ""));
              name = getAccountIdFromText(accountList[i][j]);

              print(name);
            }
            recordTemp.add(BondRecordModel(j.toString().padLeft(pad, '0'),
                double.parse(
                    creditList[i][j].replaceAll(",", "").replaceAll(";", "")),
                double.parse(
                    debitList[i][j].replaceAll(",", "").replaceAll(";", "")),
                name, smallDesList[i][j]));
          }
        }

        String type = typeList[i].removeAllWhitespace == "دفع"
            ? AppConstants.bondTypeDebit
            : typeList[i].removeAllWhitespace == "قبض"
            ? AppConstants.bondTypeCredit
            : typeList[i].removeAllWhitespace == "ق.إ".removeAllWhitespace
            ? AppConstants.bondTypeStart
            : AppConstants.bondTypeDaily;

        DateTime date = DateTime(
            int.parse(dateList[i].split("/")[2].split(" ")[0]),
            int.parse(dateList[i].split("/")[1]),
            int.parse(dateList[i].split("/")[0]));

        GlobalModel model = GlobalModel(
            globalType: AppConstants.globalTypeBond,
            bondDescription: desList[i],
            bondRecord: recordTemp.toList(),
            bondId: generateId(RecordType.bond),
            entryBondId: generateId(RecordType.entryBond),
            entryBondCode: numberList[i],
            bondDate: date.toString(),
            bondCode: codeList[i],
            entryBondRecord: recordTemp
                .map(
                  (e) => EntryBondRecordModel.fromJson(e.toJson()),
            )
                .toList(),
            originAmenId: oreginCode[i],
            bondTotal: totalList[i].replaceAll(",", ""),
            bondType: type);
        bondList.add(GlobalModel.fromJson(model.toFullJson()));
        recordTemp.clear();
      }
      print(bondList.length);
      correctDebitAndCredit(bondList);
      print(bondList.length);
    }
    print("---------" * 10);
    Get.to(() =>
        BondListView(
          bondList: bondList,
        ));
  }

  void pickStarterBondFile(separator) async {
    List row = [];
    List row2 = [];
    var indexOfDate;
    var indexOfType;
    var indexOfDetails;
    var indexOfNumber;
    var indexOfAccount;
    var indexOfCredit;
    var indexOfDebit;
    var indexOfTotal;
    var indexOfSmallDes;

    int codeBond = 0;
    List<GlobalModel> bondList = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {} else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(separator);
      row2 = file[2].split(separator);
      file.removeAt(0);

      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }
      List<List<String>> dataList = file.map((e) => e.split(separator))
          .toList();
      row.forEach((element) {
        indexOfDate = row.indexOf("التاريخ");
        indexOfType = row.indexOf("أصل السند");
        indexOfTotal = row.indexOf("مدين");
        indexOfDetails = row.indexOf("البيان");
        indexOfNumber = row.indexOf("رقم السند");
      });

      row2.forEach((element) {
        indexOfAccount = row2.indexOf("الحساب");
        indexOfCredit = row2.indexOf("دائن");
        indexOfDebit = row2.indexOf("مدين");
        indexOfSmallDes = row2.indexOf("البيان");
      });

      List<List<String>> accountList = [];
      List<List<String>> creditList = [];
      List<List<String>> debitList = [];
      List<List<String>> smallDesList = [];
      List<String> oreginCode = [];
      List<String> dateList = [];
      List<String> codeList = [];
      List<String> typeList = [];
      List<String> totalList = [];
      List<String> desList = [];
      List<String> numberList = [];
      List<String> accountTemp = [];
      List<String> creditTemp = [];
      List<String> debitTemp = [];
      List<String> smallDesTemp = [];

      for (var element in dataList) {
        // print(element[indexOfAccount]);
        if (element[indexOfAccount] == "الحساب") {
          if (accountTemp.isNotEmpty) {
            accountList.add(accountTemp.toList());
            creditList.add(creditTemp.toList());
            debitList.add(debitTemp.toList());
            smallDesList.add(smallDesTemp.toList());
            accountTemp.clear();
            debitTemp.clear();
            creditTemp.clear();
            smallDesTemp.clear();
          }
        } else if (element[indexOfAccount] == "") {
          dateList.add(element[indexOfDate]);
          desList.add(element[indexOfDetails]);
          numberList.add(element[indexOfNumber]);
          totalList.add(element[indexOfTotal]);
          print(element[indexOfType].split(":"));
          // if (element[indexOfType] == "" || element[indexOfType].split(":")[0].removeAllWhitespace == "يومية".removeAllWhitespace) {
          codeBond++;
          // }
          codeList.add(codeBond.toString());
          oreginCode.add(codeBond.toString());
          typeList.add("سند يومية");
        } else {
          accountTemp.add(
              element[indexOfAccount].replaceFirst("-", "").replaceAll(
                  element[indexOfAccount].split("-")[0], ""));
          creditTemp.add(element[indexOfCredit].toString());
          debitTemp.add(element[indexOfDebit].toString());
          smallDesTemp.add(element[indexOfSmallDes].toString());
        }
        if (dataList.indexOf(element) + 1 == dataList.length) {
          accountList.add(accountTemp.toList());
          creditList.add(creditTemp.toList());
          debitList.add(debitTemp.toList());
          smallDesList.add(smallDesTemp.toList());
          accountTemp.clear();
          debitTemp.clear();
          smallDesTemp.clear();
          creditTemp.clear();
        }
      }

      for (var i = 0; i < accountList.length; i++) {
        List<EntryBondRecordModel> recordTemp = [];
        for (var j = 0; j < accountList[i].length; j++) {
          int pad = 2;
          if (accountList[i][j] != '') {
            if (accountList[i].length > 99) {
              pad = 3;
            }
            String name = getAccountIdFromText(accountList[i][j]);

            recordTemp.add(EntryBondRecordModel(j.toString().padLeft(pad, '0'),
                double.parse(
                    creditList[i][j].replaceAll(",", "").replaceAll(";", "")),
                double.parse(
                    debitList[i][j].replaceAll(",", "").replaceAll(";", "")),
                name, smallDesList[i][j]));
          }
        }

        DateTime date = DateTime(
            int.parse(dateList[i].split("/")[2].split(" ")[0]),
            int.parse(dateList[i].split("/")[1]),
            int.parse(dateList[i].split("/")[0]));

        GlobalModel model = GlobalModel(
            bondDescription: desList[i],
            entryBondCode: "E-${codeList[i]}",
            entryBondId: generateId(RecordType.entryBond),
            bondDate: date.toString(),
            invDate: date.toString(),
            entryBondRecord: recordTemp.toList(),
            bondTotal: totalList[i].replaceAll(",", ""),
            bondType: AppConstants.globalTypeStartersBond);
        // print(model.toFullJson());
        bondList.add(GlobalModel.fromJson(model.toFullJson()));
        recordTemp.clear();
      }
      print(bondList.length);
      correctDebitAndCredit(bondList);
      print(bondList.length);
    }
    print("---------" * 10);

    Get.to(() =>
        EntryBondListView(
          bondList: bondList,
        ));
  }

  void pickStarterBondFileFree(separator) async {
    List row = [];
    List row2 = [];
    var indexOfDate;
    var indexOfType;
    var indexOfDetails;
    var indexOfNumber;
    var indexOfAccount;
    var indexOfCredit;
    var indexOfDebit;
    var indexOfTotal;
    var indexOfSmallDes;

    int codeBond = 0;
    List<GlobalModel> bondList = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {} else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(separator);
      row2 = file[2].split(separator);
      file.removeAt(0);

      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }
      List<List<String>> dataList = file.map((e) => e.split(separator))
          .toList();
      row.forEach((element) {
        indexOfDate = row.indexOf("التاريخ");
        indexOfType = row.indexOf("أصل السند");
        indexOfTotal = row.indexOf("مدين");
        indexOfDetails = row.indexOf("البيان");
        indexOfNumber = row.indexOf("رقم السند");
      });

      row2.forEach((element) {
        indexOfAccount = row2.indexOf("الحساب");
        indexOfCredit = row2.indexOf("دائن");
        indexOfDebit = row2.indexOf("مدين");
        indexOfSmallDes = row2.indexOf("البيان");
      });

      List<List<String>> accountList = [];
      List<List<String>> creditList = [];
      List<List<String>> debitList = [];
      List<List<String>> smallDesList = [];
      List<String> oreginCode = [];
      List<String> dateList = [];
      List<String> codeList = [];
      List<String> typeList = [];
      List<String> totalList = [];
      List<String> desList = [];
      List<String> numberList = [];
      List<String> accountTemp = [];
      List<String> creditTemp = [];
      List<String> debitTemp = [];
      List<String> smallDesTemp = [];

      for (var element in dataList) {
        // print(element[indexOfAccount]);
        if (element[indexOfAccount] == "الحساب") {
          if (accountTemp.isNotEmpty) {
            accountList.add(accountTemp.toList());
            creditList.add(creditTemp.toList());
            debitList.add(debitTemp.toList());
            smallDesList.add(smallDesTemp.toList());
            accountTemp.clear();
            debitTemp.clear();
            creditTemp.clear();
            smallDesTemp.clear();
          }
        } else if (element[indexOfAccount] == "") {
          dateList.add(element[indexOfDate]);
          desList.add(element[indexOfDetails]);
          numberList.add(element[indexOfNumber]);
          totalList.add(element[indexOfTotal]);
          print(element[indexOfType].split(":"));
          // if (element[indexOfType] == "" || element[indexOfType].split(":")[0].removeAllWhitespace == "يومية".removeAllWhitespace) {
          codeBond++;
          // }
          codeList.add("F-" + codeBond.toString());
          oreginCode.add("F-" + codeBond.toString());
          typeList.add("سند يومية");
        } else {
          accountTemp.add(
              element[indexOfAccount].replaceFirst("-", "").replaceAll(
                  element[indexOfAccount].split("-")[0], ""));
          creditTemp.add(element[indexOfCredit].toString());
          debitTemp.add(element[indexOfDebit].toString());
          smallDesTemp.add(element[indexOfSmallDes].toString());
        }
        if (dataList.indexOf(element) + 1 == dataList.length) {
          accountList.add(accountTemp.toList());
          creditList.add(creditTemp.toList());
          debitList.add(debitTemp.toList());
          smallDesList.add(smallDesTemp.toList());
          accountTemp.clear();
          debitTemp.clear();
          smallDesTemp.clear();
          creditTemp.clear();
        }
      }
// "F-ليفيل فون -كودات"
//       "طلبية - البرق"
      for (var i = 0; i < accountList.length; i++) {
        List<EntryBondRecordModel> recordTemp = [];
        for (var j = 0; j < accountList[i].length; j++) {
          int pad = 2;
          if (accountList[i][j] != '') {
            if (accountList[i].length > 99) {
              pad = 3;
            }
            String name = getAccountIdFromText("F-${accountList[i][j]}");
            if (name == '') {
              print("F-${accountList[i][j]}");
              print(name);
            }

            recordTemp.add(EntryBondRecordModel(j.toString().padLeft(pad, '0'),
                double.parse(
                    creditList[i][j].replaceAll(",", "").replaceAll(";", "")),
                double.parse(
                    debitList[i][j].replaceAll(",", "").replaceAll(";", "")),
                name, smallDesList[i][j]));
          }
        }

        DateTime date = DateTime(
            int.parse(dateList[i].split("/")[2].split(" ")[0]),
            int.parse(dateList[i].split("/")[1]),
            int.parse(dateList[i].split("/")[0]));

        GlobalModel model = GlobalModel(
            bondDescription: desList[i],
            entryBondCode: "E-${codeList[i]}",
            entryBondId: generateId(RecordType.entryBond),
            bondDate: date.toString(),
            invDate: date.toString(),
            entryBondRecord: recordTemp.toList(),
            bondTotal: totalList[i].replaceAll(",", ""),
            bondType: AppConstants.globalTypeStartersBond);
        // print(model.toFullJson());
        bondList.add(GlobalModel.fromJson(model.toFullJson()));
        recordTemp.clear();
      }
      print(bondList.length);
      correctDebitAndCredit(bondList);
      print(bondList.length);
    }
    print("---------" * 10);

    Get.to(() =>
        EntryBondListView(
          bondList: bondList,
        ));
  }

  void pickBondFileFree(separator) async {
    List row = [];
    List row2 = [];
    var indexOfDate;
    var indexOfType;
    var indexOfDetails;
    var indexOfNumber;
    var indexOfAccount;
    var indexOfCredit;
    var indexOfDebit;
    var indexOfTotal;
    var indexOfSmallDes;
    List<GlobalModel> bondList = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {} else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(separator);
      row2 = file[2].split(separator);
      file.removeAt(0);
      // print(row);
      // print(row.length);
      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }
      List<List<String>> dataList = file.map((e) => e.split(separator))
          .toList();
      row.forEach((element) {
        indexOfDate = row.indexOf("التاريخ");
        indexOfType = row.indexOf("أصل السند");
        indexOfTotal = row.indexOf("مدين");
        indexOfDetails = row.indexOf("البيان");
        indexOfNumber = row.indexOf("رقم السند");
      });

      row2.forEach((element) {
        indexOfAccount = row2.indexOf("الحساب");
        indexOfCredit = row2.indexOf("دائن");
        indexOfDebit = row2.indexOf("مدين");
        indexOfSmallDes = row2.indexOf("البيان");
      });

      List<List<String>> accountList = [];
      List<List<String>> creditList = [];
      List<List<String>> debitList = [];
      List<List<String>> smallDesList = [];
      List<String> dateList = [];
      // List<String> codeList = [];
      List<String> typeList = [];
      List<String> codeList = [];
      List<String> totalList = [];
      List<String> desList = [];
      List<String> numberList = [];
      List<String> accountTemp = [];
      List<String> creditTemp = [];
      List<String> debitTemp = [];
      List<String> smallDesTemp = [];
      dataList.forEach((element) {
        // print(element[indexOfAccount]);
        if (element[indexOfAccount] == "الحساب") {
          if (accountTemp.length != 0) {
            accountList.add(accountTemp.toList());
            creditList.add(creditTemp.toList());
            debitList.add(debitTemp.toList());
            smallDesList.add(smallDesTemp.toList());
            accountTemp.clear();
            debitTemp.clear();
            creditTemp.clear();
            smallDesTemp.clear();
          }
        } else if (element[indexOfAccount] == "") {
          dateList.add(element[indexOfDate]);
          desList.add(element[indexOfDetails]);
          numberList.add(element[indexOfNumber]);
          totalList.add(element[indexOfTotal]);
          codeList.add(element[indexOfType].split(":")[1].removeAllWhitespace);
          print(element[indexOfType].split(":"));
          // codeBond++;
          // codeList.add(element[indexOfType] ==""?codeBond.toString():element[indexOfType].split(":")[1]);
          typeList.add(
              element[indexOfType] == "" ? "سند يومية" : element[indexOfType]
                  .split(":")[0]);
        } else {
          accountTemp.add(
              element[indexOfAccount].replaceFirst("-", "").replaceAll(
                  element[indexOfAccount].split("-")[0], ""));
          creditTemp.add(element[indexOfCredit].toString());
          debitTemp.add(element[indexOfDebit].toString());
          smallDesTemp.add(element[indexOfSmallDes].toString());
        }
        if (dataList.indexOf(element) + 1 == dataList.length) {
          accountList.add(accountTemp.toList());
          creditList.add(creditTemp.toList());
          debitList.add(debitTemp.toList());
          smallDesList.add(smallDesTemp.toList());
          accountTemp.clear();
          debitTemp.clear();
          smallDesTemp.clear();
          creditTemp.clear();
        }
      });
      BondViewModel bondViewModel = Get.find<BondViewModel>();

      List<({String? bondCode, String? bondType})> allbond = bondViewModel
          .allBondsItem.values
          .map(
            (e) => (bondCode: e.bondCode, bondType: e.bondType),
      )
          .toList();
      for (var i = 0; i < accountList.length; i++) {
        List<BondRecordModel> recordTemp = [];
        for (var j = 0; j < accountList[i].length; j++) {
          int pad = 2;
          if (accountList[i][j] != '') {
            if (accountList[i].length > 99) {
              pad = 3;
            }
            print("---------");
            String name = getAccountIdFromText("F-" + accountList[i][j]);
            print(accountList[i][j]);
            print(name);
            if (name == "") {
              print("*" * 30);
              // print(codeList[i]);
            }
            print("---------");
            recordTemp.add(BondRecordModel(j.toString().padLeft(pad, '0'),
                double.parse(
                    creditList[i][j].replaceAll(",", "").replaceAll(";", "")),
                double.parse(
                    debitList[i][j].replaceAll(",", "").replaceAll(";", "")),
                name, smallDesList[i][j]));
          }
        }
        // print(typeList[i].removeAllWhitespace);
        // print(typeList[i].removeAllWhitespace=="دفع");
        String type = typeList[i].removeAllWhitespace == "دفع"
            ? AppConstants.bondTypeDebit
            : typeList[i].removeAllWhitespace == "قبض"
            ? AppConstants.bondTypeCredit
            : typeList[i].removeAllWhitespace == "ق.إ".removeAllWhitespace
            ? AppConstants.bondTypeStart
            : AppConstants.bondTypeDaily;
        // print(type);

        DateTime date = DateTime(
            int.parse(dateList[i].split("/")[2].split(" ")[0]),
            int.parse(dateList[i].split("/")[1]),
            int.parse(dateList[i].split("/")[0]));
/*        globalType: Const.globalTypeBond,
    bondDescription: desList[i],
    bondRecord: recordTemp.toList(),
    bondId: generateId(RecordType.bond),
    entryBondId: generateId(RecordType.entryBond),
    entryBondCode: numberList[i],
    bondDate: date.toString(),

    bondCode: codeList[i],
    entryBondRecord: recordTemp.map((e) => EntryBondRecordModel.fromJson(e.toJson()),).toList() ,
    originAmenId: oreginCode[i],
    //  originAmenId:numberList[i].replaceAll(",", "") ,
    bondTotal: totalList[i].replaceAll(",", ""),

    bondType: type);*/
        GlobalModel model = GlobalModel(
            globalType: AppConstants.globalTypeBond,
            bondDescription: desList[i],
            bondRecord: recordTemp.toList(),
            bondId: generateId(RecordType.bond),
            entryBondId: generateId(RecordType.entryBond),
            bondDate: date.toString(),
            entryBondRecord: recordTemp
                .map(
                  (e) => EntryBondRecordModel.fromJson(e.toJson()),
            )
                .toList(),
            entryBondCode: "F-${numberList[i].replaceAll(",", "")}",
            // originAmenId: int.parse(codeList[i]).toString(),
            originAmenId: numberList[i].replaceAll(",", ""),
            bondTotal: totalList[i].replaceAll(",", ""),
            // bondCode: "F-"+int.parse(codeList[i]).toString(),
            bondCode: "F-${codeList[i].replaceAll(",", "")}",
            bondType: type);
        // print(model.toFullJson());
        bondList.add(GlobalModel.fromJson(model.toFullJson()));
        recordTemp.clear();
      }
      print(bondList.length);
      correctDebitAndCredit(bondList);
      print(bondList.length);
      bondList.removeWhere((element) =>
          allbond.contains(
            (bondCode: element.bondCode, bondType: element.bondType),
          ));
      print(bondList.length);
      Get.to(() =>
          BondListView(
            bondList: bondList,
          ));
      // Get.to(() => ProductListView(
      //   productList: dataList,
      //   rows: row as List<String>,
      // ));
    }
  }

  correctDebitAndCredit(List bondList) {
    for (var index = 0; index < bondList.length; index++) {
      GlobalModel model = bondList[index];
      if (model.bondType == AppConstants.bondTypeDebit ||
          model.bondType == AppConstants.bondTypeCredit) {
        Map<String, double> allRec = {};
        for (var ji = 0; ji < (model.bondRecord ?? []).length; ji++) {
          BondRecordModel element = model.bondRecord![ji];
          if (model.bondType == AppConstants.bondTypeDebit &&
              element.bondRecCreditAmount != 0) {
            if (allRec[element.bondRecAccount!] == null)
              allRec[element.bondRecAccount!] = 0;
            allRec[element.bondRecAccount!] =
                allRec[element.bondRecAccount]! + element.bondRecCreditAmount!;
          } else if (model.bondType == AppConstants.bondTypeCredit &&
              element.bondRecDebitAmount != 0) {
            if (allRec[element.bondRecAccount!] == null)
              allRec[element.bondRecAccount!] = 0;
            allRec[element.bondRecAccount!] =
                allRec[element.bondRecAccount]! + element.bondRecDebitAmount!;
          }
        }
        if (model.bondType == AppConstants.bondTypeCredit) {
          model.bondRecord?.removeWhere((e) => e.bondRecDebitAmount != 0);
          model.bondRecord?.add(BondRecordModel(
              "X", 0, allRec.entries.first.value, allRec.entries.first.key,
              ""));
        } else {
          model.bondRecord?.removeWhere((e) => e.bondRecCreditAmount != 0);
          model.bondRecord?.add(BondRecordModel(
              "X", allRec.entries.first.value, 0, allRec.entries.first.key,
              ""));
        }
      }
    }
  }

  Future<void> pickInvoiceFileFree(separator) async {
    // BondViewModel bondViewModel = Get.find<BondViewModel>();
    List row = [];
    // List row2 = [];
    // var indexOfInvType;
    // var indexOfPrimery;
    var indexOfSecoundry;
    var indexOfInvCode;
    var indexOfTotalWithVat;
    var indexOfTotalDiscount;
    var indexOfTotalAdded;
    var indexOfFirstPay;
    //var indexOfTotalVat;
    // int indexOfTotalWithoutVat;
    var indexOfSubTotal;
    var indexOfQuantity;
    var indexOfProductName;
    var indexOfDate;
    var indexOfStore;
    var indexOfSeller;
    var indexOfPayType;
    var indexOfGift;
    // List<GlobalModel> bondList = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {} else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(separator);

      file.removeAt(0);
      // print(row);
      // print(row.length);
      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }

      List<List<String>> dataList = file.map((e) => e.split(separator))
          .toList();
      row.forEach((element) {
        indexOfDate = row.indexOf("التاريخ");
        indexOfPayType = row.indexOf("طريقة الدفع");
        // indexOfInvType = row.indexOf("نوع الفاتورة");
        // indexOfPrimery = row.indexOf("اسم الزبون"); // BAD
        indexOfSecoundry = row.indexOf("حساب العميل في الفاتورة");
        indexOfInvCode = row.indexOf("الفاتورة");
        indexOfTotalWithVat = row.indexOf("صافي القيمة");
        //indexOfTotalVat = row.indexOf("القيمة المضافة");
        indexOfTotalDiscount = row.indexOf("مجموع الحسم");
        indexOfTotalAdded = row.indexOf("مجموع الإضافات");
        indexOfFirstPay = row.indexOf("الدفعة الأولى");
        // indexOfTotalWithoutVat = row.indexOf("القيمة");
        indexOfSubTotal = row.indexOf("السعر");
        indexOfQuantity = row.indexOf("الكمية");
        indexOfProductName = row.indexOf("اسم المادة");
        indexOfStore = row.indexOf("المستودع");
        indexOfSeller = row.indexOf("مركز الكلفة");
        indexOfGift = row.indexOf("الهدايا");
      });

      //  List<String> dateList=[];
      Map<String, GlobalModel> invMap = {};
      Map<String, ({String? strart, String? end})> allChanges = {};
      List notFoundAccount = [];
      List notFoundProduct = [];
      List notFoundStore = [];
      List notFoundSeller = [];

      for (var element in dataList) {
        var store = getStoreIdFromText("SHOP");
        // var store = element[indexOfStore];
        // if (store == '' && !notFoundStore.contains(element[indexOfStore])) {
        //   notFoundStore.add(element[indexOfStore]);
        // }
        var seller = '';
        if (element[indexOfSeller] != "") {
          seller = getSellerIdFromText(element[indexOfSeller]) ?? '';
          if (seller == '' &&
              !notFoundSeller.contains(element[indexOfSeller])) {
            notFoundSeller.add(element[indexOfSeller]);
          }
        }
        late PatternModel patternModel;

        print(element[indexOfInvCode]);

        List _ = element[indexOfInvCode].toString().replaceAll(" ", "").split(
            ":");
        if (_[0] == "إخ.م" || _[0] == "إد.م") {
          if (allChanges[_[1]] == null) {
            allChanges[_[1]] = _[0] == "إخ.م"
                ? (strart: store, end: null)
                : (end: store, strart: null);
            continue;
          } else {
            allChanges[_[1]] = _[0] == "إخ.م"
                ? (end: allChanges[_[1]]!.end, strart: store)
                : (strart: allChanges[_[1]]!.strart, end: store);
          }
          patternModel = (Get
              .find<PatternViewModel>()
              .patternModel
              .values
              .firstWhere((e) => e.patType == AppConstants.invoiceTypeChange));
        } else {
          if (element[indexOfInvCode].toString().split(":")[0].replaceAll(
              " ", "") == "تا") {
            patternModel = (Get
                .find<PatternViewModel>()
                .patternModel
                .values
                .firstWhere((e) => e.patName! == "ت ادخال"));
          } else {
            patternModel = (Get
                .find<PatternViewModel>()
                .patternModel
                .values
                .firstWhere((e) =>
            e.patName?.replaceAll(" ", "") ==
                element[indexOfInvCode].toString().split(":")[0].replaceAll(
                    " ", "")));
          }
        }
        bool isAdd = (patternModel.patType == AppConstants.invoiceTypeAdd);
        var primery;
        var secoundry;

        // if( element[indexOfInvCode].toString().split(":")[0].replaceAll(" ", "") == "ت ادخال".replaceAll(" ", "") ||element[indexOfInvCode].toString().split(":")[0].replaceAll(" ", "") == 'ت خ'.replaceAll(" ", "") ){
        //   secoundry = patternModel.patSecondary;
        // }else{
        // //  primery = isAdd?'':getAccountIdFromText(element[indexOfPrimery]);
        //   secoundry=  isAdd?'':getAccountIdFromText(element[indexOfSecoundry]);
        // }
        // if (primery == '' && !notFoundAccount.contains(element[indexOfPrimery])&&!isAdd) {
        //   print("primery: |"+element[indexOfPrimery]);
        //   notFoundAccount.add(element[indexOfPrimery]);
        // }
        if (patternModel.patType == AppConstants.invoiceTypeSales) {
          // primery = patternModel.patPrimary;
          primery = getAccountIdFromText(
              "F-" + getAccountModelFromId(patternModel.patPrimary)!.accName!);
          secoundry = getAccountIdFromText("F-" + element[indexOfSecoundry]);
        } else if (patternModel.patType == AppConstants.invoiceTypeBuy) {
          primery = getAccountIdFromText("F-" + element[indexOfSecoundry]);
          // secoundry = patternModel.patSecondary;
          secoundry = getAccountIdFromText("F-" +
              getAccountModelFromId(patternModel.patSecondary)!.accName!);
        }

        if (secoundry == '' &&
            !notFoundAccount.contains(element[indexOfSecoundry]) && !isAdd) {
          print("secoundry: |" + element[indexOfSecoundry] + "| From " +
              element[indexOfInvCode]);
          notFoundAccount.add(element[indexOfSecoundry]);
          return;
        }
        var product = getProductIdFromName("F-" + element[indexOfProductName]);
        if (product == '' &&
            !notFoundProduct.contains("F-" + element[indexOfProductName])) {
          print("product: |" + "F-" + element[indexOfProductName] + "| From " +
              element[indexOfInvCode]);
          notFoundProduct.add("F-" + element[indexOfProductName]);
        }
        // if(primery ==""||primery ==null||secoundry ==null||secoundry == ""){
        //   print("------------------");
        //   print(primery.toString()+"|"+secoundry.toString()+"|"+element[indexOfInvCode]);
        //   print("------------------");
        // }
        if (patternModel.patType == AppConstants.invoiceTypeChange) {
          print("-----------");
          print(allChanges[_[1]]);
          print("-----------");
        }
        //print(element[indexOfInvCode]);
        if (invMap[element[indexOfInvCode]] == null) {
          // var invId = generateId(RecordType.invoice);
          DateTime date = DateTime(
              int.parse(element[indexOfDate].split("-")[2]),
              int.parse(element[indexOfDate].split("-")[1]),
              int.parse(element[indexOfDate].split("-")[0]));
          invMap[element[indexOfInvCode]] = GlobalModel(
            //  invId: invId,
              bondId: generateId(RecordType.bond),
              // originId: invId,
              originAmenId: element[indexOfInvCode].toString().split(":")[1]
                  .replaceAll(" ", ""),
              bondType: AppConstants.bondTypeInvoice,
              invIsPending: false,
              invPayType: element[indexOfPayType].removeAllWhitespace ==
                  "نقداً".removeAllWhitespace
                  ? AppConstants.invPayTypeCash
                  : AppConstants.invPayTypeDue,
              //  bondCode: getNextBondCode(),
              discountTotal: double.parse(
                  element[indexOfTotalDiscount].replaceAll("\"", "").replaceAll(
                      ",", "").replaceAll("٫", ".")),
              firstPay: double.parse(
                  element[indexOfFirstPay].replaceAll("\"", "").replaceAll(
                      ",", "").replaceAll("٫", ".")),
              addedTotal: double.parse(
                  element[indexOfTotalAdded].replaceAll("\"", "").replaceAll(
                      ",", "").replaceAll("٫", ".")),
              invComment: "",
              bondCode: "0",
              invMobileNumber: "",
              patternId: patternModel.patId,
              invSeller: seller,
              globalType: AppConstants.globalTypeInvoice,
              invPrimaryAccount: primery,
              invSecondaryAccount: secoundry,
              invStorehouse: patternModel.patType !=
                  AppConstants.invoiceTypeChange ? store : allChanges[_[1]]!
                  .strart,
              invSecStorehouse: allChanges[_[1]]?.end,
              invDate: date.toString().split(".")[0],
              invCustomerAccount: element[indexOfSecoundry],
              bondDate: date.toString().split(".")[0],
              invVatAccount: patternModel.patType == AppConstants.invoiceTypeBuy
                  ? AppConstants.returnVatAccountId
                  : AppConstants.vatAccountId,
              invDiscountRecord: [],
              invTotal: double.parse(
                  element[indexOfTotalWithVat].replaceAll("\"", "").replaceAll(
                      ",", "").replaceAll("٫", ".")).abs(),
              // invType:  element[indexOfInvCode].toString().split(":")[0].replaceAll(" ", "")=="مبيع"?Const.invoiceTypeSales:Const.invoiceTypeBuy,
              invType: patternModel.patType,
              invCode: "F-" +
                  element[indexOfInvCode].toString().split(":")[1].replaceAll(
                      " ", ""),
              invRecords: [
                InvoiceRecordModel(
                  prodChoosePriceMethod: AppConstants
                      .invoiceChoosePriceMethodeCustom,
                  invRecId: "1",
                  invRecQuantity: double.parse(
                      element[indexOfQuantity].toString()
                          .replaceAll("\"", "")
                          .replaceAll(",", "")).toInt().abs() + double.parse(
                      element[indexOfGift].toString()
                          .replaceAll("\"", "")
                          .replaceAll(",", "")).toInt().abs(),
                  invRecProduct: getProductsModelFromName(
                      "F-" + element[indexOfProductName])!.first.prodId,
                  //product id
                  invRecSubTotal: double.parse(
                      element[indexOfQuantity].toString()
                          .replaceAll("\"", "")
                          .replaceAll(",", "")).toInt() == 0 ? 0 : double.parse(
                      element[indexOfSubTotal].toString().replaceAll("\"", "")
                          .replaceAll(",", "")
                          .replaceAll("٫", ".")).abs(),
                  invRecIsLocal: getProductsModelFromName(
                      "F-" + element[indexOfProductName])!.first.prodIsLocal,
                  invRecTotal: double.parse(
                      element[indexOfTotalWithVat].toString().replaceAll(
                          "\"", "").replaceAll(",", "").replaceAll("٫", "."))
                      .abs(),

                  // invRecVat: double.parse(element[indexOfTotalWithVat].toString().replaceAll(",", "").replaceAll("٫", ".")).abs()/double.parse(element[indexOfQuantity].toString().replaceAll(",", "")).toInt().abs() - double.parse(element[indexOfSubTotal].toString().replaceAll(",", "").replaceAll("٫", ".")).abs(),
                  invRecVat: 0,
                )
              ]);
        } else {
          var lastCode = int.parse(
              invMap[element[indexOfInvCode]]!.invRecords!.last.invRecId!) + 1;
          invMap[element[indexOfInvCode]]?.invTotal = double.parse(
              element[indexOfTotalWithVat].toString().replaceAll("\"", "")
                  .replaceAll(",", "")
                  .replaceAll("٫", ".")).abs() +
              invMap[element[indexOfInvCode]]!.invTotal!;
          invMap[element[indexOfInvCode]]?.invRecords?.add(InvoiceRecordModel(
            prodChoosePriceMethod: AppConstants.invoiceChoosePriceMethodeCustom,
            invRecId: lastCode.toString(),
            invRecQuantity: double.parse(element[indexOfQuantity].toString()
                .replaceAll(",", "")
                .replaceAll("\"", "")).toInt().abs() + double.parse(
                element[indexOfGift].toString().replaceAll("\"", "").replaceAll(
                    ",", "")).toInt().abs(),
            invRecProduct: getProductsModelFromName(
                "F-" + element[indexOfProductName])!.first.prodId,
            invRecIsLocal: getProductsModelFromName(
                "F-" + element[indexOfProductName])!.first.prodIsLocal,
            invRecSubTotal: double.parse(element[indexOfQuantity].toString()
                .replaceAll(",", "")
                .replaceAll("\"", "")).toInt() == 0 ? 0 : double.parse(
                element[indexOfSubTotal].toString().replaceAll("\"", "")
                    .replaceAll(",", "")
                    .replaceAll("٫", ".")).abs(),
            invRecTotal: double.parse(
                element[indexOfTotalWithVat].toString().replaceAll(",", "")
                    .replaceAll("\"", "")
                    .replaceAll("٫", ".")).abs(),
            // invRecVat: double.parse(element[indexOfTotalWithVat].toString().replaceAll(",", "").replaceAll("٫", ".")).abs()/double.parse(element[indexOfQuantity].toString().replaceAll(",", "")).toInt().abs() - double.parse(element[indexOfSubTotal].toString().replaceAll(",", "").replaceAll("٫", ".")).abs(),
            invRecVat: 0,
          ));
        }
        //  dateList.add(element[indexOfDate]);
      }

      if (notFoundProduct.isNotEmpty || notFoundStore.isNotEmpty ||
          notFoundAccount.isNotEmpty || notFoundSeller.isNotEmpty) {
        print(notFoundProduct);
        print(notFoundStore);
        print(notFoundAccount);
        print(notFoundSeller);
        print("notFoundProduct: " + notFoundProduct.length.toString());
        print("notFoundStore: " + notFoundStore.length.toString());
        print("notFoundAccount: " + notFoundAccount.length.toString());

        Get.defaultDialog(
            title: "بعض الحسابات غير موجودة",
            content: SizedBox(
              height: MediaQuery
                  .sizeOf(Get.context!)
                  .height - 150,
              width: MediaQuery
                  .sizeOf(Get.context!)
                  .width / 2,
              child: ListView(
                shrinkWrap: true,
                children: [
                  if (notFoundAccount.isNotEmpty) const Center(
                      child: Text("الحسابات")),
                  for (var e in notFoundAccount) Text(e),
                  const SizedBox(
                    height: 30,
                  ),
                  if (notFoundStore.isNotEmpty) const Center(
                      child: Text("المستودعات")),
                  for (var e in notFoundStore) Text(e),
                  const SizedBox(
                    height: 30,
                  ),
                  if (notFoundSeller.isNotEmpty) const Center(
                      child: Text("البائعون")),
                  for (var e in notFoundSeller) Text(e),
                  const SizedBox(
                    height: 30,
                  ),
                  if (notFoundProduct.isNotEmpty) const Center(
                      child: Text("المواد")),
                  for (var e in notFoundProduct) Text(e),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ));
        // return;
      }

      // invMap.removeWhere((key, value) => allInvoice.contains((invCode:value.invCode,invType:value.invType)),);

      int bondCode = 20565;
      for (var i = 0; i < invMap.length; i++) {
        invMap.entries.toList()[i].value.bondCode = "G-$bondCode";
        bondCode++;
      }
      Get.to(() =>
          InvoiceListView(
            invoiceList: invMap.values.toList(),
          ));

      // print(notFoundProduct);
      // print(notFoundStore);
      // print(notFoundAccount);
      // print(invMap.map((key, value) => MapEntry(key, value.toFullJson())));

      // print(dateList);
      // for(var i =0;i<accountList.length;i++){
      //   List<BondRecordModel> recordTemp=[];
      //   for(var j =0;j<accountList[i].length;j++){
      //     if(accountList[i][j]!=''){
      //       recordTemp.add(BondRecordModel(j.toString().padLeft(2, '0'), double.parse(creditList[i][j]), double.parse(debitList[i][j]), getAccountIdFromText(accountList[i][j]), ''));
      //     }
      //   }
      //   GlobalModel model = GlobalModel(bondRecord: recordTemp.toList(),bondId: generateId(RecordType.bond),bondDate:dateList[i] ,bondTotal: totalList[i],bondCode: int.parse(codeList[i]).toString(),bondDescription: "",bondType: Const.bondTypeDaily);
      //   // print(model.toFullJson());
      //   bondList.add(GlobalModel.fromJson(model.toFullJson()));
      //   recordTemp.clear();
      // }
      // print(bondList.map((e) => e.toFullJson()));
      // Get.to(()=>BondListView(
      //   bondList: bondList,
      // ));
      // Get.to(() => ProductListView(
      //   productList: dataList,
      //   rows: row as List<String>,
      // ));
    }
  }

  // WIRED MONO HEADSET WITH LIGHTNING CONNECTOR
  Future<void> pickInvoiceFile(separator) async {
    try {
      {
        if (false) {
          HiveDataBase.globalModelBox.deleteFromDisk();
        } else {
          // BondViewModel bondViewModel = Get.find<BondViewModel>();
          List row = [];
          // List row2 = [];
          // var indexOfInvType;
          // var indexOfPrimery;
          var indexOfSecoundry;
          var indexOfInvCode;
          var indexOfTotalWithVat;
          var indexOfTotalDiscount;
          var indexOfTotalAdded;

          // int indexOfTotalWithoutVat;
          var indexOfFirstPay;
          var indexOfSubTotal;
          var indexOfQuantity;
          var indexOfProductName;
          var indexOfDate;
          var indexOfStore;
          var indexOfSeller;
          var indexOfPayType;
          var indexOfComment;
          var indexOfGift;

          List nunProd = [];
          debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
          var result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['csv', "tsv"],
          );
          if (result == null) {} else {
            File _ = File(result.files.single.path!);
            List<String> file = await _.readAsLines();
            row = file[0].split(separator);

            file.removeAt(0);
            // print(row);
            // print(row.length);
            if (row.length == 1) {
              Get.snackbar("error", "plz check if the file separeted ");
              return;
            }

            List<List<String>> dataList = file.map((e) => e.split(separator))
                .toList();
            row.forEach((element) {
              indexOfDate = row.indexOf("التاريخ"); //1
              indexOfInvCode = row.indexOf("الفاتورة"); //2
              indexOfProductName = row.indexOf("اسم المادة"); //3
              indexOfQuantity = row.indexOf("الكمية"); //4
              indexOfGift = row.indexOf("الهدايا"); //5
              indexOfSubTotal = row.indexOf("السعر"); //6
              indexOfTotalDiscount = row.indexOf("مجموع الحسم"); //7
              indexOfTotalAdded = row.indexOf("مجموع الإضافات"); //8
              indexOfTotalWithVat = row.indexOf("صافي القيمة بعد الضريبة"); //9
              indexOfSecoundry = row.indexOf("حساب العميل في الفاتورة"); //10
              indexOfPayType = row.indexOf("طريقة الدفع"); //11
              indexOfSeller = row.indexOf("مركز الكلفة"); //12
              indexOfStore = row.indexOf("المستودع"); //13
              indexOfFirstPay = row.indexOf("الدفعة الأولى"); //14
              indexOfComment = row.indexOf("البيان"); //15
              // indexOfInvType = row.indexOf("نوع الفاتورة");
              // indexOfPrimary = row.indexOf("اسم الزبون"); // BAD
              //indexOfTotalVat = row.indexOf("القيمة المضافة");
              // indexOfTotalWithoutVat = row.indexOf("القيمة");
            });

            //  List<String> dateList=[];
            Map<String, GlobalModel> invMap = {};
            Map<String, ({String? strart, String? end})> allChanges = {};
            List notFoundAccount = [];
            List notFoundProduct = [];
            List notFoundStore = [];
            List notFoundSeller = [];
            InvoiceViewModel invoiceViewModel = Get.find<InvoiceViewModel>();
            List<
                ({String? invCode, String? invType})> allInvoice = invoiceViewModel
                .invoiceModel.values
                .map(
                  (e) => (invCode: e.invCode, invType: e.invType),
            )
                .toList();
            for (var element in dataList) {
              var store = getStoreIdFromText(element[indexOfStore]);
              // var store = element[indexOfStore];
              if (store == '' &&
                  !notFoundStore.contains(element[indexOfStore])) {
                notFoundStore.add(element[indexOfStore]);
              }
              var seller = '';
              if (element[indexOfSeller] != "") {
                seller = getSellerIdFromText(element[indexOfSeller]) ?? '';
                if (seller == '' &&
                    !notFoundSeller.contains(element[indexOfSeller])) {
                  notFoundSeller.add(element[indexOfSeller]);
                }
              }
              late PatternModel patternModel;
              print(element[indexOfInvCode]);
              //  print(element[indexOfInvCode]);
              List _ = element[indexOfInvCode].toString()
                  .replaceAll(" ", "")
                  .split(":");
              if (_[0] == "إخ.م" || _[0] == "إد.م") {
                print(_[0]);
                if (allChanges[_[1]] == null) {
                  allChanges[_[1]] = _[0] == "إخ.م"
                      ? (strart: store, end: null)
                      : (end: store, strart: null);
                  continue;
                } else {
                  allChanges[_[1]] = _[0] == "إخ.م"
                      ? (end: allChanges[_[1]]!.end, strart: store)
                      : (strart: allChanges[_[1]]!.strart, end: store);
                }
                patternModel = (Get
                    .find<PatternViewModel>()
                    .patternModel
                    .values
                    .firstWhere((e) =>
                e.patType == AppConstants.invoiceTypeChange));
              } else {
                patternModel = (Get
                    .find<PatternViewModel>()
                    .patternModel
                    .values
                    .firstWhere((e) =>
                e.patName?.replaceAll(" ", "") ==
                    element[indexOfInvCode].toString().split(":")[0].replaceAll(
                        " ", "")));
              }
              bool isAdd = (patternModel.patType ==
                  AppConstants.invoiceTypeAdd);
              var primery;
              var secoundry;

              if (patternModel.patType == AppConstants.invoiceTypeSales) {
                primery = getAccountIdFromText(
                    getAccountModelFromId(patternModel.patPrimary)!.accName!);
                secoundry = getAccountIdFromText(element[indexOfSecoundry]);
              } else if (patternModel.patType == AppConstants.invoiceTypeBuy) {
                primery = getAccountIdFromText(element[indexOfSecoundry]);

                secoundry = getAccountIdFromText(
                    getAccountModelFromId(patternModel.patSecondary)!.accName!);
              }

              if (secoundry == '' &&
                  !notFoundAccount.contains(element[indexOfSecoundry]) &&
                  !isAdd) {
                print(
                    "secoundry: |${element[indexOfSecoundry]}| From ${element[indexOfInvCode]}");
                notFoundAccount.add(element[indexOfSecoundry]);
              }
              var product = getProductIdFromName(element[indexOfProductName]);
              if (product == '' &&
                  !notFoundProduct.contains(element[indexOfProductName])) {
                print(
                    "product: |${element[indexOfProductName]}| From ${element[indexOfInvCode]}");
                notFoundProduct.add(element[indexOfProductName]);
              }

              if (patternModel.patType == AppConstants.invoiceTypeChange) {
                print("-----------");
                print(allChanges[_[1]]);
                print("-----------");
              }
              //print(element[indexOfInvCode]);
              if (invMap[element[indexOfInvCode]] == null) {
                //todo

                if (getProductsModelFromName(element[indexOfProductName])
                    ?.firstOrNull?.prodIsLocal == null) {
                  nunProd.add(element[indexOfProductName]);
                  print(element[indexOfProductName]);
                  Get.snackbar("error", "plz check if the file separeted ");
                  return;
                }
                // var invId = generateId(RecordType.invoice);
                else {
                  DateTime date = DateTime(
                      int.parse(element[indexOfDate].split("-")[2]),
                      int.parse(element[indexOfDate].split("-")[1]),
                      int.parse(element[indexOfDate].split("-")[0]));
                  invMap[element[indexOfInvCode]] = GlobalModel(
                      invId: generateId(RecordType.invoice),
                      entryBondId: generateId(RecordType.entryBond),

                      // invReturnCode: ,
                      originAmenId: element[indexOfInvCode].toString().split(
                          ":")[1].replaceAll(" ", ""),
                      // bondType: Const.bondTypeInvoice,
                      invIsPending: false,
                      invPayType: element[indexOfPayType].removeAllWhitespace ==
                          "نقداً".removeAllWhitespace ? AppConstants
                          .invPayTypeCash : AppConstants.invPayTypeDue,
                      invComment: element[indexOfComment],
                      discountTotal: double.parse(
                          element[indexOfTotalDiscount].replaceAll("\"", "")
                              .replaceAll(",", "")
                              .replaceAll("٫", ".")),
                      firstPay: double.parse(
                          element[indexOfFirstPay].replaceAll("\"", "")
                              .replaceAll(",", "")
                              .replaceAll("٫", ".")),
                      addedTotal: double.parse(
                          element[indexOfTotalAdded].replaceAll("\"", "")
                              .replaceAll(",", "")
                              .replaceAll("٫", ".")),
                      invFullCode: element[indexOfInvCode],
                      invGiftAccount: patternModel.patGiftAccount,
                      invSecGiftAccount: patternModel.patSecGiftAccount,
                      entryBondCode: "0",
                      invMobileNumber: "",
                      patternId: patternModel.patId,
                      invSeller: seller,
                      globalType: AppConstants.globalTypeInvoice,
                      invPrimaryAccount: primery,
                      invSecondaryAccount: secoundry,
                      invStorehouse: patternModel.patType !=
                          AppConstants.invoiceTypeChange
                          ? store
                          : allChanges[_[1]]!.strart,
                      invSecStorehouse: allChanges[_[1]]?.end,
                      invDate: date.toString().split(".")[0],
                      invCustomerAccount: element[indexOfSecoundry],
                      // bondDate: date.toString().split(".")[0],
                      invVatAccount: patternModel.patType ==
                          AppConstants.invoiceTypeBuy ? AppConstants
                          .returnVatAccountId : AppConstants.vatAccountId,
                      invDiscountRecord: [],

                      invTotal: double.parse(
                          element[indexOfTotalWithVat].replaceAll("\"", "")
                              .replaceAll(",", "")
                              .replaceAll("٫", ".")).abs(),
                      invType: patternModel.patType,
                      invCode: element[indexOfInvCode].toString().split(":")[1]
                          .replaceAll(" ", ""),
                      invRecords: [
                        InvoiceRecordModel(
                          invRecGiftTotal: double.parse(
                              element[indexOfGift].toString().replaceAll(
                                  "\"", "").replaceAll(",", "")).abs() *
                              double.parse(element[indexOfQuantity].toString()
                                  .replaceAll("\"", "")
                                  .replaceAll(",", "")),
                          prodChoosePriceMethod: AppConstants
                              .invoiceChoosePriceMethodeCustom,
                          invRecId: "1",
                          invRecQuantity: double.parse(element[indexOfQuantity]
                              .toString().replaceAll("\"", "")
                              .replaceAll(",", "")).toInt().abs(),
                          invRecProduct: product,
                          //product id
                          invRecGift: double.parse(element[indexOfGift]
                              .toString().replaceAll("\"", "")
                              .replaceAll(",", "")).toInt().abs(),
                          invRecSubTotal: double.parse(element[indexOfQuantity]
                              .toString().replaceAll("\"", "")
                              .replaceAll(",", "")).toInt() == 0 ? 0 : double
                              .parse(element[indexOfSubTotal].toString()
                              .replaceAll("\"", "").replaceAll(",", "")
                              .replaceAll("٫", ".")).abs(),
                          invRecIsLocal: getProductsModelFromName(
                              element[indexOfProductName])!.first.prodIsLocal,
                          invRecTotal: double.parse(element[indexOfTotalWithVat]
                              .toString().replaceAll("\"", "").replaceAll(
                              ",", "")
                              .replaceAll("٫", ".")).abs(),
                          invRecVat: element[indexOfQuantity].toString() ==
                              "0.00"
                              ? 0
                              : double.parse(element[indexOfTotalWithVat]
                              .toString().replaceAll(",", "")
                              .replaceAll("٫", ".")).abs() /
                              double.parse(element[indexOfQuantity]
                                  .toString()
                                  .replaceAll(",", "")).toInt().abs() -
                              double.parse(element[indexOfSubTotal]
                                  .toString()
                                  .replaceAll(",", "")
                                  .replaceAll("٫", ".")).abs(),
                          //invRecVat: 0,
                        )
                      ]);
                }
              } else {
                if (getProductsModelFromName(element[indexOfProductName])
                    ?.firstOrNull?.prodIsLocal == null) {
                  nunProd.add(element[indexOfProductName]);
                  print(element[indexOfProductName]);
                } else {
                  var lastCode = int.parse(
                      invMap[element[indexOfInvCode]]!.invRecords!.last
                          .invRecId!) + 1;
                  invMap[element[indexOfInvCode]]?.invTotal = double.parse(
                      element[indexOfTotalWithVat].toString().replaceAll(
                          "\"", "").replaceAll(",", "").replaceAll("٫", "."))
                      .abs() + invMap[element[indexOfInvCode]]!.invTotal!;
                  invMap[element[indexOfInvCode]]?.invRecords?.add(
                      InvoiceRecordModel(
                        prodChoosePriceMethod: AppConstants
                            .invoiceChoosePriceMethodeCustom,
                        invRecGiftTotal: double.parse(
                            element[indexOfGift].toString()
                                .replaceAll("\"", "")
                                .replaceAll(",", "")).abs() * double.parse(
                            element[indexOfQuantity].toString().replaceAll(
                                "\"", "").replaceAll(",", "")),
                        invRecId: lastCode.toString(),
                        invRecQuantity: double.parse(
                            element[indexOfQuantity].toString().replaceAll(
                                ",", "").replaceAll("\"", "")).toInt().abs() +
                            double.parse(
                                element[indexOfGift].toString().replaceAll(
                                    "\"", "").replaceAll(",", ""))
                                .toInt()
                                .abs(),
                        invRecProduct: getProductIdFromName(
                            element[indexOfProductName]),
                        invRecIsLocal: getProductsModelFromName(
                            element[indexOfProductName])!.first.prodIsLocal,
                        invRecSubTotal: double.parse(
                            element[indexOfQuantity].toString().replaceAll(
                                ",", "").replaceAll("\"", "")).toInt() == 0
                            ? 0
                            : double.parse(
                            element[indexOfSubTotal].toString().replaceAll(
                                "\"", "").replaceAll(",", "").replaceAll(
                                "٫", ".")).abs(),
                        invRecTotal: double.parse(
                            element[indexOfTotalWithVat].toString().replaceAll(
                                ",", "").replaceAll("\"", "").replaceAll(
                                "٫", ".")).abs(),
                        invRecVat: element[indexOfQuantity].toString() == "0.00"
                            ? 0
                            : double.parse(
                            element[indexOfTotalWithVat].toString().replaceAll(
                                ",", "").replaceAll("٫", ".")).abs() /
                            double.parse(
                                element[indexOfQuantity].toString().replaceAll(
                                    ",", "")).toInt().abs() -
                            double.parse(
                                element[indexOfSubTotal].toString().replaceAll(
                                    ",", "").replaceAll("٫", ".")).abs(),
                        // invRecVat: 0,
                      ));
                }
              }
              //  dateList.add(element[indexOfDate]);
            }

            if (notFoundProduct.isNotEmpty || notFoundStore.isNotEmpty ||
                notFoundAccount.isNotEmpty || notFoundSeller.isNotEmpty) {
              {
                print(nunProd.length);
                print(nunProd);
                print(notFoundStore);
                print(notFoundAccount);
                print(notFoundSeller);
                Get.defaultDialog(
                    title: "بعض الحسابات غير موجودة",
                    content: SizedBox(
                      height: MediaQuery
                          .sizeOf(Get.context!)
                          .height - 150,
                      width: MediaQuery
                          .sizeOf(Get.context!)
                          .width / 2,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          if (notFoundAccount.isNotEmpty) const Center(
                              child: Text("الحسابات")),
                          for (var e in notFoundAccount) Text(e),
                          const SizedBox(
                            height: 30,
                          ),
                          if (notFoundStore.isNotEmpty) const Center(
                              child: Text("المستودعات")),
                          for (var e in notFoundStore) Text(e),
                          const SizedBox(
                            height: 30,
                          ),
                          if (notFoundSeller.isNotEmpty) const Center(
                              child: Text("البائعون")),
                          for (var e in notFoundSeller) Text(e),
                          const SizedBox(
                            height: 30,
                          ),
                          if (notFoundProduct.isNotEmpty) const Center(
                              child: Text("المواد")),
                          for (var e in notFoundProduct) Text(e),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ));
              }
              return;
            }

            invMap.removeWhere(
                  (key, value) =>
                  allInvoice.contains(
                      (invCode: value.invCode, invType: value.invType)),
            );

            int bondCode = 0;
            for (var i = 0; i < invMap.length; i++) {
              invMap.entries.toList()[i].value.bondCode = bondCode.toString();
              bondCode++;
            }

            Get.to(() =>
                InvoiceListView(
                  invoiceList: invMap.values.toList(),
                ));

            // print(notFoundProduct);
            // print(notFoundStore);
            // print(notFoundAccount);
            // print(invMap.map((key, value) => MapEntry(key, value.toFullJson())));

            // print(dateList);
            // for(var i =0;i<accountList.length;i++){
            //   List<BondRecordModel> recordTemp=[];
            //   for(var j =0;j<accountList[i].length;j++){
            //     if(accountList[i][j]!=''){
            //       recordTemp.add(BondRecordModel(j.toString().padLeft(2, '0'), double.parse(creditList[i][j]), double.parse(debitList[i][j]), getAccountIdFromText(accountList[i][j]), ''));
            //     }
            //   }
            //   GlobalModel model = GlobalModel(bondRecord: recordTemp.toList(),bondId: generateId(RecordType.bond),bondDate:dateList[i] ,bondTotal: totalList[i],bondCode: int.parse(codeList[i]).toString(),bondDescription: "",bondType: Const.bondTypeDaily);
            //   // print(model.toFullJson());
            //   bondList.add(GlobalModel.fromJson(model.toFullJson()));
            //   recordTemp.clear();
            // }
            // print(bondList.map((e) => e.toFullJson()));
            // Get.to(()=>BondListView(
            //   bondList: bondList,
            // ));
            // Get.to(() => ProductListView(
            //   productList: dataList,
            //   rows: row as List<String>,
            // ));
          }
        }
      }
    } on Exception catch (e) {
      // TODO
      print(e.toString());
    }
  }

  void pickFile(separator) async {
    var row = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {} else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(separator);
      file.removeAt(0);
      print(row);
      print(row.length);
      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }
      List<List<String>> dataList = file.map((e) => e.split(separator))
          .toList();
      Get.to(() =>
          PreviewView(
            productList: dataList,
            rows: row as List<String>,
          ));
    }
  }

  void pickGlobalFile(separator) async {
    List row = [];
    List row2 = [];
    var indexOfDate;
    var indexOfType;
    var indexOfDetails;
    var indexOfNumber;
    var indexOfAccount;
    var indexOfCredit;
    var indexOfDebit;
    var indexOfTotal;
    var indexOfSmallDes;
    int codeBond = 0;
    List<GlobalModel> bondList = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {} else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(separator);
      row2 = file[2].split(separator);
      file.removeAt(0);
      // print(row);
      // print(row.length);
      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }
      List<List<String>> dataList = file.map((e) => e.split(separator))
          .toList();
      row.forEach((element) {
        indexOfDate = row.indexOf("التاريخ");
        indexOfType = row.indexOf("أصل السند");
        indexOfTotal = row.indexOf("مدين");
        indexOfDetails = row.indexOf("البيان");
        indexOfNumber = row.indexOf("رقم");
      });

      row2.forEach((element) {
        indexOfAccount = row2.indexOf("الحساب");
        indexOfCredit = row2.indexOf("دائن");
        indexOfDebit = row2.indexOf("مدين");
        indexOfSmallDes = row2.indexOf("البيان");
      });

      List<List<String>> accountList = [];
      List<List<String>> creditList = [];
      List<List<String>> debitList = [];
      List<List<String>> smallDesList = [];
      List<String> oreginCode = [];
      List<String> dateList = [];
      List<String> codeList = [];
      List<String> typeList = [];
      List<String> totalList = [];
      List<String> desList = [];
      List<String> numberList = [];
      List<String> accountTemp = [];
      List<String> creditTemp = [];
      List<String> debitTemp = [];
      List<String> smallDesTemp = [];
      dataList.forEach((element) {
        if (element[indexOfAccount] == "الحساب") {
          if (accountTemp.length != 0) {
            accountList.add(accountTemp.toList());
            creditList.add(creditTemp.toList());
            debitList.add(debitTemp.toList());
            smallDesList.add(smallDesTemp.toList());
            accountTemp.clear();
            debitTemp.clear();
            creditTemp.clear();
            smallDesTemp.clear();
          }
        } else if (element[indexOfAccount] == "") {
          dateList.add(element[indexOfDate]);
          desList.add(element[indexOfDetails]);
          numberList.add(element[indexOfNumber]);
          totalList.add(element[indexOfTotal]);
          print(element[indexOfType].split(":"));
          if (element[indexOfType] == "" ||
              element[indexOfType].split(":")[0].removeAllWhitespace ==
                  "يومية".removeAllWhitespace) {
            codeBond++;
          }
          codeList.add(element[indexOfType] == "" ||
              element[indexOfType].split(":")[0].removeAllWhitespace ==
                  "يومية".removeAllWhitespace
              ? codeBond.toString()
              : element[indexOfType].split(":")[1].removeAllWhitespace);
          oreginCode.add(element[indexOfType] == "" ? element[indexOfNumber]
              .replaceAll(",", "")
              .removeAllWhitespace : element[indexOfType].split(":")[1]
              .removeAllWhitespace);
          typeList.add(
              element[indexOfType] == "" ? "سند يومية" : element[indexOfType]
                  .split(":")[0]);
        } else {
          accountTemp.add(
              element[indexOfAccount].replaceFirst("-", "").replaceAll(
                  element[indexOfAccount].split("-")[0], ""));
          creditTemp.add(element[indexOfCredit].toString());
          debitTemp.add(element[indexOfDebit].toString());
          smallDesTemp.add(element[indexOfSmallDes].toString());
        }
        if (dataList.indexOf(element) + 1 == dataList.length) {
          accountList.add(accountTemp.toList());
          creditList.add(creditTemp.toList());
          debitList.add(debitTemp.toList());
          smallDesList.add(smallDesTemp.toList());
          accountTemp.clear();
          debitTemp.clear();
          smallDesTemp.clear();
          creditTemp.clear();
        }
      });
      BondViewModel bondViewModel = Get.find<BondViewModel>();

      List<({String? bondCode, String? bondType})> allbond = bondViewModel
          .allBondsItem.values
          .map(
            (e) => (bondCode: e.bondCode, bondType: e.bondType),
      )
          .toList();
      for (var i = 0; i < accountList.length; i++) {
        List<BondRecordModel> recordTemp = [];
        for (var j = 0; j < accountList[i].length; j++) {
          int pad = 2;
          if (accountList[i][j] != '') {
            if (accountList[i].length > 99) {
              pad = 3;
            }
            print("---------");
            String name = getAccountIdFromText(accountList[i][j]);
            if (name == "") {
              print(accountList[i][j]);
              print(codeList[i]);
            }
            print("---------");
            recordTemp.add(BondRecordModel(j.toString().padLeft(pad, '0'),
                double.parse(creditList[i][j].replaceAll(",", "")),
                double.parse(debitList[i][j].replaceAll(",", "")), name,
                smallDesList[i][j]));
          }
        }
        // print(typeList[i].removeAllWhitespace);
        // print(typeList[i].removeAllWhitespace=="دفع");
        String type = typeList[i].removeAllWhitespace == "دفع"
            ? AppConstants.bondTypeDebit
            : typeList[i].removeAllWhitespace == "قبض"
            ? AppConstants.bondTypeCredit
            : typeList[i].removeAllWhitespace == "ق.إ".removeAllWhitespace
            ? AppConstants.bondTypeStart
            : AppConstants.bondTypeDaily;
        // print(type);
        DateTime date = DateTime(int.parse(dateList[i].split("-")[2]),
            int.parse(dateList[i].split("-")[1]),
            int.parse(dateList[i].split("-")[0]));

        GlobalModel model = GlobalModel(
            bondDescription: desList[i],
            bondRecord: recordTemp.toList(),
            bondId: generateId(RecordType.bond),
            bondDate: date.toString(),
            originAmenId: oreginCode[i],
            //  originAmenId:numberList[i].replaceAll(",", "") ,
            bondTotal: totalList[i].replaceAll(",", ""),
            // bondCode: int.parse(codeList.elementAtOrNull(i)??numberList[i].replaceAll(",", "")).toString(),
            bondCode: codeList[i],
            // bondCode: numberList[i].replaceAll(",", ""),
            bondType: type);
        // print(model.toFullJson());
        bondList.add(GlobalModel.fromJson(model.toFullJson()));
        recordTemp.clear();
      }
      print(bondList.map((e) => e.toFullJson()));
      correctDebitAndCredit(bondList);
      print(bondList.length);
      print(allbond.length);
      print(bondList.last.bondCode);
      bondList.removeWhere((element) =>
          allbond.contains(
            (bondCode: element.bondCode, bondType: element.bondType),
          ));
      Get.to(() =>
          BondListView(
            bondList: bondList,
          ));
      // Get.to(() => ProductListView(
      //   productList: dataList,
      //   rows: row as List<String>,
      // ));
    }
  }

  syncLocalAndFireBase() async {
    print("object");
    Map<String, GlobalModel> local = Map.fromEntries(
        HiveDataBase.globalModelBox.values.map((e) =>
            MapEntry(e.entryBondId!, e)).toList());
    local.forEach(
          (key, value) async {
        await FirebaseFirestore.instance.collection("2024").doc(key).set(
            value.toJson(), SetOptions(merge: true));
        print("key $key-------------------------${value.toJson()}");
      },
    );

    /*   await  FirebaseFirestore.instance.collection("2024").get().then(
          (value) {
        for (var firebaseRecord in value.docs) {
          if (local[firebaseRecord.id] != null) {
            FirebaseFirestore.instance.collection("2024").doc(firebaseRecord.id).set(local[firebaseRecord.id]!.toJson(), SetOptions(merge: true));
          } else {
            FirebaseFirestore.instance.collection("2024").doc(firebaseRecord.id).delete();
          }
          print(local[firebaseRecord.id]?.toJson());
          print("-"*30);
          print(firebaseRecord.data());

          return;
        }
      },
    );*/
  }

  pickNewType(separator) async {
    List row = [];
    List row2 = [];
    var indexOfDate;
    var indexOfType;
    var indexOfDetails;
    var indexOfNumber;
    var indexOfAccount;
    var indexOfCredit;
    var indexOfDebit;
    var indexOfTotal;
    var indexOfSmallDes;
    // List<GlobalModel> bondList = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {} else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(separator);
      row2 = file[2].split(separator);
      file.removeAt(0);
      // print(row);
      // print(row.length);
      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }
      List<List<String>> dataList = file.map((e) => e.split(separator))
          .toList();
      row.forEach((element) {
        indexOfDate = row.indexOf("التاريخ");
        indexOfType = row.indexOf("أصل السند");
        indexOfTotal = row.indexOf("مدين");
        indexOfDetails = row.indexOf("البيان");
        indexOfNumber = row.indexOf("رقم السند");
      });

      row2.forEach((element) {
        indexOfAccount = row2.indexOf("الحساب");
        indexOfCredit = row2.indexOf("دائن");
        indexOfDebit = row2.indexOf("مدين");
        indexOfSmallDes = row2.indexOf("البيان");
      });

      List<List<String>> accountList = [];
      List<List<String>> creditList = [];
      List<List<String>> debitList = [];
      List<List<String>> smallDesList = [];
      List<String> oreginCode = [];
      List<String> dateList = [];
      List<String> codeList = [];
      List<String> typeList = [];
      List<String> totalList = [];
      List<String> desList = [];
      List<String> numberList = [];

      List<String> accountTemp = [];
      List<String> creditTemp = [];
      List<String> debitTemp = [];
      List<String> smallDesTemp = [];

      for (var element in dataList) {
        if (element[indexOfAccount] == "الحساب") {
          if (accountTemp.isNotEmpty) {
            accountList.add(accountTemp.toList());
            creditList.add(creditTemp.toList());
            debitList.add(debitTemp.toList());
            smallDesList.add(smallDesTemp.toList());
            accountTemp.clear();
            debitTemp.clear();
            creditTemp.clear();
            smallDesTemp.clear();
          }
        } else if (element[indexOfAccount] == "") {
          print(element[indexOfType]);
          dateList.add(element[indexOfDate]);
          desList.add(element[indexOfDetails]);
          numberList.add(element[indexOfNumber]);
          totalList.add(element[indexOfTotal]);
          codeList.add(
              element[indexOfType] == "" ? "-" : element[indexOfType].split(
                  ":")[1].removeAllWhitespace);
          oreginCode.add(
              element[indexOfType] == "" ? "-" : element[indexOfType].split(
                  ":")[1].removeAllWhitespace);
          typeList.add(
              element[indexOfType] == "" ? "سند يومية" : element[indexOfType]
                  .split(":")[0]);
        } else {
          accountTemp.add(
              element[indexOfAccount].replaceFirst("-", "").replaceAll(
                  element[indexOfAccount].split("-")[0], ""));
          creditTemp.add(element[indexOfCredit].toString());
          debitTemp.add(element[indexOfDebit].toString());
          smallDesTemp.add(element[indexOfSmallDes].toString());
        }
        if (dataList.indexOf(element) + 1 == dataList.length) {
          accountList.add(accountTemp.toList());
          creditList.add(creditTemp.toList());
          debitList.add(debitTemp.toList());
          smallDesList.add(smallDesTemp.toList());
          accountTemp.clear();
          debitTemp.clear();
          smallDesTemp.clear();
          creditTemp.clear();
        }
      }

      var entry = Get
          .find<InvoiceViewModel>()
          .invoiceModel
          .entries;
      for (var i = 0; i < numberList.length; i++) {
        var typeAndCode = "${typeList[i]} : ${codeList[i]}";
        var matchedEntries = entry.where((
            element) => getInvoicePatternFromInvId(element.key) == typeAndCode);

        if (matchedEntries.isNotEmpty) {
          GlobalModel globalModel = matchedEntries.first.value;
          globalModel.entryBondCode = numberList[i];

          /*if (globalModel.firstPay != 0) {
            print(globalModel.toFullJson());
            print("--*---" * 30);
            globalModel.bondRecord!.add(
              BondRecordModel(
                generateId(RecordType.bond),
                globalModel.firstPay,
                0,
                getAccountIdFromText("حساب التسديد"),
                "${desList[i]} هي دفعة",
              ),
            );
          }*/

          /*    List<String> discountedAccount = [];
          double discountTotal = 0;
          double addedTotal = 0;

       if ((globalModel.discountTotal ?? 0) > 0 || (globalModel.addedTotal ?? 0) > 0) {
            print("--F---" * 30);
            print(globalModel.toFullJson());

            var primaryAccount = getAccountNameFromId(globalModel.invPrimaryAccount);
            var secondaryAccount = getAccountNameFromId(globalModel.invSecondaryAccount);

            var nonTaxAccount = accountList[i].firstWhereOrNull(
              (element) => element != primaryAccount && element != secondaryAccount && !element.contains("ضريبة") && !element.contains("حساب التسديد"),
            );

            if (nonTaxAccount != null && !discountedAccount.contains(nonTaxAccount)) {
              discountedAccount.add(nonTaxAccount);
            }

            for (int index = 0; index < accountList[i].length; index++) {
              for (var discountAccount in discountedAccount) {
                if (accountList[i][index] == discountAccount) {
                  if (globalModel.discountTotal! > 0) {
                    discountTotal += double.parse(creditList[i][index]);
                  } else if (globalModel.addedTotal! > 0) {
                    addedTotal += double.parse(debitList[i][index]);
                  }
                }
              }
            }

            print(discountTotal);

            globalModel.invDiscountRecord = List.generate(
              discountedAccount.length,
              (index) => InvoiceDiscountRecordModel(
                accountId: getAccountIdFromText(discountedAccount[index]),
                isChooseDiscountTotal: true,
                isChooseAddedTotal: true,
                invId: globalModel.invId,
                addedPercentage: addedTotal == 0 ? 0 : ((globalModel.invTotal ?? 0) + ((globalModel.invTotal ?? 0) * 0.05)) / addedTotal,
                addedTotal: addedTotal,
                discountId: index,
                discountTotal: discountTotal,
                discountPercentage: discountTotal == 0 ? 0 : discountTotal / (((globalModel.invTotal ?? 0) + (discountTotal * 1.05)) / 1.05),
              ),
            );
          }*/
          HiveDataBase.globalModelBox.put(globalModel.invId, globalModel);
        }
      }

      /*   for (var i = 0; i < numberList.length; i++) {
        if (entry.where((element) => getInvoicePatternFromInvId(element.key) == "${typeList[i]} : ${codeList[i]}",).isNotEmpty) {
          GlobalModel globalModel = entry
              .firstWhere(
                (entries) {
              return getInvoicePatternFromInvId(entries.key) == "${typeList[i]} : ${codeList[i]}";
            },
          )
              .value;
          globalModel.entryBondCode = numberList[i];
          if(globalModel.firstPay!=0) {
            print(globalModel.toFullJson());
            print("--*---"*30);
            globalModel.bondRecord!.add(BondRecordModel(generateId(RecordType.bond), globalModel.firstPay, 0, getAccountIdFromText("حساب التسديد"), "${desList[i]}هي دقعة"));
          }

          List<String> discountedAccount = [];
          double discountTotal = 0;
          double addedTotal = 0;
          if ((globalModel.discountTotal??0) > 0||(globalModel.addedTotal??0)  > 0) {
            print("--F---"*30);
            print(globalModel.toFullJson());
            if(accountList[i].firstWhereOrNull(
                  (element) {
                    return element != getAccountNameFromId(globalModel.invPrimaryAccount) && element != getAccountNameFromId(globalModel.invSecondaryAccount) && !element.contains("ضريبة")&& !element.contains("حساب التسديد");
                  },
            )!=null) {
              discountedAccount.addIf(
                  !discountedAccount.contains(accountList[i].firstWhere(
                        (element) => element != getAccountNameFromId(globalModel.invPrimaryAccount) && element != getAccountNameFromId(globalModel.invSecondaryAccount) && !element.contains("حساب التسديد"),
                      ) ),
                  accountList[i].firstWhere(
                    (element) => element != getAccountNameFromId(globalModel.invPrimaryAccount) && element != getAccountNameFromId(globalModel.invSecondaryAccount) && !element.contains("حساب التسديد"),
                  ));
            }

            for (int index = 0; index < accountList[i].length; index++) {
              for (var discountAccounts in discountedAccount) {
                if (accountList[i][index] == (discountAccounts)) {
                  if(globalModel.discountTotal != 0) {
                    discountTotal += double.parse(creditList[i][index]);
                  } else if(globalModel.addedTotal != 0){
                    addedTotal += double.parse(debitList[i][index]);
                  }

                }
              }
            }
            print(discountTotal);
            // print(globalModel.invTotal );
            // print(globalModel.toJson());
            // print("globalModel.toJson()"*30);
            globalModel.invDiscountRecord = List.generate(
              discountedAccount.length,
                  (index) =>
                  InvoiceDiscountRecordModel(
                    accountId: getAccountIdFromText(
                        discountedAccount[index])
                    ,
                    isChooseDiscountTotal: true,
                    isChooseAddedTotal: true,
                    invId: globalModel.invId,
                    addedPercentage: addedTotal == 0 ? 0 : ((globalModel.invTotal ?? 0) + ((globalModel.invTotal??0) *0.05)) / addedTotal,
                    addedTotal: addedTotal,
                    discountId: index,
                    discountTotal: discountTotal,
                    discountPercentage: discountTotal == 0 ? 0 :discountTotal/(((globalModel.invTotal??0)+(discountTotal*1.05))/1.05),
                  ),
            );
            // print(globalModel.toFullJson());

          }
          HiveDataBase.globalModelBox.put(globalModel.entryBondId, globalModel);


          // Get.to(() => EntryBondListView(
          //   bondList: bondList,
          // ));

        }


        //
        // print(invoiceViewModel.map((e) => e.value.toFullJson(),));
      }*/
      print("---end--" * 30);
    }
  }
}
