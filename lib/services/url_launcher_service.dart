import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  // Alamat toko Roti 515
  static const String _storeAddress = 
      'C375+6GH, Jalan Desa, RT.01/RW.02, Kemlokelogi, Kemlokolegi, Kec. Baron, Kabupaten Nganjuk, Jawa Timur 64394';
  
  // Buka Google Maps
  static Future<void> openMaps({
    required BuildContext context,
    String? customAddress,
  }) async {
    final address = customAddress ?? _storeAddress;
    final encodedAddress = Uri.encodeComponent(address);
    
    final String googleMapsUrl = 
        'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
    
    final Uri url = Uri.parse(googleMapsUrl);
    
    try {
      final bool canLaunch = await canLaunchUrl(url);
      if (canLaunch) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // Fallback: buka di browser
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka peta. Pastikan koneksi internet aktif.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  // Buka URL biasa
  static Future<void> openUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
  
  // Buka WhatsApp (opsional)
  static Future<void> openWhatsApp(String phoneNumber, String message) async {
    final String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
    await openUrl(url);
  }
}