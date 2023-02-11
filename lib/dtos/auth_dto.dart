import 'dart:convert';

AuthRequestDto authRequestDtoFromJson(String str) =>
    AuthRequestDto.fromJson(json.decode(str));

String authRequestDtoToJson(AuthRequestDto data) => json.encode(data.toJson());

/// Request get token
class AuthRequestDto {
  AuthRequestDto({
    required this.clientId,
    required this.clientSecret,
    required this.grantType,
  });

  String clientId;
  String clientSecret;
  String grantType;

  factory AuthRequestDto.fromJson(Map<String, dynamic> json) => AuthRequestDto(
        clientId: json["client_id"],
        clientSecret: json["client_secret"],
        grantType: json["grant_type"],
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "client_secret": clientSecret,
        "grant_type": grantType,
      };
}

AuthResponseDto authResponseDtoFromJson(String str) =>
    AuthResponseDto.fromJson(json.decode(str));

String authResponseDtoToJson(AuthResponseDto data) =>
    json.encode(data.toJson());

/// Response lấy auth token
class AuthResponseDto {
  AuthResponseDto({
    required this.accessToken,
    required this.expiresIn,
  });

  String accessToken;
  int expiresIn;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      AuthResponseDto(
        accessToken: json["access_token"],
        expiresIn: json["expires_in"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expires_in": expiresIn,
      };
}
