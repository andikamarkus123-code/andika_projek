import 'package:flutter/material.dart';
import 'mobile_login_screen.dart';
import 'web_login_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Disamakan menjadi 850px agar sinkron dengan alur Register, OTP, dan Password
        if (constraints.maxWidth > 850) {
          return const WebLoginScreen(); // Tampilan Web/Desktop
        } else {
          return const MobileLoginScreen(); // Tampilan Mobile/Smartphone
        }
      },
    );
  }
}