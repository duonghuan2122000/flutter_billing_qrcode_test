import 'dart:convert';

import 'package:flutter_billing_qrcode_test/commons/common_const.dart';

ParseQrCodeDto parseQrCodeDtoFromJson(String str) =>
    ParseQrCodeDto.fromJson(json.decode(str));

String parseQrCodeDtoToJson(ParseQrCodeDto data) => json.encode(data.toJson());

class ParseQrCodeDto {
  ParseQrCodeDto({
    required this.terminalId,
    required this.amount,
    required this.merchantCode,
    required this.merchantName,
    required this.txnId,
    required this.purpose,
  });

  String terminalId;
  String amount;
  String merchantCode;
  String merchantName;
  String txnId;
  String purpose;

  factory ParseQrCodeDto.fromJson(Map<String, dynamic> json) => ParseQrCodeDto(
        terminalId: json["TerminalId"] ?? "",
        amount: json["Amount"] ?? "0",
        merchantCode: json["MerchantCode"] ?? "",
        merchantName: json["MerchantName"] ?? "",
        txnId: json["TxnId"] ?? "",
        purpose: json["Purpose"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "TerminalId": terminalId,
        "Amount": amount,
        "MerchantCode": merchantCode,
        "MerchantName": merchantName,
        "TxnId": txnId,
        "Purpose": purpose,
      };
}

IpnQrCodeRequestDto ipnQrCodeRequestDtoFromJson(String str) =>
    IpnQrCodeRequestDto.fromJson(json.decode(str));

String ipnQrCodeRequestDtoToJson(IpnQrCodeRequestDto data) =>
    json.encode(data.toJson());

class IpnQrCodeRequestDto {
  IpnQrCodeRequestDto({
    required this.code,
    required this.message,
    required this.msgType,
    required this.txnId,
    required this.qrTrace,
    required this.bankCode,
    required this.mobile,
    required this.accountNo,
    required this.amount,
    required this.payDate,
    required this.masterMerCode,
    required this.merchantCode,
    required this.terminalId,
    required this.name,
    required this.phone,
    required this.provinceId,
    required this.districtId,
    required this.address,
    required this.email,
    this.addData,
  });

  String code;
  String message;
  String msgType;
  String txnId;
  String qrTrace;
  String bankCode;
  String mobile;
  String accountNo;
  String amount;
  String payDate;
  String masterMerCode;
  String merchantCode;
  String terminalId;
  String name;
  String phone;
  String provinceId;
  String districtId;
  String address;
  String email;
  dynamic addData;

  factory IpnQrCodeRequestDto.fromJson(Map<String, dynamic> json) =>
      IpnQrCodeRequestDto(
        code: json["Code"],
        message: json["Message"],
        msgType: json["MsgType"],
        txnId: json["TxnId"],
        qrTrace: json["QrTrace"],
        bankCode: json["BankCode"],
        mobile: json["Mobile"],
        accountNo: json["AccountNo"],
        amount: json["Amount"],
        payDate: json["PayDate"],
        masterMerCode: json["MasterMerCode"],
        merchantCode: json["MerchantCode"],
        terminalId: json["TerminalId"],
        name: json["Name"],
        phone: json["Phone"],
        provinceId: json["Province_id"],
        districtId: json["District_id"],
        address: json["Address"],
        email: json["Email"],
        addData: json["AddData"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message": message,
        "MsgType": msgType,
        "TxnId": txnId,
        "QrTrace": qrTrace,
        "BankCode": bankCode,
        "Mobile": mobile,
        "AccountNo": accountNo,
        "Amount": amount,
        "PayDate": payDate,
        "MasterMerCode": masterMerCode,
        "MerchantCode": merchantCode,
        "TerminalId": terminalId,
        "Name": name,
        "Phone": phone,
        "Province_id": provinceId,
        "District_id": districtId,
        "Address": address,
        "Email": email,
        "AddData": addData,
      };
}

IpnQrCodeResponseDto ipnQrCodeResponseDtoFromJson(String str) =>
    IpnQrCodeResponseDto.fromJson(json.decode(str));

String ipnQrCodeResponseDtoToJson(IpnQrCodeResponseDto data) =>
    json.encode(data.toJson());

class IpnQrCodeResponseDto {
  IpnQrCodeResponseDto({
    required this.code,
  });

  String code;

  factory IpnQrCodeResponseDto.fromJson(Map<String, dynamic> json) =>
      IpnQrCodeResponseDto(
        code: json["Code"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
      };

  bool get success {
    return code == IpnQRCodeErrorCode.success;
  }

  String? get message {
    if (IpnQRCodeErrorCode.errorMessages.keys.contains(code)) {
      return IpnQRCodeErrorCode.errorMessages[code];
    }

    return IpnQRCodeErrorCode.errorMessages[IpnQRCodeErrorCode.internalError];
  }
}
