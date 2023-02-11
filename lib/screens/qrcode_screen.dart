import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_billing_qrcode_test/controllers/qrcode_controller.dart';
import 'package:flutter_billing_qrcode_test/main.dart';
import 'package:flutter_billing_qrcode_test/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';

class QRCodeScanScreen extends StatefulWidget {
  const QRCodeScanScreen({super.key});

  @override
  State<QRCodeScanScreen> createState() => _QRCodeScanScreenState();
}

class _QRCodeScanScreenState extends State<QRCodeScanScreen>
    with WidgetsBindingObserver {
  final qrcodeController = Get.put(QRCodeController());
  final ImagePicker _picker = ImagePicker();

  CameraDescription? _camera;
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCameraPreview();
  }

  @override
  void dispose() {
    _stopLiveCamera();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        log("inactive");
        await _stopLiveCamera();
        break;
      case AppLifecycleState.resumed:
        log("resumed");
        await _initCameraPreview();
    }
  }

  Future pickImageAndDecodeQRCode() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var inputImage = InputImage.fromFilePath(image.path);
      await qrcodeController.decodeQRCode(inputImage);

      await qrcodeController.parseQRCode();
    } else {
      await _initCameraPreview();
    }
  }

  Future _initCameraPreview() async {
    if (cameras.isEmpty) {
      cameras = await availableCameras();
    }

    _camera = cameras.first;

    _cameraController = CameraController(
      _camera!,
      ResolutionPreset.high,
    );

    _cameraController?.initialize().then((_) {
      _cameraController?.startImageStream(pickImageFromCamera);
      setState(() {});
    });
  }

  Future pickImageFromCamera(CameraImage cameraImage) async {
    log("pickImageFromCamera");
    final WriteBuffer allBytes = WriteBuffer();

    for (final Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

    final InputImageRotation imageRotation =
        InputImageRotationValue.fromRawValue(_camera!.sensorOrientation) ??
            InputImageRotation.rotation0deg;

    final InputImageFormat inputImageFormat =
        InputImageFormatValue.fromRawValue(cameraImage.format.raw) ??
            InputImageFormat.bgra8888;

    final planeData = cameraImage.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: inputImageData,
    );

    await qrcodeController.decodeQRCode(inputImage);

    // await _stopLiveCamera();

    if (qrcodeController.qrcode.value.isEmpty) {
    } else {
      await qrcodeController.parseQRCode();

      if (!qrcodeController.parseQRCodeSuccess.value) {
        // _cameraController?.startImageStream(pickImageFromCamera);
      } else {
        await _stopLiveCamera();
      }
    }
  }

  Future _stopLiveCamera() async {
    await _cameraController?.stopImageStream();
    await _cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QRCode"),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => HomeScreen());
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Center(
        child: Obx(() {
          if (qrcodeController.parsingQRCode.value) {
            return const CircularProgressIndicator();
          }

          if (_cameraController == null ||
              !_cameraController!.value.isInitialized) {
            return const CircularProgressIndicator();
          }

          return Stack(
            children: [
              CameraPreview(_cameraController!),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _stopLiveCamera();
                      await pickImageAndDecodeQRCode();
                    },
                    child: const Text("Chọn từ thư viện"),
                  ),
                ),
              ),
            ],
          );

          // return ElevatedButton(
          //   onPressed: qrcodeController.pickImageAndDecodeQRCode,
          //   child: const Text("Chọn từ thư viện"),
          // );
        }),
      ),
    );
  }
}

class QRCodeParseResultScreen extends StatelessWidget {
  QRCodeParseResultScreen({super.key});

  final QRCodeController _qrCodeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("QRCode"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => HomeScreen());
              },
              icon: const Icon(Icons.home),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    children: [
                      // Merchant Name
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Thanh toán cho"),
                            Text(_qrCodeController
                                .parseQRCodeDto.value.merchantName),
                          ],
                        ),
                      ),
                      // Merchant Name

                      // Terminal Name
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Điểm bán"),
                            Text(_qrCodeController
                                .parseQRCodeDto.value.terminalId),
                          ],
                        ),
                      ),
                      // Terminal Name

                      // Mã đơn hàng
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Mã đơn hàng"),
                            Text(_qrCodeController.parseQRCodeDto.value.txnId),
                          ],
                        ),
                      ),
                      // Mã đơn hàng

                      // Số tiền thanh toán
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Số tiền thanh toán"),
                            Text(
                              _qrCodeController.formatMoney(
                                amount: int.parse(
                                  _qrCodeController.parseQRCodeDto.value.amount,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Số tiền thanh toán
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _qrCodeController.ipnQRCode,
                    child: const Text("Thanh toán"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QRCodeIpnResultScreen extends StatelessWidget {
  QRCodeIpnResultScreen({super.key});

  final QRCodeController _qrCodeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("QRCode"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => HomeScreen());
              },
              icon: const Icon(Icons.home),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() {
                                if (_qrCodeController
                                    .ipnQrCodeResponseDto.value.success) {
                                  return const Text(
                                    "Thành công",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20.0,
                                    ),
                                  );
                                }

                                return const Text(
                                  "Thất bại",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20.0,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _qrCodeController
                                        .ipnQrCodeResponseDto.value.message ??
                                    "Lỗi hệ thống",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => HomeScreen());
                  },
                  child: const Text("Trang chủ"),
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
