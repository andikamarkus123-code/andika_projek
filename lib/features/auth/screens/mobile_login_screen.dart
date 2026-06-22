import 'package:flutter/material.dart';

// ==========================================================
// IMPORT PATH SESUAI STRUKTUR PROYEK ANDA
// ==========================================================
import '../../main_nav/screens/main_screen.dart';
import '../services/auth_api_service.dart';
import 'mobile_register_screen.dart'; // <--- Import halaman register mobile

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false; // Untuk fitur mata (lihat password)

  // --- Fungsi Eksekusi Login ke API ---
  void _handleLogin() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnackBar("Nomor HP/Email dan Password wajib diisi");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await AuthApiService.loginUser(username, password);

      if (res['success'] == true) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false,
          );
        }
      } else {
        if (mounted) _showSnackBar(res['message'] ?? "Login gagal");
      }
    } catch (e) {
      if (mounted) _showSnackBar("Terjadi kesalahan koneksi server");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color shopeeOrange = Color(0xFFEE4D2D);
    
    // Cek apakah kedua form sudah diisi untuk mengaktifkan tombol
    bool isFormFilled = _usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      
      // ==========================================
      // 1. APP BAR (Persis Gambar)
      // ==========================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Garis batas tipis di bawah AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: shopeeOrange, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Log In",
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
              
              // --- Logo Shopee Tengah (Ukuran Diperbesar) ---
              Center(
                child: Image.asset(
                  'assets/images/shopee_logo3.png', // Logo diperbarui ke shopee_logo3
                  height: 85, // <-- Ukuran diperbesar dari 65 menjadi 85
                  errorBuilder: (c, e, s) => const Icon(Icons.shopping_bag, size: 85, color: shopeeOrange),
                ),
              ),
              const SizedBox(height: 40),

              // --- Input 1: Username / No HP ---
              TextField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                onChanged: (value) => setState(() {}), // Trigger perubahan warna tombol
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: "No. Handphone/Email/Username",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: Icon(Icons.person_outline, color: Colors.grey.shade600, size: 26),
                  prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: shopeeOrange, width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 15),

              // --- Input 2: Password ---
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                onChanged: (value) => setState(() {}), // Trigger perubahan warna tombol
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600, size: 24),
                  prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: shopeeOrange, width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  // Menambahkan ikon mata dan tombol Lupa Password di ujung kanan
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined, 
                          color: Colors.grey.shade500, 
                          size: 20
                        ),
                        onPressed: () {
                          setState(() => _isPasswordVisible = !_isPasswordVisible);
                        },
                      ),
                      Container(width: 1, height: 15, color: Colors.grey.shade300), // Garis pemisah
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10)),
                        child: const Text("Lupa?", style: TextStyle(color: Color(0xFF1E64C8), fontSize: 14)),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // --- Tombol Log In Dinamis (Abu-abu / Oranye) ---
              SizedBox(
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFormFilled ? shopeeOrange : const Color(0xFFE8E8E8), 
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: isFormFilled && !_isLoading ? _handleLogin : null,
                  child: _isLoading 
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          "Log In", 
                          style: TextStyle(
                            color: isFormFilled ? Colors.white : Colors.grey.shade400, 
                            fontSize: 16, 
                          )
                        ),
                ),
              ),
              const SizedBox(height: 15),

              // --- Tautan "Log in dengan no. handphone" ---
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {}, // Tambahkan logika jika ingin dialihkan
                  child: const Text(
                    "Log in dengan no. handphone",
                    style: TextStyle(color: Color(0xFF1E64C8), fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- Divider ATAU ---
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text("ATAU", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 25),

              // --- Tombol Sosial Google ---
              _buildSocialButton(
                imagePath: 'assets/images/google.png',
                text: "Log In dengan Google",
                onTap: () {},
              ),
              const SizedBox(height: 15),

              // --- Tombol Sosial Facebook ---
              _buildSocialButton(
                imagePath: 'assets/images/facebook1.png',
                text: "Log In dengan Facebook",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),

      // ==========================================
      // 3. BOTTOM NAVIGATION (Belum punya akun)
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
            const Text("Belum punya akun? ", style: TextStyle(color: Colors.black54, fontSize: 14)),
            InkWell(
              // ---> FUNGSI NAVIGASI KE REGISTER DITAMBAHKAN DI SINI <---
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MobileRegisterScreen()),
                );
              }, 
              child: const Text("Daftar", style: TextStyle(color: Color(0xFF1E64C8), fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Pembantu: Tombol Sosial Media ---
  // Didesain logo nempel di ujung kiri, teks presisi di tengah
  Widget _buildSocialButton({required String imagePath, required String text, required VoidCallback onTap}) {
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
              errorBuilder: (c, e, s) => const Icon(Icons.image, size: 22, color: Colors.grey),
            ),
            
            // Teks tepat berada di tengah kontainer sisa
            Expanded(
              child: Center(
                child: Text(text, style: const TextStyle(color: Colors.black87, fontSize: 15)),
              ),
            ),
            
            // Spacer kosong di kanan agar teks benar-benar rata tengah
            const SizedBox(width: 37), 
          ],
        ),
      ),
    );
  }
}