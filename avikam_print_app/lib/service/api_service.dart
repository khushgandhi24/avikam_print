// import 'package:avikam_print_app/views/auth/log_in.dart';
// import 'dart:typed_data';
import 'package:avikam_print_app/views/auth/log_in.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:bluetooth_print_plus/tsp_command.dart';
// import 'package:bluetooth_print_plus/bluetooth_print_model.dart';
import 'package:avikam_print_app/views/home/scan_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
// import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart';
// import 'package:pdfx/pdfx.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:printing/printing.dart';
import 'package:pdf_image_renderer/pdf_image_renderer.dart';
// import 'package:pdf_render/pdf_render.dart';

class ApiService extends ChangeNotifier {
  final _bluetoothPrintPlus = BluetoothPrintPlus.instance;
  Uint8List? imaeg;
  String? _awb = "";
  String? get awb => _awb;

  void setImaeg(Uint8List data) {
    imaeg = data;
  }

  void setToken(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', val);
  }

  void setUserID(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userID', val);
  }

  void setAWB(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('awbno', val);
    _awb = val;
    notifyListeners();
  }

  void resetAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', "");
    prefs.setString('userID', "");
    prefs.setString('awbno', "");
  }

  // Future<void> getAWB() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? awbno = prefs.getString('awbno');
  //   _awb = awbno;
  // }

  Future<void> getBase64(String awb, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString('userID');
    String? token = prefs.getString('token');
    String? awb = prefs.getString('awbno');

    debugPrint("Call Start");
    if (await checkIsConnected()) {
      try {
        final res = await Dio().post(
            'https://xpresion.gpsupplychain.com/api/v1/PickupAPI/PickupInscanPrintPDF',
            data: {
              "Token": token,
              "AWBNo": awb,
              "UserID": userid,
              "Location_Name": "",
              "Events": "Shipment Pickuped1",
            });
        // if (res.data is Map<String, dynamic>) {
        //   ScanResponse scres = ScanResponse.fromJson(res.data);
        //   // debugPrint(scres.response); // This will print the base64 string
        // } else {
        //   debugPrint('Unexpected response type: ${res.data.runtimeType}');
        // }
        ScanResponse scres = ScanResponse.fromJson(res.data);
        if (scres.response.response == "Invalid User ID / Password") {
          if (!context.mounted) return;
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('Session Expired'),
                  content: const Text('Please log in again!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setAWB("");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LogIn()));
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                  actionsAlignment: MainAxisAlignment.center,
                );
              });
        }
        if (scres.response.response.endsWith("..!")) {
          if (!context.mounted) return;
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('$awb does not exist'),
                  content: const Text('Please enter a valid AWB Number!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setAWB("");
                        Navigator.pop(ctx);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                  actionsAlignment: MainAxisAlignment.center,
                );
              });
        }
        // debugPrint(res.data.toString());
        // setbase64(scres.response);
        // debugPrint(scres.response);
        if (!context.mounted) return;
        // Printer? pri = await Printing.pickPrinter(context: context);
        // debugPrint(pri.toString());
        base64ToPdf(scres.response.response, "test");
        prefs.setString('awbno', '');
      } catch (e) {
        debugPrint("Error: ${e.toString()}");
        // resetAll();
        if (!context.mounted) return;
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Error calling API, please logout and try again. If error persists, please contact administrator',
                  textAlign: TextAlign.center,
                ),
                content: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.05,
                  width: MediaQuery.sizeOf(context).width * 0.2,
                  child: const Text(
                    'Please log in again!',
                    textAlign: TextAlign.center,
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LogIn()));
                      },
                      child: const Text('Retry Login'))
                ],
                actionsAlignment: MainAxisAlignment.center,
              );
            });
      }
    } else {
      if (!context.mounted) return;
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('No internet connection'),
              content: const Text('Please reconnect and try again!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text('Close'),
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
            );
          });
    }
  }

  Future<void> base64ToPdf(String base64String, String fileName) async {
    var bytes = base64Decode(base64String);
    debugPrint(bytes.toString());
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$fileName.pdf");
    await file.writeAsBytes(bytes.buffer.asUint8List());

    final pdf = PdfImageRendererPdf(path: "${output.path}/$fileName.pdf");
    await pdf.open();
    await pdf.openPage(pageIndex: 0);
    // final size = await pdf.getPageSize(pageIndex: 0);
    final img = await pdf.renderPage(
      pageIndex: 0,
      x: 0,
      y: 0,
      width: 350, // you can pass a custom size here to crop the image
      height: 500, //~/ 3, // you can pass a custom size here to crop the image
      scale: 2, // increase the scale for better quality (e.g. for zooming)
      background: Colors.white,
    );
    await pdf.closePage(pageIndex: 0);
    pdf.close();
    // final document = await PdfDocument.openFile("${output.path}/$fileName.pdf");
    // PdfPage page = await document.getPage(1);
    // PdfPageImage? pageImage = await page.render(width: 80, height: 40);
    // final ByteData bytese = await rootBundle.load("assets/logo.png");
    final Uint8List image = img!; //bytese.buffer.asUint8List();
    // setImaeg(image);
    // notifyListeners();

    final tscCommand = TscCommand();
    await tscCommand.cleanCommand();
    await tscCommand.cls();
    await tscCommand.density(12);
    await tscCommand.size(width: 75, height: 75);
    // await tscCommand.gap(1); // Gap causes a fatal exception: main and terminates the app
    await tscCommand.image(image: image, x: 0, y: 0);
    // await tscCommand.text(content: "0,0", x: 0, y: 0);
    await tscCommand.print(1);
    final cmd = await tscCommand.getCommand();
    if (cmd == null) return;
    setAWB("Label sent to printer");
    try {
      BluetoothPrintPlus.instance.write(cmd);
    } catch (e) {
      setAWB("Printer Error");
    }
    notifyListeners();
  }

  // Future<void> printPDF(Uint8List bytes) async {}

  Future<bool> checkIsConnected() async {
    try {
      final res = await InternetAddress.lookup('google.com');
      if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException {
      return false;
    }
  }
}
