import 'package:avikam_print_app/service/api_service.dart';
import 'package:avikam_print_app/service/print_scan.dart';
import 'package:avikam_print_app/theme.dart';
import 'package:avikam_print_app/views/auth/log_in.dart';
// import 'package:avikam_print_app/views/home/image_view.dart';
import 'package:avikam_print_app/widgets/barcode_scan.dart';
// import 'package:avikam_print_app/widgets/label_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // void checkPermissions() async {
  //   bool hasBluetoothPermission = await Permission.bluetooth.isGranted;
  //   if (hasBluetoothPermission) {
  //     debugPrint("Has Permission");
  //   } else {
  //     await Permission.bluetooth.request();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Label Print",
          style: TextStyle(color: AppColors.tertiaryColor),
        ),
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.09,
        leading: IconButton(
            onPressed: () {
              Provider.of<ApiService>(context, listen: false).resetAll();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LogIn()));
            },
            icon: Icon(
              Icons.logout_rounded,
              color: AppColors.surfaceColor,
            )),
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
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BlePrint()));
                    },
                    child: const Text(
                      "Connect to Bluetooth Printer",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                // SizedBox(height: MediaQuery.sizeOf(context).height * 0.25),
                // const ImageView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
