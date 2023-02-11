import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillingZaloCheckOrderController extends GetxController {
  TextEditingController? customerCodeTextFieldController =
      TextEditingController();

  var isButtonDisabled = true.obs;

  @override
  void onInit() {
    super.onInit();

    customerCodeTextFieldController?.addListener(() {
      if (customerCodeTextFieldController!.text.isNotEmpty) {
        isButtonDisabled.value = false;
      } else {
        isButtonDisabled.value = true;
      }
    });
  }
}
