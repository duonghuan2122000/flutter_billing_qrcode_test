import 'dart:developer';

import 'package:flutter_billing_qrcode_test/caches/file_cache_manager.dart';
import 'package:flutter_billing_qrcode_test/commons/common_const.dart';
import 'package:flutter_billing_qrcode_test/dtos/auth_dto.dart';
import 'package:flutter_billing_qrcode_test/providers/auth_provider.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthProvider _authProvider = AuthProvider();
  final FileCacheManager _fileCacheManager = FileCacheManager();

  Future<String> getToken() async {
    String? token = await _fileCacheManager.readCache(CacheKey.getToken);

    if (token == null) {
      log("get token from api");
      AuthRequestDto authRequestDto = AuthRequestDto(
          clientId: GetClientConst.clientId,
          clientSecret: GetClientConst.clientSecret,
          grantType: GetClientConst.grantType);
      try {
        var authResponseDto = await _authProvider.getToken(authRequestDto);
        token = authResponseDto.accessToken;
        await _fileCacheManager.writeCache(
          CacheKey.getToken,
          token,
          const Duration(hours: 23),
        );
      } catch (e) {
        log("Lỗi get token: $e");
      }
    }

    log("token: $token");
    return token!;
  }
}
