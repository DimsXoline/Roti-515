import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../home/home_screen.dart';  // ← TAMBAHKAN import

class LoginSuccessScreen extends StatelessWidget {
  const LoginSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildLogo(),
              const SizedBox(height: 40),
              _buildWelcomeText(),
              const SizedBox(height: 16),
              _buildSubtitle(),
              const Spacer(),
              _buildContinueButton(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8952A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'ROTI 515\nLOGIN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(
                  Icons.bakery_dining,
                  size: 36,
                  color: Color(0xFFB8952A),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: -4,
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFFF8C42),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return const Text(
      'Selamat Datang\nKembali!',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        height: 1.2,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Aroma roti hangat sudah menunggu.\nLogin Anda berhasil dan sesi Anda telah\ndisiapkan dengan sempurna.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: AppColors.textHint,
        height: 1.6,
      ),
    );
  }

  // ========== HANYA BAGIAN INI YANG DIUPDATE ==========
  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // Ganti navigasi ke HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
        icon: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
        label: const Text(
          'Lanjut ke Aplikasi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
  // ==================================================
}
