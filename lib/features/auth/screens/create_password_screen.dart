import 'package:flutter/material.dart';

// ==========================================================
// IMPORT SESUAIKAN DENGAN STRUKTUR FOLDER ANDA
// ==========================================================
import '../../main_nav/screens/main_screen.dart';
import '../services/auth_api_service.dart';
import '../services/auth_session.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false; // Fitur untuk melihat/menyembunyikan password

  // --- State Validasi Password Real-time ---
  bool _hasLowercase = false;
  bool _hasUppercase = false;
  bool _hasValidLength = false;

  // Mengecek syarat password setiap kali user mengetik
  void _checkPasswordRules(String value) {
    setState(() {
      _hasLowercase = value.contains(RegExp(r'[a-z]'));
      _hasUppercase = value.contains(RegExp(r'[A-Z]'));
      _hasValidLength = value.length >= 8 && value.length <= 16;
    });
  }

  // --- Fungsi Sinkronisasi Data Registrasi Akhir ke Database ---
  void _handleFinalRegister() async {
    String pass = _passwordController.text.trim();
    
    // Pastikan semua syarat terpenuhi sebelum bisa mendaftar
    if (!_hasLowercase || !_hasUppercase || !_hasValidLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pastikan password memenuhi semua syarat")),
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

        // 3. Alihkan ke MainScreen
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
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color shopeeOrange = Color(0xFFEE4D2D);
    const Color shopeeGreen = Color(0xFF63B931); 
    
    // Tombol aktif hanya jika semua syarat password terpenuhi
    bool isFormValid = _hasLowercase && _hasUppercase && _hasValidLength;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ==========================================
            // 1. TOP HEADER PUTIH 
            // ==========================================
            _buildTopHeader(shopeeOrange),

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
                      const Text("Atur Password Kamu", style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // --- Subtitle ---
                  const Text(
                    "Langkah terakhir! Atur password kamu untuk\nmenyelesaikan pendaftaran.", 
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 14)
                  ),

                  const SizedBox(height: 30),

                  // --- Input Password ---
                  SizedBox(
                    height: 45,
                    child: TextField(
                      controller: _passwordController, 
                      obscureText: !_isPasswordVisible,
                      onChanged: _checkPasswordRules, // Jalankan fungsi cek password
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off, 
                            color: Colors.grey.shade500, 
                            size: 20
                          ),
                          onPressed: () {
                            setState(() => _isPasswordVisible = !_isPasswordVisible);
                          },
                        ),
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
                        _buildValidationText("Min. satu karakter huruf kecil", _hasLowercase),
                        const SizedBox(height: 8),
                        _buildValidationText("Min. satu karakter huruf besar", _hasUppercase),
                        const SizedBox(height: 8),
                        _buildValidationText("8-16 karakter", _hasValidLength),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ==========================================
                  // TOMBOL DAFTAR 
                  // ==========================================
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFormValid ? shopeeOrange : const Color(0xFFF4856E), 
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                      ),
                      onPressed: isFormValid && !_isLoading ? _handleFinalRegister : null, 
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
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
            // 4. FOOTER LENGKAP SHOPEE
            // ==========================================
            _buildWebFooter(),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // WIDGET HELPER UI
  // ==========================================================

  Widget _buildTopHeader(Color shopeeOrange) {
    return Container(
      height: 84,
      decoration: const BoxDecoration(
        color: Colors.white, 
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5), width: 2))
      ),
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
                    errorBuilder: (c, e, s) => Icon(Icons.shopping_bag, size: 45, color: shopeeOrange),
                  ),
                  const SizedBox(width: 10),
                  Text("Shopee", style: TextStyle(color: shopeeOrange, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 15),
                  const Text("Daftar", style: TextStyle(color: Colors.black87, fontSize: 24)),
                ],
              ),
              InkWell(
                onTap: () {},
                child: Text("Butuh bantuan?", style: TextStyle(color: shopeeOrange, fontSize: 14)),
              )
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildStepLine({required bool isActive, required Color color}) {
    return Container(
      width: 80,
      height: 1,
      margin: const EdgeInsets.only(top: 17, left: 10, right: 10), 
      color: isActive ? color : Colors.grey.shade300,
    );
  }

  // Menambahkan parameter 'isValid' untuk mengubah warna centang/teks secara real-time
  Widget _buildValidationText(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.radio_button_unchecked, 
          color: isValid ? const Color(0xFF63B931) : Colors.grey.shade400, 
          size: 16
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: isValid ? const Color(0xFF63B931) : Colors.grey.shade500, 
            fontSize: 12
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // WIDGET FOOTER SHOPEE
  // ==========================================================
  Widget _buildWebFooter() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F5F5), 
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Center(
        child: SizedBox(
          width: 1040, 
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildFooterTextColumn("Layanan Pelanggan", [
                  "Bantuan", "Metode Pembayaran", "ShopeePay", "Koin Shopee",
                  "Lacak Pesanan Pembeli", "Lacak Pengiriman Penjual", "Gratis Ongkir",
                  "Pengembalian Barang & Dana", "Garansi Shopee"
                ]),
              ),
              Expanded(
                flex: 2,
                child: _buildFooterTextColumn("Jelajahi Shopee", [
                  "Tentang Kami", "Karir", "Kebijakan", "Kebijakan Privasi Shopee",
                  "Blog", "Shopee Mall", "Seller Centre", "Flash Sale", "Kontak Media"
                ]),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildAssetBox('assets/images/pay_alfamart.png', "Alfamart"),
                        _buildAssetBox('assets/images/pay_alfamidi.png', "Alfamidi"),
                        _buildAssetBox('assets/images/pay_bca.png', "BCA"),
                        _buildAssetBox('assets/images/pay_bni.png', "BNI"),
                        _buildAssetBox('assets/images/pay_bri.png', "BRI"),
                        _buildAssetBox('assets/images/pay_bsi.png', "BSI"),
                        _buildAssetBox('assets/images/pay_cimb.png', "CIMB"),
                        _buildAssetBox('assets/images/pay_mandiri.png', "Mandiri"),
                        _buildAssetBox('assets/images/pay_indomaret.png', "Indomaret"),
                        _buildAssetBox('assets/images/pay_jcb.png', "JCB"),
                        _buildAssetBox('assets/images/pay_mastercard.png', "MasterCard"),
                        _buildAssetBox('assets/images/pay_spay.png', "SPay"),
                        _buildAssetBox('assets/images/pay_visa.png', "Visa"),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Ikuti Kami", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    const SizedBox(height: 20),
                    _buildSocialLink('assets/images/soc_fb.png', "Facebook", Icons.facebook),
                    _buildSocialLink('assets/images/soc_ig.png', "Instagram", Icons.camera_alt),
                    _buildSocialLink('assets/images/soc_tw.png', "Twitter", Icons.flutter_dash),
                    _buildSocialLink('assets/images/soc_in.png', "LinkedIn", Icons.work),
                    _buildSocialLink('assets/images/soc_kampus.png', "Kampus Shopee", Icons.school),
                    
                    const SizedBox(height: 30),
                    const Text("Keamanan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    const SizedBox(height: 15),
                    Container(
                      height: 40,
                      width: 90,
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300)),
                      child: Image.asset(
                        'assets/images/sec_tuv.png',
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Center(child: Text("TÜV", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Download Aplikasi Shopee", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(2)),
                          child: Image.asset(
                            'assets/images/qr_download.png',
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const Icon(Icons.qr_code_2, size: 70, color: Colors.black87),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            children: [
                              _buildAppStoreButton('assets/images/btn_appstore.png', "App Store"),
                              const SizedBox(height: 8),
                              _buildAppStoreButton('assets/images/btn_playstore.png', "Google Play"),
                              const SizedBox(height: 8),
                              _buildAppStoreButton('assets/images/btn_appgallery.png', "AppGallery"),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterTextColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 20),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {},
            child: Text(link, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildAssetBox(String imagePath, String fallbackText) {
    return Container(
      width: 60,
      height: 30,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Text(fallbackText, style: const TextStyle(fontSize: 8, color: Colors.black54, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildSocialLink(String imagePath, String title, IconData fallbackIcon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 16,
              height: 16,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => Icon(fallbackIcon, size: 16, color: Colors.black54),
            ),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppStoreButton(String imagePath, String fallbackText) {
    return Container(
      height: 24,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (c, e, s) => Center(child: Text(fallbackText, style: const TextStyle(fontSize: 8, color: Colors.black54))),
      ),
    );
  }
}