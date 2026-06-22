import 'package:flutter/material.dart';
import 'mobile_otp_screen.dart';
import 'web_otp_screen.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 850) {
          return const WebOtpScreen();
        } else {
          return const MobileOtpScreen();
        }
      },
    );
  }
}