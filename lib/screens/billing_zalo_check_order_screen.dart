import 'package:flutter/material.dart';
import 'package:flutter_billing_qrcode_test/controllers/billing_zalo_check_order_controller.dart';
import 'package:get/get.dart';

class BillingZaloCheckOrderScreen extends StatelessWidget {
  BillingZaloCheckOrderScreen({super.key});

  final BillingZaloCheckOrderController _controller =
      Get.put(BillingZaloCheckOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Billing Zalo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller.customerCodeTextFieldController,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Mã học sinh",
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8.0),
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: _controller.isButtonDisabled.value ? null : () {},
                  child: const Text("Truy vấn"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
