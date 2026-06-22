import 'package:flutter/material.dart';
import 'dart:async'; // Wajib ditambahkan untuk fitur hitung mundur (Timer)

// ==========================================================
// IMPORT SERVICE API, SESSION, DAN HALAMAN TUJUAN BERIKUTNYA
// ==========================================================
import '../services/auth_api_service.dart';
import '../services/auth_session.dart';
import 'mobile_create_password_screen.dart'; // Sesuaikan jika namanya berbeda

class MobileOtpScreen extends StatefulWidget {
  const MobileOtpScreen({super.key});

  @override
  State<MobileOtpScreen> createState() => _MobileOtpScreenState();
}

class _MobileOtpScreenState extends State<MobileOtpScreen> {
  // Membuat 6 buah controller dan focus node untuk masing-masing kotak OTP
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  bool _isLoading = false;

  // --- State Hitung Mundur ---
  Timer? _timer;
  int _secondsRemaining = 55; // Sesuai dengan gambar (dimulai dari 55/60 detik)
  bool _isResendAvailable = false;

  @override
  void initState() {
    super.initState();
    _startTimer(); // Mulai hitung mundur saat layar dibuka
  }

  // --- Fungsi Timer Hitung Mundur ---
  void _startTimer() {
    setState(() {
      _secondsRemaining = 55;
      _isResendAvailable = false;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() {
          _isResendAvailable = true;
          _timer?.cancel();
        });
      }
    });
  }

  // --- Fungsi Kirim Ulang OTP ---
  void _resendOtp() async {
    if (!_isResendAvailable) return;

    String phone = AuthSession.currentRegisterPhone;
    if (phone.isEmpty) phone = "(+62) 822-4800-8455"; // Fallback

    _showSnackBar("Mengirim ulang kode ke WhatsApp...");

    try {
      final res = await AuthApiService.sendOtp(phone);
      if (res['success'] == true) {
        _startTimer(); // Reset timer kembali ke 55 detik
      } else {
        _showSnackBar(res['message'] ?? "Gagal mengirim ulang OTP");
      }
    } catch (e) {
      _showSnackBar("Terjadi kesalahan jaringan");
    }
  }

  // --- Fungsi Verifikasi OTP ke Database via API Laragon ---
  void _verifyOtp() async {
    // Menggabungkan teks dari 6 kotak menjadi 1 string utuh (cth: "123456")
    String otpCode = _controllers.map((c) => c.text).join();
    if (otpCode.length < 6) return;

    setState(() => _isLoading = true);

    try {
      // Memanggil verify_otp.php di Laragon
      final res = await AuthApiService.verifyOtp(AuthSession.currentRegisterPhone, otpCode);

      if (res['success'] == true) {
        if (mounted) {
          // Jika OTP valid, lanjut ke halaman pembuatan password
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MobileCreatePasswordScreen(),
            ),
          );
        }
      } else {
        _clearOtpFields();
        if (mounted) {
          _showSnackBar(res['message'] ?? "Kode verifikasi salah. Silakan coba lagi.");
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar("Gagal verifikasi OTP, periksa koneksi server");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Membersihkan semua kotak jika OTP salah dimasukkan
  void _clearOtpFields() {
    for (var c in _controllers) {
      c.clear();
    }
    // Mengembalikan fokus ke kotak pertama
    _focusNodes[0].requestFocus();
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _timer?.cancel(); // Matikan timer agar tidak terjadi memory leak
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color shopeeOrange = Color(0xFFEE4D2D);

    return Scaffold(
      backgroundColor: Colors.white,
      
      // ==========================================
      // APP BAR (Persis Gambar)
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
          "Masukkan Kode Verifikasi (OTP)",
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: shopeeOrange, size: 26),
            onPressed: () {},
          ),
        ],
      ),

      // ==========================================
      // KONTEN UTAMA
      // ==========================================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              const Text(
                "Kode OTP dikirim melalui WhatsApp ke",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/whatsapp.png',
                    width: 20,
                    height: 20,
                    errorBuilder: (c, e, s) => const Icon(Icons.wechat, color: Color(0xFF25D366), size: 22),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AuthSession.currentRegisterPhone.isNotEmpty 
                        ? AuthSession.currentRegisterPhone 
                        : "(+62) 822-4800-8455",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
              
              const SizedBox(height: 50),
  
              // --- 6 Kolom Input OTP ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildOtpField(context, index)),
              ),
  
              const SizedBox(height: 40),

              // Loading Spinner saat verifikasi berjalan
              if (_isLoading) ...[
                const CircularProgressIndicator(color: shopeeOrange),
                const SizedBox(height: 30),
              ] else ...[
                const SizedBox(height: 40), // Jaga jarak jika tidak loading
              ],
  
              // --- Teks Hitung Mundur (Persis Gambar) ---
              if (!_isResendAvailable)
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
                    children: [
                      const TextSpan(text: "Mohon tunggu "),
                      TextSpan(text: "$_secondsRemaining", style: const TextStyle(color: shopeeOrange)),
                      const TextSpan(text: " detik untuk mengirim ulang.\n"),
                      const TextSpan(text: "Tidak punya WhatsApp? Coba "),
                      const TextSpan(text: "metode lain", style: TextStyle(color: Color(0xFF1E64C8))),
                      const TextSpan(text: "."),
                    ],
                  ),
                )
              else
                // Jika waktu habis, tampilkan tombol Kirim Ulang
                Column(
                  children: [
                    InkWell(
                      onTap: _resendOtp,
                      child: const Text(
                        "Kirim ulang kode",
                        style: TextStyle(color: Color(0xFF1E64C8), fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                        children: [
                          TextSpan(text: "Tidak punya WhatsApp? Coba "),
                          TextSpan(text: "metode lain", style: TextStyle(color: Color(0xFF1E64C8))),
                          TextSpan(text: "."),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================================
  // WIDGET HELPER: Kolom Input OTP Satuan (Stateful)
  // ========================================================
  Widget _buildOtpField(BuildContext context, int index) {
    return SizedBox(
      width: 45, 
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        autofocus: index == 0, 
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1, 
        cursorColor: Colors.blue, // Kursor berwarna biru seperti di gambar
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          counterText: "", 
          // Garis bawah tipis saat tidak aktif
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5)),
          // Garis bawah hitam saat kotak aktif
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87, width: 1.5)), 
        ),
        onChanged: (value) {
          if (value.length == 1) {
            // Jika angka terisi dan BUKAN kotak terakhir, lompat maju
            if (index < 5) {
              _focusNodes[index + 1].requestFocus();
            } 
            // Jika angka terisi dan INI ADALAH kotak terakhir (kotak ke-6)
            else {
              _focusNodes[index].unfocus(); // Sembunyikan keyboard
              _verifyOtp(); // Eksekusi validasi otomatis ke API Laragon
            }
          } else if (value.isEmpty && index > 0) {
            // Jika angka dihapus, fokus mundur ke kotak sebelumnya
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}