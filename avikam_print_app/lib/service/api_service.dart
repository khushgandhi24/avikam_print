import 'package:avikam_print_app/views/home/scan_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ApiService extends ChangeNotifier {
  String _token = "";
  String get token => _token;

  String _userID = "";
  String get userID => _userID;

  String _awbno = "";
  String get awbno => _awbno;

  String _base64 = "";
  String get base64 => _base64;

  void setToken(String val) {
    _token = val;
  }

  void setUserID(String val) {
    _userID = val;
  }

  void setAWB(String val) {
    _awbno = val;
  }

  void setbase64(String val) {
    _base64 = val;
  }

  void resetAll() {
    setAWB("");
    setToken("");
    setUserID("");
    setbase64("");
  }

  Future<void> getBase64(String awb) async {
    debugPrint("Call Start");
    try {
      final res = await Dio()
          .post('http://office11.busisoft.in//api/v1/Awbentry/PrintPDF', data: {
        "AWBNO": "300003672",
        "Type": "ms",
        "UserID": "Vidhi",
        "Token": "lroy55bm1l4au5ndqqpg2l3b",
        "FromWhere": "Mobile",
      });
      if (res.data is Map<String, dynamic>) {
        ScanResponse scres = ScanResponse.fromJson(res.data);
        debugPrint(scres.response); // This will print the base64 string
      } else {
        debugPrint('Unexpected response type: ${res.data.runtimeType}');
      }
      ScanResponse scres = ScanResponse.fromJson(res.data);
      // debugPrint(res.data.toString());
      // setbase64(scres.response);
      // debugPrint(scres.response);
      base64ToPdf(scres.response, "test");
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
    }
  }

  Future<void> base64ToPdf(String base64String, String fileName) async {
    var bytes = base64Decode(base64String);
    debugPrint(bytes.toString());
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$fileName.pdf");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    await OpenFilex.open("${output.path}/$fileName.pdf");
  }
}
