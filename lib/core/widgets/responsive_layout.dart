import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget webLayout;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    required this.webLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Jika lebar layar di bawah 800px, tampilkan versi Mobile
        if (constraints.maxWidth < 800) {
          return mobileLayout;
        } 
        // Jika 800px atau lebih, tampilkan versi Web
        else {
          return webLayout;
        }
      },
    );
  }
}