import 'package:avikam_print_app/widgets/barcode_scan.dart';
import 'package:avikam_print_app/widgets/label_preview.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Avikam Label Print App"),
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.09,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.camera_alt_outlined),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BarcodeScanner(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.2,
                ),
                LabelPreview(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
