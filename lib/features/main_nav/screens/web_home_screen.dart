import 'package:flutter/material.dart';

// Import komponen widget
import '../../../home/widgets/web_top_bar.dart';
import '../../../home/widgets/web_header.dart';
import '../../../home/widgets/web_promo_section.dart';
import '../../../home/widgets/web_voucher_section.dart'; 
import '../../../home/widgets/brand_terlaris_web.dart';

class WebHomeScreen extends StatelessWidget {
  const WebHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color shopeeRed = Color(0xFFD0011B);

    return Scaffold(
      backgroundColor: shopeeRed, 
      body: SingleChildScrollView(
        child: Column(
          children: [
            const WebTopBar(),
            const WebHeader(),

            // ==========================================
            // KONTEN TENGAH (Promo & Voucher)
            // Batas maksimal lebar 1200px
            // ==========================================
            Container(
              width: 1200, 
              padding: const EdgeInsets.only(top: 30, bottom: 60),
              child: const Column(
                children: [
                  WebPromoSection(),
                  SizedBox(height: 60), 
                  WebVoucherSection(),
                ],
              ),
            ),

            // ==========================================
            // BRAND TERLARIS
            // Diletakkan di sini agar background bisa full-width
            // ==========================================
            const BrandTerlarisWeb(),
            
            const SizedBox(height: 100), // Spasi ruang kosong di paling bawah
          ],
        ),
      ),
      
      // ==========================================================
      // TOMBOL MELAYANG (BULAT, WARNA #FA5D2E, DENGAN IMAGE ASSET)
      // ==========================================================
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildFloatingButton(
              imagePath: 'assets/images/share_icon.png', // Sesuaikan nama file
              fallbackIcon: Icons.share,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildFloatingButton(
              imagePath: 'assets/images/arrow_up.png', // Sesuaikan nama file
              fallbackIcon: Icons.arrow_upward,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingButton({
    required String imagePath,
    required IconData fallbackIcon,
    required VoidCallback onTap,
  }) {
    const Color buttonBgColor = Color(0xFFD0011B);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 45, 
        height: 45,
        decoration: const BoxDecoration(
          color: buttonBgColor, // Warna #FA5D2E
          shape: BoxShape.circle, // Membuat tombol bulat sempurna
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: 100, // Disesuaikan agar muat di dalam lingkaran 45x45
            height: 100,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              fallbackIcon,
              color: Colors.white, 
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}