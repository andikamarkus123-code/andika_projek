import 'package:flutter/material.dart';

// ==========================================================
// IMPORT SERVICE API, SESSION MANAGEMENT, DAN GERBANG OTP SMART
// ==========================================================
import '../services/auth_api_service.dart';
import '../services/auth_session.dart';
import 'otp_screen.dart'; // Menggunakan gerbang pintar OtpScreen agar responsif

class WebRegisterScreen extends StatefulWidget {
  const WebRegisterScreen({super.key});

  @override
  State<WebRegisterScreen> createState() => _WebRegisterScreenState();
}

class _WebRegisterScreenState extends State<WebRegisterScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  // --- Fungsi Memicu OTP & Kirim WA via Fonnte ---
  void _handleWebSendOtp() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nomor telepon tidak boleh kosong")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Menembak file send_otp.php di Laragon Anda
      final res = await AuthApiService.sendOtp(phone);

      if (res['success'] == true) {
        // Simpan nomor HP ke session agar bisa dibaca di layar OTP & Password berikutnya
        AuthSession.currentRegisterPhone = phone;

        if (mounted) {
          // Meluncur ke gerbang OtpScreen (Otomatis mendeteksi WebOtpScreen)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OtpScreen(),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? "Gagal mengirim OTP")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Terjadi kesalahan koneksi server Laragon")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose(); // Mencegah memory leak di browser/desktop
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color shopeeOrange = Color(0xFFEE4D2D);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ==========================================
            // BAGIAN UTAMA (BACKGROUND ORANYE)
            // ==========================================
            Container(
              width: double.infinity,
              color: shopeeOrange,
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Center(
                child: SizedBox(
                  width: 1040, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- SISI KIRI: LOGO RAKSASA & TAGLINE ---
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/shopee_logo.png', 
                            height: 140,
                            color: Colors.white, 
                            errorBuilder: (c, e, s) => const Icon(Icons.shopping_bag, size: 140, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Shopee",
                            style: TextStyle(color: Colors.white, fontSize: 54, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Lebih Hemat Lebih Cepat",
                            style: TextStyle(color: Colors.white, fontSize: 26),
                          ),
                        ],
                      ),

                      // --- SISI KANAN: KARTU PENDAFTARAN ---
                      Container(
                        width: 400,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Daftar", style: TextStyle(fontSize: 20, color: Colors.black87)),
                            const SizedBox(height: 30),

                            // Input Nomor Telepon
                            SizedBox(
                              height: 45,
                              child: TextField(
                                controller: _phoneController, // Pasang controller nomor HP pendaftar
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: "Nomor Telepon",
                                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ==========================================
                            // TOMBOL BERIKUTNYA (TERINTEGRASI API & LOADING)
                            // ==========================================
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: shopeeOrange, // Diubah menjadi oranye terang aktif
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                ),
                                onPressed: _isLoading ? null : _handleWebSendOtp, // Kunci tombol jika sedang memuat data
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : const Text("BERIKUTNYA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),

                            const SizedBox(height: 25),

                            // Garis ATAU
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.grey.shade300)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Text("ATAU", style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                                ),
                                Expanded(child: Divider(color: Colors.grey.shade300)),
                              ],
                            ),

                            const SizedBox(height: 25),

                            // Tombol Sosial Media
                            Row(
                              children: [
                                Expanded(
                                  child: _buildWebSocialButton(
                                    imagePath: 'assets/images/facebook.png',
                                    text: 'Facebook',
                                    onTap: () {},
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildWebSocialButton(
                                    imagePath: 'assets/images/google.png',
                                    text: 'Google',
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 35),

                            // Footer Punya Akun
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Punya akun? ", style: TextStyle(color: Colors.black45, fontSize: 14)),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context); // Kembali ke halaman Login utama
                                    }, 
                                    child: const Text("Log In", style: TextStyle(color: shopeeOrange, fontSize: 14, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ==========================================
            // FOOTER (Area Putih/Abu-abu di bawah)
            // ==========================================
            Container(
              width: double.infinity,
              height: 300, 
              color: const Color(0xFFF5F5F5),
              child: const Center(
                child: Text(
                  "Area Footer Web", 
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- Widget Helper untuk Tombol Sosial Media di Web ---
  Widget _buildWebSocialButton({required String imagePath, required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 18, height: 18, fit: BoxFit.contain, errorBuilder: (c,e,s) => const SizedBox()),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(color: Colors.black87, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}