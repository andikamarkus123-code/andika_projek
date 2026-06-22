import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4), // Dibuat sedikit lebih siku sesuai gambar
      ),
      // MENGGUNAKAN ROW AGAR MUDAH DISEJAJARKAN KE TENGAH
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Ini kunci agar semua sejajar vertikal
        children: [
          
          // ==========================================
          // 1. Icon Search dari Assets
          // ==========================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset(
              'assets/images/search.png', 
              width: 18, // Ukuran disesuaikan agar proporsional
              height: 18,
              errorBuilder: (c, e, s) => const Icon(Icons.search, color: Colors.grey, size: 20),
            ),
          ),
          
          // ==========================================
          // 2. Teks Hint di Tengah (Expanded agar mendorong icon kamera ke ujung)
          // ==========================================
          const Expanded(
            child: Text(
              'Kemeja Burgundy Pria',
              style: TextStyle(
                color: Color(0xFFEE4D2D), // Warna merah/oranye Shopee
                fontSize: 13,
                fontWeight: FontWeight.w400, // Tidak terlalu tebal
              ),
            ),
          ),

          // ==========================================
          // 3. Icon Kamera dari Assets
          // ==========================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset(
              'assets/images/kamera.png', 
              width: 22, // Ukuran disesuaikan agar proporsional
              height: 22,
              errorBuilder: (c, e, s) => const Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 20),
            ),
          ),
          
        ],
      ),
    );
  }
}