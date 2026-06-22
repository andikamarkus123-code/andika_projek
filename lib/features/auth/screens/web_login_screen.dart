import 'package:flutter/material.dart';

// ==========================================================
// IMPORT PATH SESUAI STRUKTUR PROYEK ANDA
// ==========================================================
import '../../main_nav/screens/main_screen.dart'; 
import '../services/auth_api_service.dart';
import '../services/auth_session.dart'; // <--- Import AuthSession ditambahkan
import 'web_otp_screen.dart'; 

class WebLoginScreen extends StatefulWidget {
  final bool initialIsLogin; // Penentu awal: true = Login, false = Daftar

  const WebLoginScreen({super.key, this.initialIsLogin = true});

  @override
  State<WebLoginScreen> createState() => _WebLoginScreenState();
}

class _WebLoginScreenState extends State<WebLoginScreen> {
  // --- State Pengontrol Tampilan ---
  late bool _isLogin;
  bool _isLoading = false;

  // --- Controllers ---
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set status awal berdasarkan tombol apa yang diklik di Header
    _isLogin = widget.initialIsLogin;
  }

  // ==========================================================
  // FUNGSI LOGIK SISTEM
  // ==========================================================
  void _handleWebLogin() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) return;

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

  void _handleRegisterNext() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final res = await AuthApiService.sendOtp(phone);
      if (res['success'] == true) {
        if (mounted) {
          _showSnackBar("OTP Terkirim ke WhatsApp Anda!");
          
          // 1. Simpan nomor handphone ke dalam Session agar bisa dibaca halaman OTP
          AuthSession.currentRegisterPhone = phone;

          // 2. Berpindah ke halaman WebOtpScreen tanpa error parameter
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WebOtpScreen(),
            ),
          );
        }
      } else {
        if (mounted) _showSnackBar(res['message'] ?? "Gagal mengirim OTP");
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
    _phoneController.dispose();
    super.dispose();
  }

  // ==========================================================
  // PEMBANGUN UI UTAMA
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    const Color shopeeOrange = Color(0xFFEE4D2D);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ==========================================
            // 1. TOP HEADER PUTIH
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
                          Text(
                            _isLogin ? "Log In" : "Daftar",
                            style: const TextStyle(color: Colors.black87, fontSize: 24),
                          ),
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

            // ==========================================
            // 2. BAGIAN UTAMA (BACKGROUND ORANYE)
            // ==========================================
            Container(
              width: double.infinity,
              color: shopeeOrange,
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: SizedBox(
                  width: 1040,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- SISI KIRI: GAMBAR LOGO BESAR ---
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/shopee_logo1.png',
                            height: 500,
                            errorBuilder: (c, e, s) => const Icon(Icons.shopping_bag, size: 140, color: Colors.white),
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),

                      // --- SISI KANAN: KARTU DINAMIS ---
                      Container(
                        width: 400,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                        ),
                        // Animasi pertukaran antara kartu Login dan Register
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          child: _isLogin ? _buildLoginCard(shopeeOrange) : _buildRegisterCard(shopeeOrange),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ==========================================
            // 3. FOOTER ABU-ABU (REPLIKA SHOPEE)
            // ==========================================
            _buildWebFooter(),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // WIDGET KARTU LOG IN
  // ==========================================================
  Widget _buildLoginCard(Color shopeeOrange) {
    bool isFormFilled = _usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty;

    return Column(
      key: const ValueKey('LoginCard'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Log In", style: TextStyle(fontSize: 20, color: Colors.black87)),
            Image.asset(
              'assets/images/qr_login.png', 
              height: 45,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => const Text("[Gambar QR]", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 30),

        SizedBox(
          height: 40,
          child: TextField(
            controller: _usernameController,
            onChanged: (value) => setState(() {}),
            decoration: _inputDecoration("No. Handphone/Username/Email"),
          ),
        ),
        const SizedBox(height: 15),

        SizedBox(
          height: 40,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            onChanged: (value) => setState(() {}),
            decoration: _inputDecoration("Password").copyWith(
              suffixIcon: Icon(Icons.visibility_off_outlined, color: Colors.grey.shade500, size: 20),
            ),
          ),
        ),
        const SizedBox(height: 15),

        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            style: _btnStyle(isFormFilled ? shopeeOrange : const Color(0xFFF4856E)),
            onPressed: isFormFilled && !_isLoading ? _handleWebLogin : null,
            child: _isLoading ? _loadingWidget() : const Text("LOG IN", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 12),

        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () {},
            child: const Text("Lupa Password", style: TextStyle(color: Color(0xFF0055AA), fontSize: 12)),
          ),
        ),
        const SizedBox(height: 20),
        
        _buildDividerAtau(),
        const SizedBox(height: 20),
        _buildSocialButtons(),
        const SizedBox(height: 30),

        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.5),
            children: [
              TextSpan(text: "Dengan login, kamu menyetujui "),
              TextSpan(text: "Syarat, Ketentuan\ndan Kebijakan dari Shopee", style: TextStyle(color: Color(0xFFEE4D2D))),
              TextSpan(text: " & "),
              TextSpan(text: "Kebijakan Privasi\nShopee.", style: TextStyle(color: Color(0xFFEE4D2D))),
            ],
          ),
        ),
        const SizedBox(height: 25),

        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Baru di Shopee? ", style: TextStyle(color: Colors.black45, fontSize: 14)),
              InkWell(
                onTap: () => setState(() => _isLogin = false), // BERUBAH KE REGISTER MODE
                child: const Text("Daftar", style: TextStyle(color: Color(0xFFEE4D2D), fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // WIDGET KARTU DAFTAR
  // ==========================================================
  Widget _buildRegisterCard(Color shopeeOrange) {
    bool isFormFilled = _phoneController.text.isNotEmpty;

    return Column(
      key: const ValueKey('RegisterCard'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Daftar", style: TextStyle(fontSize: 20, color: Colors.black87)),
        const SizedBox(height: 30),

        SizedBox(
          height: 40,
          child: TextField(
            controller: _phoneController,
            onChanged: (value) => setState(() {}),
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration("Nomor Telepon"),
          ),
        ),
        const SizedBox(height: 15),

        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            style: _btnStyle(isFormFilled ? shopeeOrange : const Color(0xFFF4856E)),
            onPressed: isFormFilled && !_isLoading ? _handleRegisterNext : null,
            child: _isLoading ? _loadingWidget() : const Text("BERIKUTNYA", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 20),

        _buildDividerAtau(),
        const SizedBox(height: 20),
        _buildSocialButtons(),
        const SizedBox(height: 30),

        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Punya akun? ", style: TextStyle(color: Colors.black45, fontSize: 14)),
              InkWell(
                onTap: () => setState(() => _isLogin = true), // KEMBALI KE LOGIN MODE
                child: const Text("Log In", style: TextStyle(color: Color(0xFFEE4D2D), fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // REUSABLE COMPONENTS
  // ==========================================================
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
    );
  }

  ButtonStyle _btnStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
    );
  }

  Widget _loadingWidget() {
    return const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5));
  }

  Widget _buildDividerAtau() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text("ATAU", style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(child: _buildWebSocialButton(imagePath: 'assets/images/facebook1.png', text: 'Facebook', onTap: () {})),
        const SizedBox(width: 10),
        Expanded(child: _buildWebSocialButton(imagePath: 'assets/images/google.png', text: 'Google', onTap: () {})),
      ],
    );
  }

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
            Image.asset(imagePath, width: 20, height: 20, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported, size: 20, color: Colors.grey)),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(color: Colors.black87, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // WIDGET FOOTER LENGKAP
  // ==========================================================
  Widget _buildWebFooter() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F5F5), // Latar belakang abu-abu terang
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Center(
        child: SizedBox(
          width: 1040, // Lebar disamakan dengan konten login di atasnya
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KOLOM 1: Layanan Pelanggan
              Expanded(
                flex: 2,
                child: _buildFooterTextColumn(
                  "Layanan Pelanggan",
                  [
                    "Bantuan", "Metode Pembayaran", "ShopeePay", "Koin Shopee",
                    "Lacak Pesanan Pembeli", "Lacak Pengiriman Penjual", "Gratis Ongkir",
                    "Pengembalian Barang & Dana", "Garansi Shopee"
                  ],
                ),
              ),

              // KOLOM 2: Jelajahi Shopee
              Expanded(
                flex: 2,
                child: _buildFooterTextColumn(
                  "Jelajahi Shopee",
                  [
                    "Tentang Kami", "Karir", "Kebijakan", "Kebijakan Privasi Shopee",
                    "Blog", "Shopee Mall", "Seller Centre", "Flash Sale", "Kontak Media"
                  ],
                ),
              ),

              // KOLOM 3: Pembayaran
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
                        _buildAssetBox('assets/images/pay_biru.png', "Biru"),
                        _buildAssetBox('assets/images/pay_bca.png', "BCA"),
                        _buildAssetBox('assets/images/pay_bni.png', "BNI"),
                        _buildAssetBox('assets/images/pay_bri.png', "BRI"),
                        _buildAssetBox('assets/images/pay_bsi.png', "BSI"),
                        _buildAssetBox('assets/images/pay_cimb.png', "CIMB"),
                        _buildAssetBox('assets/images/pay_dandan.png', "DanDan"),
                        _buildAssetBox('assets/images/pay_indomaret.png', "Indomaret"),
                        _buildAssetBox('assets/images/pay_jcb.png', "JCB"),
                        _buildAssetBox('assets/images/pay_mandiri.png', "Mandiri"),
                        _buildAssetBox('assets/images/pay_mastercard.png', "MasterCard"),
                        _buildAssetBox('assets/images/pay_perma.png', "Perma"),
                        _buildAssetBox('assets/images/pay_spay.png', "SPay"),
                        _buildAssetBox('assets/images/pay_visa.png', "Visa"),
                      ],
                    ),
                  ],
                ),
              ),

              // KOLOM 4: Ikuti Kami & Keamanan
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
                    // Gambar Sertifikat Keamanan
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

              // KOLOM 5: Download Aplikasi Shopee
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
                        // Gambar QR Code
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
                        // Tombol App Store & Play Store
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

  // --- Helper: Kolom Teks Link ---
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

  // --- Helper: Kotak Logo Pembayaran ---
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
        // Jika file asset belum ada, tampilkan teks fallback kecil
        errorBuilder: (context, error, stackTrace) => Center(
          child: Text(fallbackText, style: const TextStyle(fontSize: 8, color: Colors.black54, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // --- Helper: Link Sosial Media ---
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

  // --- Helper: Tombol Download App ---
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