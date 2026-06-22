import 'package:flutter/material.dart';

class WalletSection extends StatelessWidget {
  const WalletSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // --- PERUBAHAN GAYA DI SINI (Menyesuaikan Gaya Menu Section) ---
      // 1. Berikan Margin horizontal agar kotak tidak mentok ke pinggir layar
      margin: const EdgeInsets.symmetric(horizontal: 10),
      
      // 2. Gunakan Decoration untuk membuat kotak putih bulat
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Sudut tumpul sama seperti Menu

        // Opsional: Tambahkan bayangan tipis agar terlihat lebih timbul (elegan)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1), // posisi bayangan
          ),
        ],
      ),
      // -----------------------------------------------------------------

      // Padding dalam Container untuk memberikan ruang bagi konten di dalamnya
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Mengatur jarak merata
        children: [
          // 1. Ikon QRIS (Kiri)
          Image.asset(
            'assets/images/icon_qris.png',
            width: 26, // Dikecilkan sedikit agar lebih proporsional dalam kotak baru
            height: 26,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.qr_code_scanner, color: Colors.redAccent, size: 26),
          ),

          _buildDivider(),

          // 2. ShopeePay
          _buildWalletItem(
            iconPath: 'assets/images/icon_shopeepay.png',
            title: 'ShopeePay',
            subtitle: 'Klaim 90.000',
            subtitleColor: const Color(0xFFEE4D2D), // Warna oranye Shopee
            isSubtitleBold: true,
          ),

          _buildDivider(),

          // 3. Cek-in!
          _buildWalletItem(
            iconPath: 'assets/images/icon_coin.png',
            title: 'Cek-in!',
            subtitle: 'Klaim 25RB!',
            subtitleColor: Colors.grey.shade500,
            isSubtitleBold: false,
          ),

          _buildDivider(),

          // 4. SPayLater
          _buildWalletItem(
            iconPath: 'assets/images/icon_spaylater.png',
            title: 'SPayLater',
            subtitle: 'Diskon 50RB!',
            subtitleColor: Colors.grey.shade500,
            isSubtitleBold: false,
          ),

          _buildDivider(),

          // 5. Ikon Rp (Kanan)
          Image.asset(
            'assets/images/icon_rp.png',
            width: 26,
            height: 26,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.monetization_on, color: Colors.redAccent, size: 26),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membuat garis pemisah vertikal tipis
  Widget _buildDivider() {
    return Container(
      height: 26, // Disesuaikan dengan tinggi ikon baru
      width: 1,   // Ketebalan garis
      color: Colors.grey.shade200, // Warna abu-abu yang lebih pudar
    );
  }

  // Fungsi khusus untuk merakit Ikon + Judul + Subjudul agar rapi
  Widget _buildWalletItem({
    required String iconPath,
    required String title,
    required String subtitle,
    required Color subtitleColor,
    required bool isSubtitleBold,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Memastikan kolom tidak mengambil ruang vertikal berlebih
      children: [
        // Baris Pertama: Ikon kecil + Teks Judul
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 14, // Ukuran ikon judul disesuaikan
              height: 14,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_balance_wallet, size: 14),
            ),
            const SizedBox(width: 4), // Jarak antara ikon dan teks
            Text(
              title,
              style: const TextStyle(
                fontSize: 12, // Ukuran teks judul disesuaikan
                fontWeight: FontWeight.w600, // Ketebalan teks judul (bold)
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2), // Jarak antara judul dan subjudul
        // Baris Kedua: Teks Subjudul
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 10, // Ukuran teks subjudul disesuaikan
            fontWeight: isSubtitleBold ? FontWeight.bold : FontWeight.w500,
            color: subtitleColor,
          ),
        ),
      ],
    );
  }
}