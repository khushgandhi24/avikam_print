import 'package:avikam_print_app/theme.dart';
import 'package:avikam_print_app/views/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

void main() async {
  await Permission.camera.request();
  await Permission.bluetooth.request();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: primaryTheme,
    home: const HomePage(),
  ));
}
