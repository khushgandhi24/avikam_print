import 'package:avikam_print_app/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  TextEditingController barcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextField(
            // keyboardType: TextInputType.none,
            autofocus: true,
            // showCursor: false,
            onChanged: (value) {
              Provider.of<ApiService>(context, listen: false).setAWB(value);
              debugPrint("AWB No.: $value");
              Provider.of<ApiService>(context, listen: false)
                  .getBase64(value.trim(), context);
              barcodeController.clear();
              debugPrint("AWB No.: $value");
            },
            decoration: const InputDecoration(
                labelText: "Barcode No.",
                labelStyle: TextStyle(color: Color.fromRGBO(1, 0, 1, 1))),
            controller: barcodeController,
          ),
        ),
        // Expanded(
        //   child: IconButton(
        //       onPressed: () {
        //         barcodeController.text = "";
        //       },
        //       icon: const Icon(Icons.close_rounded)),
        // )
      ],
    );
  }
}
