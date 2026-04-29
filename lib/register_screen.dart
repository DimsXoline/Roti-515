import '../../services/auth_service.dart';
import 'login_screen.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;

  // Controller untuk mengambil teks yang diketik user
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(), // judul "Roti 515"
              _buildTitleText(), // "Buat Akun Baru"
              _buildSubtitle(), // "Bergabunglah dengan kami"
              _buildNamaField(), // input nama lengkap
              _buildEmailField(), // input email
              _buildPhoneField(), // input nomor telepon
              _buildPasswordField(), // input kata sandi
              const SizedBox(height: 32),
              _buildRegisterButton(), // tombol "Daftar Sekarang"
              _buildDivider(), // garis "Atau daftar dengan"
              _buildGoogleButton(), // tombol Google
              _buildLoginLink(), // link "Masuk di sini"
            ],
          ),
        ),
      ),
    );
  }

  // Bagian 1: Header "Roti 515"
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 24),
      child: Center(
        child: Text(
          'Roti 515',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
      ),
    );
  }

  // Bagian 2: Judul "Buat Akun Baru"
  Widget _buildTitleText() {
    return const Text(
      'Buat Akun Baru',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Bagian 3: Subjudul
  Widget _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 28),
      child: Text(
        'Bergabunglah dengan kami',
        style: TextStyle(fontSize: 14, color: AppColors.textHint),
      ),
    );
  }

  // Helper: membuat input field dengan label
  // Dipakai berulang untuk setiap field
  Widget _buildInputField({
    required String label, // teks label di atas field
    required String hint, // teks placeholder di dalam field
    required IconData icon, // ikon di kiri field
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text, // jenis keyboard
    bool isPassword = false, // apakah field ini password?
    Widget? suffixIcon, // ikon di kanan (opsional)
    String? prefixText, // teks di kiri dalam field (opsional)
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText:
              isPassword && !_isPasswordVisible, // sembunyikan jika password
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textHint),
            prefixIcon: Icon(icon, color: AppColors.textHint),
            prefixText: prefixText, // teks prefix (misal: +62)
            prefixStyle: TextStyle(color: AppColors.textHint),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.inputBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Bagian 4: Input Nama Lengkap
  Widget _buildNamaField() {
    return _buildInputField(
      label: 'Nama Lengkap',
      hint: 'Masukkan nama lengkap',
      icon: Icons.person_outline,
      controller: _namaController,
    );
  }

  // Bagian 5: Input Email
  Widget _buildEmailField() {
    return _buildInputField(
      label: 'Alamat Email',
      hint: 'nama@email.com',
      icon: Icons.email_outlined,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress, // keyboard khusus email
    );
  }

  // Bagian 6: Input Nomor Telepon
  Widget _buildPhoneField() {
    return _buildInputField(
      label: 'Nomor Telepon',
      hint: '+62 812 ...',
      icon: Icons.phone_outlined,
      controller: _phoneController,
      keyboardType: TextInputType.phone, // keyboard khusus angka
    );
  }

  // Bagian 7: Input Kata Sandi
  Widget _buildPasswordField() {
    return _buildInputField(
      label: 'Kata Sandi',
      hint: 'Min. 8 karakter',
      icon: Icons.lock_outline,
      controller: _passwordController,
      isPassword: true, // aktifkan mode password
      suffixIcon: GestureDetector(
        // ikon mata untuk show/hide
        onTap: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible; // balik nilai boolean
          });
        },
        child: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: AppColors.textHint,
        ),
      ),
    );
  }

  // Bagian 8: Tombol "Daftar Sekarang"
  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          String nama = _namaController.text.trim();
          String email = _emailController.text.trim();
          String phone = _phoneController.text.trim();
          String password = _passwordController.text;

          if (nama.isEmpty || email.isEmpty || password.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Semua field wajib diisi!')),
            );
            return;
          }

          if (password.length < 8) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password minimal 8 karakter!')),
            );
            return;
          }

          final result = await AuthService.register(
            nama: nama,
            email: email,
            phone: phone,
            password: password,
          );

          if (result['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Akun berhasil dibuat! Silakan login.'),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(result['message'])));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary,
          disabledForegroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Daftar Sekarang',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Bagian 9: Garis pemisah
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.textHint)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Atau daftar dengan',
              style: TextStyle(color: AppColors.textHint, fontSize: 13),
            ),
          ),
          Expanded(child: Divider(color: AppColors.textHint)),
        ],
      ),
    );
  }

  // Bagian 10: Tombol Google
  Widget _buildGoogleButton() {
    return Center(
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.g_mobiledata, size: 24),
        label: const Text('Google'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Bagian 11: Link "Sudah punya akun? Masuk di sini"
  Widget _buildLoginLink() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sudah punya akun? '),
            GestureDetector(
              onTap: () {
                // Kembali ke halaman login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Text(
                'Masuk di sini',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
