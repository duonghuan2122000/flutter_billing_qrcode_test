class UrlConst {
  static const getToken = "https://testdcauthapi.jetpay.vn/connect/token";
  static const parseQRCode = "https://testdcqrcode.jetpay.vn/test/parse";
  static const ipnQRCode = "https://testdcqrcode.jetpay.vn/transactions";
}

class HeaderContentTypeConst {
  static const applicationXWwwFormUrlencoded =
      "application/x-www-form-urlencoded";
}

class GetClientConst {
  static const clientId = "dbhuantest-client";
  static const clientSecret = "f3182268-622a-11ec-a2c6-005056b3760f";
  static const grantType = "client_credentials";
}

class CacheKey {
  static const getToken = "getToken";
}

class IpnQRCodeErrorCode {
  static const success = "00";
  static const orderPaid = "03";
  static const errCreateOrder = "04";
  static const wrongCredentials = "06";
  static const wrongAmount = "07";
  static const expire = "09";
  static const internalError = "99";

  static Map<String, String> errorMessages = {
    IpnQRCodeErrorCode.success: "00 - Thành công",
    IpnQRCodeErrorCode.orderPaid: "03 - Đơn hàng đã được thanh toán",
    IpnQRCodeErrorCode.errCreateOrder: "04 - Lỗi gạch nợ đơn hàng",
    IpnQRCodeErrorCode.wrongCredentials: "06 - Sai thông tin xác thực",
    IpnQRCodeErrorCode.wrongAmount: "07 - Sai số tiền",
    IpnQRCodeErrorCode.expire: "09 - Hết hạn thanh toán",
    IpnQRCodeErrorCode.internalError: "99 - Lỗi hệ thống"
  };
}
