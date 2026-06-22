import 'package:flutter/material.dart';

// ==========================================================
// IMPORT PATH SERVICE API, SESSION, DAN GERBANG OTP SMART
// ==========================================================
import '../services/auth_api_service.dart';
import '../services/auth_session.dart';
import 'otp_screen.dart'; // Menggunakan gerbang pintar OtpScreen agar responsif

class MobileRegisterScreen extends StatefulWidget {
  const MobileRegisterScreen({super.key});

  @override
  State<MobileRegisterScreen> createState() => _MobileRegisterScreenState();
}

class _MobileRegisterScreenState extends State<MobileRegisterScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isShopeePayActive = false; // State untuk checkbox ShopeePay

  // --- Fungsi Memicu OTP & Kirim WA via Fonnte ---
  void _handleSendOtp() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showSnackBar("Nomor telepon tidak boleh kosong");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Menembak file send_otp.php di Laragon Anda
      final res = await AuthApiService.sendOtp(phone);

      if (res['success'] == true) {
        // Simpan nomor HP ke session biar bisa dibaca di layar OTP & Password
        AuthSession.currentRegisterPhone = phone;

        if (mounted) {
          // Meluncur ke gerbang OtpScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OtpScreen(),
            ),
          );
        }
      } else {
        if (mounted) {
          _showSnackBar(res['message'] ?? "Gagal mengirim OTP");
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar("Terjadi kesalahan koneksi server");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _phoneController.dispose(); // Menghindari kebocoran memori
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color shopeeOrange = Color(0xFFEE4D2D);
    
    // Cek apakah form telepon sudah diisi untuk mengaktifkan tombol Lanjut
    bool isPhoneFilled = _phoneController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      
      // ==========================================
      // 1. APP BAR (Sesuai Gambar)
      // ==========================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: shopeeOrange, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Daftar",
          style: TextStyle(color: Colors.black87, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: shopeeOrange, size: 26),
            onPressed: () {},
          )
        ],
      ),

      // ==========================================
      // 2. KONTEN UTAMA
      // ==========================================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // --- Logo Shopee Tengah ---
              Center(
                child: Image.asset(
                  'assets/images/shopee_logo3.png', // Pastikan nama aset logo Anda sesuai
                  height: 85,
                  errorBuilder: (c, e, s) => const Icon(Icons.shopping_bag, size: 85, color: shopeeOrange),
                ),
              ),
              const SizedBox(height: 40),

              // --- Input Form Telepon ---
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onChanged: (value) => setState(() {}), // Trigger perubahan warna tombol
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: "Telepon",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                  prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey.shade600, size: 26),
                  prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: shopeeOrange, width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 20),

              // --- Tombol Lanjut (Warna Dinamis) ---
              SizedBox(
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPhoneFilled ? shopeeOrange : const Color(0xFFE8E8E8), // Oranye jika terisi, abu-abu jika kosong
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: isPhoneFilled && !_isLoading ? _handleSendOtp : null,
                  child: _isLoading 
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          "Lanjut", 
                          style: TextStyle(
                            color: isPhoneFilled ? Colors.white : Colors.grey.shade400, 
                            fontSize: 16, 
                          )
                        ),
                ),
              ),
              const SizedBox(height: 15),

              // --- Checkbox ShopeePay ---
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _isShopeePayActive,
                      activeColor: shopeeOrange,
                      side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                      onChanged: (bool? value) {
                        setState(() {
                          _isShopeePayActive = value ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Aktifkan ShopeePay sekarang",
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  const SizedBox(width: 5),
                  Icon(Icons.help_outline, color: Colors.grey.shade500, size: 16),
                ],
              ),
              const SizedBox(height: 35),

              // --- Divider ATAU ---
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text("ATAU", style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 25),

              // --- Tombol Sosial Google ---
              _buildSocialButton(
                imagePath: 'assets/images/google.png',
                text: "Daftar dengan Google",
                onTap: () {},
              ),
              const SizedBox(height: 12),

              // --- Tombol Sosial Facebook ---
              _buildSocialButton(
                imagePath: 'assets/images/facebook1.png',
                text: "Daftar dengan Facebook",
                onTap: () {},
              ),
              const SizedBox(height: 12),

              // --- Tombol Sosial WhatsApp ---
              _buildSocialButton(
                imagePath: 'assets/images/whatsapp.png',
                text: "Daftar dengan WhatsApp",
                onTap: () {},
                fallbackIcon: Icons.wechat,
                fallbackColor: const Color(0xFF25D366)
              ),
            ],
          ),
        ),
      ),

      // ==========================================
      // 3. BOTTOM NAVIGATION (Sudah punya akun)
      // ==========================================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sudah punya akun? ", style: TextStyle(color: Colors.black54, fontSize: 14)),
            InkWell(
              onTap: () => Navigator.pop(context), // Kembali ke halaman Login Mobile
              child: const Text("Login", style: TextStyle(color: Color(0xFF1E64C8), fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Pembantu: Tombol Sosial Media (Ikon Kiri, Teks Tengah) ---
  Widget _buildSocialButton({
    required String imagePath, 
    required String text, 
    required VoidCallback onTap,
    IconData fallbackIcon = Icons.image,
    Color fallbackColor = Colors.grey,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            // Ikon menempel di kiri
            const SizedBox(width: 15),
            Image.asset(
              imagePath, 
              height: 22, 
              width: 22,
              errorBuilder: (c, e, s) => Icon(fallbackIcon, size: 24, color: fallbackColor),
            ),
            
            // Teks tepat berada di tengah kontainer sisa
            Expanded(
              child: Center(
                child: Text(text, style: const TextStyle(color: Colors.black87, fontSize: 15)),
              ),
            ),
            
            // Spacer kosong di kanan agar teks benar-benar rata tengah proporsional
            const SizedBox(width: 37), 
          ],
        ),
      ),
    );
  }
}