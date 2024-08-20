import 'package:avikam_print_app/widgets/barcode_scan.dart';
// import 'package:avikam_print_app/widgets/label_preview.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void checkPermissions() async {
    bool hasBluetoothPermission = await Permission.bluetooth.isGranted;
    if (hasBluetoothPermission) {
      debugPrint("Has Permission");
    } else {
      await Permission.bluetooth.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Avikam Label Print App"),
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.09,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.camera_alt_outlined),
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: BarcodeScanner(),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.25),
                // const LabelPreview(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
