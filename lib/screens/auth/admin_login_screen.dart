// ===================================================
// FILE: lib/screens/admin_login_screen.dart
// Halaman Login khusus Admin
// ===================================================

import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool _isPasswordVisible = false; // kontrol show/hide password

  // Controller untuk mengambil teks yang diketik
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // warna latar krem
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // rata kiri
            children: [
              _buildHeader(), // judul "Roti 515"
              _buildWelcomeText(), // teks "Selamat Datang, Admin"
              _buildSubtitle(), // teks keterangan di bawahnya
              _buildUsernameField(), // input username
              _buildPasswordField(), // input kata sandi
              _buildLoginButton(), // tombol "Masuk ke Dashboard"
            ],
          ),
        ),
      ),
    );
  }

  // Bagian 1: Header "Roti 515"
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 32),
      child: Center(
        child: Text(
          'Roti 515',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark, // warna coklat gelap
          ),
        ),
      ),
    );
  }

  // Bagian 2: Teks sambutan "Selamat Datang, Admin"
  Widget _buildWelcomeText() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        'Selamat Datang,\nAdmin', // "\n" = pindah baris
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          height: 1.2, // jarak antar baris
        ),
      ),
    );
  }

  // Bagian 3: Teks keterangan kecil
  Widget _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Text(
        'Masukkan masukan Username Dan Pasword Anda untuk melanjutkan ke dashboard.',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textHint, // warna abu
          height: 1.5, // jarak antar baris
        ),
      ),
    );
  }

  // Bagian 4: Input Username Admin
  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'USERNAME ADMIN', // label huruf kapital
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5, // jarak antar huruf
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'nama_pengguna_anda',
            hintStyle: TextStyle(color: AppColors.textHint),
            prefixIcon: Icon(
              Icons.person_outline, // ikon orang di kiri
              color: AppColors.textHint,
            ),
            filled: true,
            fillColor: AppColors.inputBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none, // hilangkan garis border
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Bagian 5: Input Kata Sandi
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'KATA SANDI',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'LUPA?', // link lupa password
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textHint,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible, // sembunyikan teks jika false
          decoration: InputDecoration(
            hintText: '•••••••••••',
            hintStyle: TextStyle(color: AppColors.textHint),
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.textHint),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  // "!" membalik nilai: false→true, true→false
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              child: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.textHint,
              ),
            ),
            filled: true,
            fillColor: AppColors.inputBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 40), // jarak lebih besar sebelum tombol
      ],
    );
  }

  // Bagian 6: Tombol "Masuk ke Dashboard"
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity, // lebar penuh
      child: ElevatedButton.icon(
        // tombol dengan ikon di kanan
        onPressed: () {}, // nanti diisi logika login
        icon: const Icon(
          Icons.arrow_forward, // ikon panah ke kanan
          color: Colors.white,
        ),
        label: const Text(
          'Masuk ke Dashboard',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // warna coklat
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // sangat membulat
          ),
        ),
      ),
    );
  }
}
