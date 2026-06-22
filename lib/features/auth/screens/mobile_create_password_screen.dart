import 'package:flutter/material.dart';

// ==========================================================
// IMPORT PATH YANG SUDAH DISESUAIKAN DENGAN STRUKTUR FOLDER
// ==========================================================
import '../../main_nav/screens/main_screen.dart';
import '../services/auth_api_service.dart';
import '../services/auth_session.dart';

class MobileCreatePasswordScreen extends StatefulWidget {
  const MobileCreatePasswordScreen({super.key});

  @override
  State<MobileCreatePasswordScreen> createState() => _MobileCreatePasswordScreenState();
}

class _MobileCreatePasswordScreenState extends State<MobileCreatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false; // State untuk ikon mata
  bool _isFormValid = false; // State untuk mengaktifkan tombol Daftar

  // --- Fungsi Validasi Syarat Password Real-time ---
  void _validatePassword(String value) {
    bool hasValidLength = value.length >= 8 && value.length <= 16;
    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));

    setState(() {
      _isFormValid = hasValidLength && hasUppercase && hasLowercase;
    });
  }

  // --- Fungsi Eksekusi Pendaftaran ke Database MySQL ---
  void _handleFinalRegister() async {
    String pass = _passwordController.text.trim();
    if (!_isFormValid) return; // Keamanan tambahan

    setState(() => _isLoading = true);

    try {
      // 1. Kirim nomor HP (dari session) dan password ke API Laragon
      final res = await AuthApiService.registerUser(
        AuthSession.currentRegisterPhone, 
        pass,
      );

      if (res['success'] == true) {
        // 2. Bersihkan data session temporer jika pendaftaran sukses
        AuthSession.currentRegisterPhone = "";

        // 3. Masuk ke MainScreen utama (Hapus riwayat halaman pendaftaran)
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false, 
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? "Pendaftaran gagal")),
          );
        }
      }
    } catch (e) {
      // ---> PERBAIKAN: PAKSA ERROR MUNCUL DI LAYAR (DENGAN BACKGROUND MERAH) <---
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error Detail: ${e.toString()}"),
            duration: const Duration(seconds: 10), // Tampil lebih lama agar sempat dibaca
            backgroundColor: Colors.red,
          ),
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
    _passwordController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color shopeeOrange = Color(0xFFEE4D2D);

    return Scaffold(
      backgroundColor: Colors.white,
      
      // ==========================================
      // 1. APP BAR (Sesuai Gambar)
      // ==========================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0, // Merapatkan judul dengan tombol back
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
          ),
        ],
      ),

      // ==========================================
      // 2. KONTEN UTAMA
      // ==========================================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Memaksa konten melebar penuh
            children: [
              
              // --- Judul Tengah ---
              const Text(
                "Atur Password Kamu",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              
              const SizedBox(height: 40),

              // --- Form Input Password ---
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, 
                onChanged: _validatePassword, // Panggil validasi setiap kali mengetik
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600, size: 24), 
                  prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                  
                  // Ikon Mata (Visibility Toggle)
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ), 
                  
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: shopeeOrange, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),

              const SizedBox(height: 12),

              // --- Teks Syarat Password ---
              const Text(
                "Password panjangnya harus 8-16 karakter, dan mengandung min. 1 huruf besar dan 1 huruf kecil karakter.",
                style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.3),
              ),

              const SizedBox(height: 25),

              // ========================================================
              // 3. TOMBOL DAFTAR (Dinamis Abu-abu / Oranye)
              // ========================================================
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid ? shopeeOrange : const Color(0xFFE8E8E8), 
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: _isFormValid && !_isLoading ? _handleFinalRegister : null,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          "Daftar", 
                          style: TextStyle(
                            color: _isFormValid ? Colors.white : Colors.grey.shade400, 
                            fontSize: 16, 
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}