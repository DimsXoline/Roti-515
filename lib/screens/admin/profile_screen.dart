// screens/admin/profile_screen.dart
import 'package:flutter/material.dart';
import 'dart:io';
import '../../utils/app_colors.dart';
import '../auth/login_screen.dart';
import 'edit_admin_profile_screen.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  String _nama = 'Erine';
  String _pengurus = 'ADMINISTRATOR';
  String _email = 'admin@roti515.com';
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Avatar
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditAdminProfileScreen(
                      nama: _nama,
                      pengurus: _pengurus,
                      email: _email,
                      imagePath: _imagePath,
                    ),
                  ),
                );
                if (result != null && mounted) {
                  setState(() {
                    if (result['nama'] != null && result['nama'].isNotEmpty) {
                      _nama = result['nama'];
                    }
                    if (result['pengurus'] != null && result['pengurus'].isNotEmpty) {
                      _pengurus = result['pengurus'];
                    }
                    if (result['image'] != null) {
                      _imagePath = result['image'].path;
                    }
                  });
                }
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _imagePath != null
                    ? ClipOval(
                        child: Image.file(
                          File(_imagePath!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.admin_panel_settings,
                        size: 55,
                        color: Colors.white,
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Nama Admin
            Text(
              _nama,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            // Email Admin
            Text(
              _email,
              style: TextStyle(fontSize: 13, color: AppColors.textHint),
            ),
            const SizedBox(height: 8),

            // Role Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _pengurus,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Menu Edit Profile
            _buildMenuCard(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              subtitle: 'Perbarui data diri Anda',
              iconColor: Colors.blue,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditAdminProfileScreen(
                      nama: _nama,
                      pengurus: _pengurus,
                      email: _email,
                      imagePath: _imagePath,
                    ),
                  ),
                );
                if (result != null && mounted) {
                  setState(() {
                    if (result['nama'] != null && result['nama'].isNotEmpty) {
                      _nama = result['nama'];
                    }
                    if (result['pengurus'] != null && result['pengurus'].isNotEmpty) {
                      _pengurus = result['pengurus'];
                    }
                    if (result['image'] != null) {
                      _imagePath = result['image'].path;
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil berhasil diperbarui'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            // Menu Logout
            _buildMenuCard(
              icon: Icons.logout,
              title: 'Keluar',
              subtitle: 'Keluar dari akun admin',
              iconColor: Colors.red,
              isLogout: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Konfirmasi Keluar'),
                    content: const Text('Apakah Anda yakin ingin keluar?'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Keluar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: AppColors.textHint),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isLogout ? Colors.red : AppColors.textHint,
        ),
        onTap: onTap,
      ),
    );
  }
}