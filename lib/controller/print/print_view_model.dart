import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/model/warranty/Warranty_Model.dart';
import 'package:ba3_business_solutions/model/warranty/Warranty_record_model.dart';
import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:ba3_business_solutions/model/invoice/invoice_record_model.dart';
import 'package:ba3_business_solutions/model/product/product_model.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrintViewModel extends GetxController {
  Future<void> printFunction(GlobalModel globalModel,
      {WarrantyModel? warrantyModel}) async {
    List<BluetoothInfo> allBluetooth = await getBluetoots();

    if (allBluetooth
        .map(
          (e) => e.macAdress,
        )
        .toList()
        .contains("66:32:8D:F3:FF:7E")) {
      if (!connected) {
        await connect("66:32:8D:F3:FF:7E");
      }
      if (warrantyModel != null) {
        await printTest(GlobalModel(), warranty: warrantyModel);
      } else {
        await printTest(globalModel);
      }
      //await disconnect();
    } else if (allBluetooth
        .map(
          (e) => e.macAdress,
        )
        .toList()
        .contains("66:32:8d:f3:ff:7e")) {
      if (!connected) {
        await connect("66:32:8d:f3:ff:7e");
      }
      if (warrantyModel != null) {
        await printTest(GlobalModel(), warranty: warrantyModel);
      } else {
        await printTest(globalModel);
      }
      //await disconnect();
    } else {
      print("Cant find the printer");
    }
  }

  // String _info = "";
  //  String _msj = '';
  bool connected = false;
  List<BluetoothInfo> items = [];

  Future<List<BluetoothInfo>> getBluetoots() async {
    // setState(() {
    items = [];
    // });
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    /*await Future.forEach(listResult, (BluetoothInfo bluetooth) {
      String name = bluetooth.name;
      String mac = bluetooth.macAdress;
    });*/

    // setState(() {
    // });

    if (listResult.isEmpty) {
      // _msj = "There are no bluetoohs linked, go to settings and link the printer";
    } else {
      // _msj = "Touch an item in the list to connect";
    }

    // setState(() {
    items = listResult;
    // });
    return items;
  }

  Future<void> connect(String mac) async {
    // setState(() {
    connected = false;
    // });
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    print("state conected $result");
    if (result) connected = true;
    // setState(() {
    // });
  }

  Future<void> disconnect() async {
    final bool status = await PrintBluetoothThermal.disconnect;
    // setState(() {
    connected = false;
    // });
    print("status disconnect $status");
  }

  Future<void> printTest(GlobalModel globalModel,
      {WarrantyModel? warranty}) async {
    /*
    if (kDebugMode) {
      bool result = await PrintBluetoothThermalWindows.writeBytes(bytes: "Hello \n".codeUnits);
      return;
    }
     */

    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;

    if (conexionStatus) {
      bool result = false;
      if (warranty != null) {
        List<int> ticket = await testTextWarranty(warranty!);
        result = await PrintBluetoothThermal.writeBytes(ticket);
      } else {
        List<int> ticket = await testText(globalModel);
        result = await PrintBluetoothThermal.writeBytes(ticket);
      }

      print("print test result:  $result");
    } else {
      disconnect();
      print("print test conexionStatus: $conexionStatus");
    }
  }

  Future<List<int>> testImage() async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.reset();
    // Uint8List? a = await Utils.capture(aKey);
    // bytes += generator.imageRaster(img.decodeImage(a!)!);
    bytes += generator.feed(2);
    return bytes;
  }

  Future<List<int>> testText(GlobalModel globalModel) async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    bytes += generator.text('Tax Invoice',
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    // final ByteData data = await rootBundle.load('assets/logo.jpg');
    // final Uint8List bytesImg = data.buffer.asUint8List();
    // img.Image? image = img.decodeImage(bytesImg);
    // bytes += generator.imageRaster(image!);

    bytes += generator.text("Burj AlArab Mobile Phone",
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text("Date: " + globalModel.invDate.toString(),
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.text("IN NO: " + globalModel.invId.toString(),
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.text("TRN: 10036 93114 00003",
        styles: PosStyles(align: PosAlign.left), linesAfter: 1);
    double total = 0;
    double natTotal = 0;
    double vatTotal = 0;
    for (InvoiceRecordModel model in globalModel.invRecords ?? []) {
      double modelSubTotalWithVat = model.invRecTotal! / model.invRecQuantity!;
      double modelSubVatTotal =
          modelSubTotalWithVat - (modelSubTotalWithVat / 1.05);
      double modelSubTotal = modelSubTotalWithVat / 1.05;

      ProductModel productModel = getProductModelFromId(model.invRecProduct)!;
      String text = checkArabicWithTranslate(productModel.prodName!);
      bytes += generator.text(text.length < 64 ? text : text.substring(0, 64),
          styles: PosStyles(align: PosAlign.left));
      bytes += generator.text(productModel.prodBarcode ?? "",
          styles: PosStyles(align: PosAlign.left));
      double totalOfLine = model.invRecTotal!;
      total = totalOfLine + total;
      // natTotal = model.invRecQuantity!* (model.invRecSubTotal!) +natTotal;
      // vatTotal = model.invRecQuantity!* (model.invRecSubTotal!)*0.05 +vatTotal;
      natTotal = model.invRecQuantity! * modelSubTotal + natTotal;
      vatTotal = model.invRecQuantity! * modelSubVatTotal + vatTotal;
      bytes += generator.text(
          '${model.invRecQuantity} X ${modelSubTotalWithVat.toStringAsFixed(2)} -> Total:${totalOfLine.toStringAsFixed(2)}',
          styles: const PosStyles(align: PosAlign.left),
          linesAfter: 1);
    }

    bytes += generator.text('Total VAT: ${vatTotal.toStringAsFixed(2)}',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('-' * 30,
        styles: const PosStyles(align: PosAlign.right));

    // bytes += generator.text('Sub: '+total.toStringAsFixed(2), styles: PosStyles(align: PosAlign.right));
    // bytes += generator.text('VAT: '+(globalModel.invTotal!-total).toStringAsFixed(2), styles: PosStyles(align: PosAlign.right));
    // bytes += generator.text('Total: '+globalModel.invTotal.toString(), styles: PosStyles(align: PosAlign.right,bold: true));
    bytes += generator.text('Sub: ' + natTotal.toStringAsFixed(2) + " AED",
        styles: const PosStyles(align: PosAlign.right, bold: true));
    bytes += generator.text('VAT: ' + vatTotal.toStringAsFixed(2) + " AED",
        styles: const PosStyles(align: PosAlign.right, bold: true));
    bytes += generator.text(
        'Total: ' + (natTotal + vatTotal).toStringAsFixed(2) + " AED",
        styles: const PosStyles(align: PosAlign.right, bold: true));
    bytes += generator.text("UAE, Rak, Sadaf Roundabout",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text("0568666411",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text("Thanks For Visiting BA3",
        styles: const PosStyles(align: PosAlign.center, bold: true));
    // final file = base64Encode(a!.toList());
    // print(a.length);
    // bytes +=  generator.image(decodeImage(a)!);
// Using `GS v 0` (obsolete)
// Using `GS ( L`
//     bytes +=  generator.imageRaster(img.decodeImage(a)!, imageFn: PosImageFn.graphics);
    //Using `ESC *`
    //bytes += generator.image(image!);
    // bytes += generator.text('مرحبا', styles: PosStyles(codeTable: 'WPC1256'));
    //  const utf8Encoder = Utf8Encoder();
    //  final encodedStr = utf8Encoder.convert('مرحبا');

    //  generator.textEncoded(Uint8List.fromList([

    //  ]));
    //  bytes += generator.text('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    // bytes += generator.text('Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ', styles: PosStyles(codeTable: 'CP1252'));
    // bytes += generator.text('Special 2: blåbærgrød', styles: PosStyles(codeTable: 'CP1252'));
    //
    // bytes += generator.text('Bold text', styles: PosStyles(bold: true));
    // bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
    // bytes += generator.text('Underlined text', styles: PosStyles(underline: true), linesAfter: 1);
    // bytes += generator.text('Align left', styles: PosStyles(align: PosAlign.left));
    // bytes += generator.text('Align center', styles: PosStyles(align: PosAlign.center));
    // bytes += generator.text('Align right', styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    // bytes += generator.row([
    //   PosColumn(
    //     text: 'col3',
    //     width: 3,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    //   PosColumn(
    //     text: 'col6',
    //     width: 6,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    //   PosColumn(
    //     text: 'col3',
    //     width: 3,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    // ]);

    //barcode

    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // bytes += generator.barcode(Barcode.upcA(barData));
    //
    // //QR code
    // bytes += generator.qrcode('example.com');
    //
    // bytes += generator.text(
    //   'Text size 50%',
    //   styles: PosStyles(
    //     fontType: PosFontType.fontB,
    //   ),
    // );
    // bytes += generator.text(
    //   'Text size 100%',
    //   styles: PosStyles(
    //     fontType: PosFontType.fontA,
    //   ),
    // );

    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> testTextWarranty(WarrantyModel globalModel) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.reset();

    bytes += generator.text('Warranty Invoice',
        styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text("Burj AlArab Mobile Phone",
        styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text("Date: ${globalModel.invDate}",
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text("IN NO: ${globalModel.invId}",
        styles: const PosStyles(align: PosAlign.left));

    for (WarrantyRecordModel model in globalModel.invRecords ?? []) {
      ProductModel productModel = getProductModelFromId(model.invRecProduct)!;
      String text = checkArabicWithTranslate(productModel.prodName!);
      bytes += generator.text(text.length < 64 ? text : text.substring(0, 64),
          styles: PosStyles(align: PosAlign.left));
      bytes += generator.text(productModel.prodBarcode ?? "",
          styles: PosStyles(align: PosAlign.left));
    }

    bytes += generator.text('-' * 30,
        styles: const PosStyles(align: PosAlign.right));

    bytes += generator.text("UAE, Rak, Sadaf Roundabout",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text("0568666411",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text("Thanks For Visiting BA3",
        styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.feed(2);

    return bytes;
  }

  double computeWithoutVatTotal(records) {
    int quantity = 0;
    double subtotals = 0.0;
    double total = 0.0;
    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        subtotals = record.invRecSubTotal!;
        total += quantity * (subtotals);
      }
    }
    return total;
  }

  double computeAllTotal(records) {
    int quantity = 0;
    double subtotals = 0.0;
    double total = 0.0;
    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        subtotals = record.invRecSubTotal!;
        total += quantity * (subtotals + record.invRecVat!);
      }
    }
    return total;
  }

  double computeVatTotal(records) {
    int quantity = 0;
    double total = 0.0;
    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        total += quantity * record.invRecVat!;
      }
    }
    return total;
  }

  String checkArabicWithTranslate(String data) {
    bool isArabic = false;
    for (var c in data.codeUnits) {
      if (c >= 0x0600 && c <= 0x06E0) {
        isArabic = true;
      }
    }
    if (isArabic) {
      String _ = data
          .replaceAll("ا", "a")
          .replaceAll("ب", "b")
          .replaceAll("ت", "t")
          .replaceAll("ث", "th")
          .replaceAll("ج", "g")
          .replaceAll("ح", "h")
          .replaceAll("خ", "kh")
          .replaceAll("د", "d")
          .replaceAll("ذ", "th")
          .replaceAll("ر", "r")
          .replaceAll("ز", "z")
          .replaceAll("س", "s")
          .replaceAll("ش", "sh")
          .replaceAll("ص", "s")
          .replaceAll("ض", "d")
          .replaceAll("ط", "t")
          .replaceAll("ظ", "Z")
          .replaceAll("ع", "a")
          .replaceAll("غ", "gh")
          .replaceAll("ف", "ph")
          .replaceAll("ق", "k")
          .replaceAll("ك", "k")
          .replaceAll("ل", "l")
          .replaceAll("م", "m")
          .replaceAll("ن", "n")
          .replaceAll("ه", "h")
          .replaceAll("و", "w")
          .replaceAll("ي", "e")
          .replaceAll("ة", "a");
      print(_);
      print(data + "  " + _);
      return _;
    } else {
      return data;
    }
  }
}
