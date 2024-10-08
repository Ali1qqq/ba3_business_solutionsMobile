import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/model/product/product_model.dart';
import 'package:ba3_business_solutions/view/products/widget/add_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerView extends StatefulWidget {
  const QRScannerView({super.key, required this.whitUnknown});

  final bool whitUnknown;

  @override
  State<StatefulWidget> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  List<ProductModel> data = [];
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller?.stopCamera();
        return true;
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            _buildQrView(context, widget.whitUnknown),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "عدد المنتجات ${data.length}",
                          style: const TextStyle(
                              fontSize: 24, color: Colors.black),
                        ),
                        const Spacer(),
                        if (data.isNotEmpty)
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.back(result: data);
                              },
                              child: const Text("إضافة"),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      // Horizontal scrolling
                      child: Row(
                        children: [
                          Wrap(
                            direction: Axis.vertical,
                            children: <Widget>[
                              if (data.isEmpty) const Text('امسح الباركود'),
                              for (var i in data)
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        i.prodName ?? "not found",
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                      const SizedBox(width: 20),
                                      const Text("السعر: "),
                                      Text(
                                        i.prodCustomerPrice ?? "not found",
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                      const SizedBox(width: 20),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            data.remove(i);
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context, bool withUnknown) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    // var scanArea = (MediaQuery.of(context).size.width < 400 ||
    //     MediaQuery.of(context).size.height < 400)
    //     ? 150.0
    //     : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: (p0) {
        _onQRViewCreated(p0, withUnknown);
      },
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          // cutOutSize: scanArea
          cutOutHeight: 350,
          cutOutWidth: 500),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller, bool withUnknown) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        if (data.firstWhereOrNull(
                    (element) => element.prodBarcode == scanData.code) ==
                null &&
            scanData.format != BarcodeFormat.qrcode) {
          ProductViewModel productViewController = Get.find<ProductViewModel>();

          var _ = productViewController.productDataMap.values
              .toList()
              .firstWhereOrNull(
                  (element) => element.prodBarcode == scanData.code);

          if (withUnknown) {
            AudioPlayer().play(AssetSource('barcode.m4a'));
            if (_ != null) {
              data.add(_);
            } else {
              data.add(ProductModel(
                prodName: scanData.code,
                prodBarcode: scanData.code,
                prodCustomerPrice: "0",
              ));
            }
            setState(() {});
          } else if (_ != null && !withUnknown) {
            AudioPlayer().play(AssetSource('barcode.m4a'));
            data.add(_);
            setState(() {});
          } else {
            controller.pauseCamera();
            Get.defaultDialog(
                onWillPop: () async {
                  controller.resumeCamera();
                  return true;
                },
                title: "غير موجود",
                middleText:
                    "غير موجود " + scanData.code! + "المنتح صاحب الباركود ",
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.resumeCamera();
                      },
                      child: const Text("إلغاء")),
                  ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        await Get.to(
                            () => AddProduct(oldBarcode: scanData.code));
                        controller.resumeCamera();
                      },
                      child: const Text("إضافة المنتح")),
                ]);
          }

          //  Get.back(result: {"data":data});
        }
      }

      //  Get.back();
      // setState(() {
      //   result = scanData;
      // });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
