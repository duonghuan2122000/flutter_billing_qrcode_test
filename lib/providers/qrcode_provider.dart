import 'dart:developer';

import 'package:flutter_billing_qrcode_test/commons/common_const.dart';
import 'package:flutter_billing_qrcode_test/dtos/qrcode_dto.dart';
import 'package:get/get.dart';

class QRCodeProvider extends GetConnect {
  Future<ParseQrCodeDto> parseQRCode(String qrcode, String token) async {
    var response = await get(
      "${UrlConst.parseQRCode}?data=$qrcode",
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.status.hasError) {
      return Future.error(response.statusCode ?? 500);
    }

    return parseQrCodeDtoFromJson(response.bodyString!);
  }

  Future<IpnQrCodeResponseDto> ipnQRCode(
      IpnQrCodeRequestDto ipnQrCodeRequestDto, String token) async {
    var response = await post(
      UrlConst.ipnQRCode,
      ipnQrCodeRequestDto.toJson(),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    log("ipnRes: ${response.bodyString}");

    if (response.status.hasError) {
      return Future.error(response.statusCode ?? 500);
    }

    return ipnQrCodeResponseDtoFromJson(response.bodyString!);
  }
}
