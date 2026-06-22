import 'package:flutter/material.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Memberikan background putih dan sudut sedikit melengkung seperti di gambar
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // 1. Barisan Menu (Bisa di-scroll menyamping)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 5), // Jarak awal
                _buildMenuItem('assets/images/menu_spesial.png', 'Spesial Belanja\nPertama'),
                _buildMenuItem('assets/images/menu_chatgpt.png', 'Gratis ChatGPT'),
                _buildMenuItem('assets/images/menu_pulsa.png', 'Pulsa, Tagihan,\ndan Tiket', badgeText: 'RP1'),
                _buildMenuItem('assets/images/menu_food.png', 'ShopeeFood'),
                _buildMenuItem('assets/images/menu_hadiah.png', 'Hadiah Shopee'),
                const SizedBox(width: 5), // Jarak akhir
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 2. Indikator Scroll (Garis kecil oranye & abu-abu di bawah)
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300, // Warna abu-abu dasar
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.centerLeft,
            child: Container(
              width: 16, // Lebar oranye (setengahnya)
              decoration: BoxDecoration(
                color: const Color(0xFFEE4D2D), // Warna oranye Shopee
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk mencetak masing-masing item menu
  Widget _buildMenuItem(String imagePath, String title, {String? badgeText}) {
    return SizedBox(
      width: 76, // Mengunci lebar agar teks otomatis turun ke baris ke-2 (wrap)
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Stack digunakan agar Badge RP1 bisa menimpa bingkai ikon
          Stack(
            clipBehavior: Clip.none, // Mengizinkan elemen keluar dari batas kotak
            alignment: Alignment.bottomCenter,
            children: [
              // Kotak Bingkai Ikon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200, width: 1.5), // Bingkai abu tipis
                  borderRadius: BorderRadius.circular(14), // Sudut melengkung
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    imagePath,
                    // Fallback jika gambar belum Anda masukkan
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              
              // Badge Merah (RP1) - Hanya muncul jika ada text badge-nya
              if (badgeText != null)
                Positioned(
                  bottom: -6, // Posisinya ditarik ke bawah agar menimpa garis
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD32F2F), // Merah gelap
                      borderRadius: BorderRadius.circular(8),
                      // Garis putih kecil di sekeliling badge agar terpisah dari bingkai ikon
                      border: Border.all(color: Colors.white, width: 1.5), 
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8, // Sangat kecil
                        fontWeight: FontWeight.w900, // Sangat tebal
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Teks di bawah ikon
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2, // Maksimal 2 baris
            style: const TextStyle(
              fontSize: 10, // Ukuran teks dibuat kecil agar muat
              color: Colors.black87,
              height: 1.2, // Jarak antar baris teks dirapatkan
            ),
          ),
        ],
      ),
    );
  }
}