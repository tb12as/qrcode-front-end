import 'package:flutter/material.dart';
import 'package:qrcode/components/generate_qr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Code Generator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const GenerateQRComponent(title: 'QR Code Generator'),
    );
  }
}
