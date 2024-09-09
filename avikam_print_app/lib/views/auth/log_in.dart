import 'dart:io';

import 'package:avikam_print_app/service/api_service.dart';
import 'package:avikam_print_app/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:avikam_print_app/views/auth/login_model.dart';
import 'package:avikam_print_app/views/home/home.dart';
import 'package:provider/provider.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final userIDController = TextEditingController();
  final passController = TextEditingController();

  bool isLoading = false;

  void logIn(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    Provider.of<ApiService>(context, listen: false).resetAll();
    String userID = userIDController.text.trim();
    String pass = passController.text.trim();

    debugPrint("User ID: $userID");
    debugPrint("Pass: $pass");
    if (await Provider.of<ApiService>(context, listen: false)
        .checkIsConnected()) {
      try {
        final res = await Dio().post(
            'https://xpresion.gpsupplychain.com/api/v1/LoginAPI/Login',
            data: {
              "UserID": userID,
              "Password": pass,
              "ApplicationType": "C",
            });
        Login user = Login.fromJson(res.data);
        if (user.response.statusCode == "0") {
          if (!context.mounted) return;
          Provider.of<ApiService>(context, listen: false)
              .setToken(user.response.token);
          Provider.of<ApiService>(context, listen: false).setUserID(userID);
          setState(() {
            isLoading = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const HomePage()));
          userIDController.clear();
          passController.clear();
        } else {
          throw SocketException;
        }
      } catch (e) {
        debugPrint('Error: $e');
        setState(() {
          isLoading = false;
        });
        if (!context.mounted) return;
        Provider.of<ApiService>(context, listen: false).resetAll();
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('Invalid login credentials'),
                content: const Text('Please try again'),
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
    } else {
      setState(() {
        isLoading = false;
      });
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userIDController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Label Scanner",
            style: TextStyle(
                fontSize: 18,
                color: AppColors.tertiaryColor,
                fontWeight: FontWeight.bold)),
        toolbarHeight: kToolbarHeight + 10,
      ),
      backgroundColor: AppColors.surfaceColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Log In",
                  style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: userIDController,
                  decoration: const InputDecoration(
                      labelText: "User ID",
                      labelStyle: TextStyle(fontSize: 12)),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: passController,
                  decoration: const InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(fontSize: 12)),
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                            AppColors.secondaryColor)),
                    onPressed: () {
                      logIn(context);
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(color: AppColors.surfaceColor),
                    )),
                const SizedBox(
                  height: 24,
                ),
                (isLoading)
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: CircularProgressIndicator(
                          value: null,
                          color: AppColors.tertiaryColor,
                        ))
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
