import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScreen;
  final Widget webScreen;

  const ResponsiveLayout({
    super.key,
    required this.mobileScreen,
    required this.webScreen,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Jika lebar layar kurang dari 800 pixel, anggap sebagai Mobile
        if (constraints.maxWidth < 800) {
          return mobileScreen;
        } 
        // Jika layar lebar, tampilkan versi Web
        else {
          return webScreen;
        }
      },
    );
  }
}