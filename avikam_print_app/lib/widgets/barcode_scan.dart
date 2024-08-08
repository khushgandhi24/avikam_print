import 'package:flutter/material.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  TextEditingController barcodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: barcodeController,
    );
  }
}
