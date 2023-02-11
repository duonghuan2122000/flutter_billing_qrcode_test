import 'package:flutter/material.dart';
import 'package:flutter_billing_qrcode_test/controllers/auth_controller.dart';
import 'package:flutter_billing_qrcode_test/screens/billing_zalo_check_order_screen.dart';
import 'package:flutter_billing_qrcode_test/screens/qrcode_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthController c = Get.put(AuthController());

  Future<bool> confirmCloseApp() async {
    return (await Get.dialog(
          AlertDialog(
            title: const Text("Thoát App"),
            content: const Text("Bạn có chắc muốn thoát app?"),
            actions: [
              TextButton(
                onPressed: () {
                  return Navigator.of(Get.context!).pop(true);
                },
                child: const Text("Đồng ý"),
              ),
              TextButton(
                onPressed: () {
                  return Navigator.of(Get.context!).pop(false);
                },
                child: const Text("Không"),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: confirmCloseApp,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("App Test Billing QRCode"),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const QRCodeScanScreen());
                  },
                  child: const Text("QRCode"),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => BillingZaloCheckOrderScreen());
                  },
                  child: const Text("Thu hộ Zalo"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
