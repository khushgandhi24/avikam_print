import 'dart:ui';

import 'package:avikam_print_app/service/api_service.dart';
import 'package:avikam_print_app/theme.dart';
import 'package:avikam_print_app/views/auth/log_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => ApiService(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: primaryTheme,
      home: const LogIn(),
    ),
  ));
}
