import 'package:flutter/material.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita hapus SizedBox dan ListView, ganti dengan Padding agar margin kiri-kanan pas
    return Padding(
      // Memberikan margin horizontal 10 agar sejajar dengan WalletSection dan MenuSection
      padding: const EdgeInsets.symmetric(horizontal: 10),
      
      // Gunakan Container tunggal untuk satu banner saja
      child: Container(
        // Kita hapus lebar tetap (width: 300), 
        // sehingga Container akan otomatis memenuhi lebar layar ponsel minus padding di atas.
        
        height: 120, // Kita pertahankan tinggi agar proporsional dengan gambar
        
        decoration: BoxDecoration(
          color: Colors.orangeAccent, // Warna dasar jika gambar belum dimasukkan
          borderRadius: BorderRadius.circular(8), // Sudut tumpul konsisten dengan UI lain
          
          image: const DecorationImage(
            image: AssetImage('assets/images/banner_diskon.png'),
            fit: BoxFit.cover, // Memastikan gambar memenuhi kotak tanpa merusak rasio
          ),
          
          // Tambahkan sedikit bayangan tipis agar gaya konsisten dengan "kotak putih" Menu/Wallet
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1), // posisi bayangan
            ),
          ],
        ),
      ),
    );
  }
}