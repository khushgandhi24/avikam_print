import 'package:avikam_print_app/theme.dart';
import 'package:avikam_print_app/views/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: primaryTheme,
    home: const HomePage(),
  ));
}
