import 'package:flutter/material.dart';
import 'responsive_layout.dart';
import 'features/auth/screens/web_login_screen.dart';
import 'features/auth/screens/mobile_login_screen.dart'; // Pastikan Anda membuat file ini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopee Clone',
      debugShowCheckedModeBanner: false,
      home: ResponsiveLayout(
        // Arahkan ke file UI khusus HP Anda
        mobileScreen: const MobileLoginScreen(), 
        // Arahkan ke file UI khusus Web Anda yang tadi kita buat
        webScreen: const WebLoginScreen(initialIsLogin: true), 
      ),
    );
  }
}