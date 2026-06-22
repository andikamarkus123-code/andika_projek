import '../../main_nav/screens/main_screen.dart';
import '../services/auth_api_service.dart';
import '../services/auth_session.dart';

import 'package:flutter/material.dart';

class WebCreatePasswordScreen extends StatefulWidget {
  const WebCreatePasswordScreen({super.key});

  @override
  State<WebCreatePasswordScreen> createState() => _WebCreatePasswordScreenState();
}

class _WebCreatePasswordScreenState extends State<WebCreatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // --- Fungsi Sinkronisasi Data Registrasi Akhir ke Database ---
  void _handleFinalRegister() async {
    String pass = _passwordController.text.trim();
    if (pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak boleh kosong")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Eksekusi pendaftaran via API HTTP Post ke Laragon
      final res = await AuthApiService.registerUser(
        AuthSession.currentRegisterPhone, 
        pass,
      );

      if (res['success'] == true) {
        // 2. Bersihkan sesi nomor pendaftaran setelah data tersimpan permanen
        AuthSession.currentRegisterPhone = "";

        // 3. Alihkan ke MainScreen (ResponsiveLayout otomatis memicu WebHomeScreen)
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false, // Menghapus history tumpukan screen registrasi
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? "Pendaftaran akun gagal")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal terhubung ke server Laragon")),
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
    _passwordController.dispose(); // Membebaskan penggunaan memori
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color shopeeOrange = Color(0xFFEE4D2D);
    const Color shopeeGreen = Color(0xFF63B931); 

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ==========================================
            // 1. TOP HEADER PUTIH ("Shopee Daftar")
            // ==========================================
            Container(
              height: 84,
              color: Colors.white,
              child: Center(
                child: SizedBox(
                  width: 1040, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/shopee_logo2.png', 
                            height: 45,
                            errorBuilder: (c, e, s) => const Icon(Icons.shopping_bag, size: 45, color: shopeeOrange),
                          ),
                          const SizedBox(width: 10),
                          const Text("Shopee", style: TextStyle(color: shopeeOrange, fontSize: 32, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 15),
                          const Text("Daftar", style: TextStyle(color: Colors.black87, fontSize: 24)),
                        ],
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Text("Butuh bantuan?", style: TextStyle(color: shopeeOrange, fontSize: 14)),
                      )
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ==========================================
            // 2. STEPPER (Langkah 1 dan 2 Aktif)
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepItem(step: "1", title: "Verifikasi no. handphone", isActive: true, color: shopeeGreen),
                _buildStepLine(isActive: true, color: shopeeGreen),
                _buildStepItem(step: "2", title: "Buat password", isActive: true, color: shopeeGreen), 
                _buildStepLine(isActive: false, color: shopeeGreen),
                _buildStepItem(step: "✓", title: "Selesai", isActive: false, color: shopeeGreen, isCheck: true),
              ],
            ),

            const SizedBox(height: 40),

            // ==========================================
            // 3. KARTU BUAT PASSWORD
            // ==========================================
            Container(
              width: 480, 
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
                ],
              ),
              child: Column(
                children: [
                  // --- Judul & Tombol Back ---
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back, color: shopeeOrange, size: 24),
                        ),
                      ),
                      const Text("Atur Password Kamu", style: TextStyle(fontSize: 18, color: Colors.black87)),
                    ],
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // --- Subtitle ---
                  const Text(
                    "Langkah terakhir! Atur password kamu untuk\nmenyelesaikan pendaftaran.", 
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87, fontSize: 14)
                  ),

                  const SizedBox(height: 30),

                  // --- Input Password ---
                  SizedBox(
                    height: 45,
                    child: TextField(
                      controller: _passwordController, // Menautkan controller pengumpul teks sandi
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
                        suffixIcon: Icon(Icons.visibility_off, color: Colors.grey.shade500, size: 20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // --- Syarat Validasi Password ---
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildValidationText("Min. satu karakter huruf kecil"),
                        const SizedBox(height: 8),
                        _buildValidationText("Min. satu karakter huruf besar"),
                        const SizedBox(height: 8),
                        _buildValidationText("8-16 karakter"),
                        const SizedBox(height: 8),
                        _buildValidationText("Hanya huruf, angka, dan tanda baca umum yang dapat\ndigunakan"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ==========================================
                  // TOMBOL DAFTAR (Sudah Aktif, Loading & Mengarah ke MainScreen)
                  // ==========================================
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: shopeeOrange, 
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                      ),
                      onPressed: _isLoading ? null : _handleFinalRegister, 
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "DAFTAR", 
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),

            // ==========================================
            // 4. FOOTER ABU-ABU
            // ==========================================
            Container(
              width: double.infinity,
              height: 300,
              color: const Color(0xFFF5F5F5),
              child: const Center(
                child: Text("Area Footer Web", style: TextStyle(color: Colors.grey)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER: Stepper Bulatan ---
  Widget _buildStepItem({required String step, required String title, required bool isActive, required Color color, bool isCheck = false}) {
    return Column(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: isActive ? color : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: isActive ? color : Colors.grey.shade300, width: 2),
          ),
          child: Center(
            child: isCheck
                ? Icon(Icons.check, color: Colors.grey.shade300, size: 20)
                : Text(step, style: TextStyle(color: isActive ? Colors.white : Colors.grey.shade400, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: TextStyle(color: isActive ? color : Colors.grey.shade400, fontSize: 12)),
      ],
    );
  }

  // --- WIDGET HELPER: Garis Stepper ---
  Widget _buildStepLine({required bool isActive, required Color color}) {
    return Container(
      width: 80,
      height: 1,
      margin: const EdgeInsets.only(top: 17, left: 10, right: 10), 
      color: isActive ? color : Colors.grey.shade300,
    );
  }

  // --- WIDGET HELPER: Teks Validasi Syarat Password ---
  Widget _buildValidationText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
    );
  }
}