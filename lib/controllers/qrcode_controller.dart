import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_billing_qrcode_test/commons/common_const.dart';
import 'package:flutter_billing_qrcode_test/controllers/auth_controller.dart';
import 'package:flutter_billing_qrcode_test/dtos/qrcode_dto.dart';
import 'package:flutter_billing_qrcode_test/providers/qrcode_provider.dart';
import 'package:flutter_billing_qrcode_test/screens/qrcode_screen.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class QRCodeController extends GetxController {
  final AuthController _authController = Get.find();
  final QRCodeProvider _qrCodeProvider = QRCodeProvider();

  final barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]);

  final numberFormat = NumberFormat("#,##0", "vi_VN");

  var qrcode = "".obs;

  var decodingQRCode = false.obs;

  var parseQRCodeSuccess = false.obs;

  var parsingQRCode = false.obs;

  var parseQRCodeDto = ParseQrCodeDto(
    terminalId: "",
    amount: "",
    merchantCode: "",
    merchantName: "",
    txnId: "",
    purpose: "",
  ).obs;

  var ipnQrCodeResponseDto = IpnQrCodeResponseDto(
    code: IpnQRCodeErrorCode.internalError,
  ).obs;

  Future decodeQRCode(InputImage inputImage) async {
    if (decodingQRCode.value) {
      return;
    }
    decodingQRCode.value = true;
    qrcode.value = "";
    final List<Barcode> barcodes =
        await barcodeScanner.processImage(inputImage);

    for (Barcode barcode in barcodes) {
      final BarcodeType type = barcode.type;

      // See API reference for complete list of supported types
      switch (type) {
        case BarcodeType.text:
          qrcode.value = barcode.displayValue ?? "";
          break;
        default:
          qrcode.value = barcode.rawValue ?? "";
          break;
      }
    }

    log("qrcode: ${qrcode.value}");
    decodingQRCode.value = false;
  }

  Future parseQRCode() async {
    if (parsingQRCode.value) {
      return;
    }
    parsingQRCode.value = true;
    if (qrcode.value.isNotEmpty) {
      parseQRCodeSuccess.value = false;
      try {
        parseQRCodeDto.value = await _qrCodeProvider.parseQRCode(
          qrcode.value,
          await _authController.getToken(),
        );
        parseQRCodeSuccess.value = true;

        if (parseQRCodeSuccess.value) {
          Get.to(() => QRCodeParseResultScreen());
        }
      } catch (e) {
        log("Lỗi parse QRCode: $e");
        Get.snackbar(
          "QRCode",
          "QRCode không đúng định dạng.",
          snackPosition: SnackPosition.BOTTOM,
        );
        parseQRCodeSuccess.value = false;
      }
    }
    await Future.delayed(const Duration(milliseconds: 500));
    parsingQRCode.value = false;
  }

  String formatMoney({required int amount, String? ccy = "VND"}) {
    return "${numberFormat.format(amount)} $ccy";
  }

  Future ipnQRCode() async {
    try {
      var ipnQrCodeRequestDto = IpnQrCodeRequestDto(
        code: IpnQRCodeErrorCode.success,
        message: "Đặt hàng thành công",
        msgType: "1",
        txnId: parseQRCodeDto.value.txnId,
        qrTrace: DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
        bankCode: "VNPAY",
        mobile: "",
        accountNo: "",
        amount: parseQRCodeDto.value.amount,
        payDate: DateFormat("yyyyMMddHHmm").format(DateTime.now()),
        masterMerCode: "970436",
        merchantCode: parseQRCodeDto.value.merchantCode,
        terminalId: parseQRCodeDto.value.terminalId,
        name: "",
        phone: "",
        provinceId: "",
        districtId: "",
        address: "",
        email: "",
      );
      ipnQrCodeResponseDto.value = await _qrCodeProvider.ipnQRCode(
        ipnQrCodeRequestDto,
        await _authController.getToken(),
      );
      // log("ipnQrCodeRequestDto.qrTrace = ${ipnQrCodeRequestDto.qrTrace} \n ipnQrCodeRequestDto.payDate = ${ipnQrCodeRequestDto.payDate}");
      // ipnQrCodeResponseDto.value = IpnQrCodeResponseDto(
      //   code: IpnQRCodeErrorCode.success,
      // );
    } catch (e) {
      log("Lỗi gạch nợ QRCode: $e");
      ipnQrCodeResponseDto.value = IpnQrCodeResponseDto(
        code: IpnQRCodeErrorCode.internalError,
      );
    }

    Get.to(() => QRCodeIpnResultScreen());
  }
}
