import 'dart:developer';

import 'package:flutter_billing_qrcode_test/commons/common_const.dart';
import 'package:flutter_billing_qrcode_test/dtos/auth_dto.dart';
import 'package:get/get.dart';

class AuthProvider extends GetConnect {
  /// Get token
  Future<AuthResponseDto> getToken(AuthRequestDto authRequestDto) async {
    var response = await post(
      UrlConst.getToken,
      authRequestDto.toJson(),
      contentType: HeaderContentTypeConst.applicationXWwwFormUrlencoded,
    );
    if (response.status.hasError) {
      log("get token error: ${response.bodyString}");
      return Future.error(response.statusCode ?? 500);
    }

    return authResponseDtoFromJson(response.bodyString!);
  }
}
