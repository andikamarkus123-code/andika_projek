import 'package:flutter/material.dart';

// ==========================================================
// IMPORT KEDUA TAMPILAN (Berada di folder yang sama)
// ==========================================================
import 'mobile_register_screen.dart';
import 'web_register_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint 850px sangat pas untuk memisahkan mode Tablet/HP dengan Laptop/Desktop
        if (constraints.maxWidth > 850) {
          return const WebRegisterScreen(); // Tampilan Web (Stateful)
        } else {
          return const MobileRegisterScreen(); // Tampilan Mobile (Stateful)
        }
      },
    );
  }
}