import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_billing_qrcode_test/screens/home_screen.dart';
import 'package:get/get.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomeScreen(),
    );
  }
}
