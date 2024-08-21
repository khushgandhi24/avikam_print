// import 'package:avikam_print_app/views/auth/log_in.dart';
import 'package:avikam_print_app/views/home/scan_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:printing/printing.dart';

class ApiService extends ChangeNotifier {
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
  }

  void resetAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', "");
    prefs.setString('userID', "");
    prefs.setString('awbno', "");
  }

  Future<void> getBase64(String awb, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString('userID');
    String? token = prefs.getString('token');
    String? awb = prefs.getString('awbno');

    debugPrint("Call Start");

    try {
      final res = await Dio()
          .post('http://office11.busisoft.in//api/v1/Awbentry/PrintPDF', data: {
        "AWBNO": awb,
        "Type": "ms",
        "UserID": userid,
        "Token": token,
        "FromWhere": "Mobile",
      });
      // if (res.data is Map<String, dynamic>) {
      //   ScanResponse scres = ScanResponse.fromJson(res.data);
      //   // debugPrint(scres.response); // This will print the base64 string
      // } else {
      //   debugPrint('Unexpected response type: ${res.data.runtimeType}');
      // }
      ScanResponse scres = ScanResponse.fromJson(res.data);
      // debugPrint(res.data.toString());
      // setbase64(scres.response);
      // debugPrint(scres.response);
      if (!context.mounted) return;
      Printer? pri = await Printing.pickPrinter(context: context);
      debugPrint(pri.toString());
      base64ToPdf(scres.response, "test");
      prefs.setString('awbno', '');
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      // resetAll();
      // if (!context.mounted) return;
      // return showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: const Text(
      //           'Session Timed Out!',
      //           textAlign: TextAlign.center,
      //         ),
      //         content: SizedBox(
      //           height: MediaQuery.sizeOf(context).height * 0.05,
      //           width: MediaQuery.sizeOf(context).width * 0.2,
      //           child: const Text(
      //             'Please log in again!',
      //             textAlign: TextAlign.center,
      //           ),
      //         ),
      //         actions: [
      //           TextButton(
      //               onPressed: () {
      //                 Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) => const LogIn()));
      //               },
      //               child: const Text('Retry Login'))
      //         ],
      //         actionsAlignment: MainAxisAlignment.center,
      //       );
      //     });
    }
  }

  Future<void> base64ToPdf(String base64String, String fileName) async {
    var bytes = base64Decode(base64String);
    debugPrint(bytes.toString());
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$fileName.pdf");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    // await Printing.layoutPdf(onLayout: (_) => bytes.buffer.asUint8List());
    await Printing.directPrintPdf(
        printer: const Printer(url: "3R20P-C8E2"),
        onLayout: (format) => bytes.buffer.asUint8List());
    // await OpenFilex.open("${output.path}/$fileName.pdf");
  }
}
