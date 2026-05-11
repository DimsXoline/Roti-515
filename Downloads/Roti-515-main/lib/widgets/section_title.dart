import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showLihatSemua;
  final VoidCallback? onLihatSemua;

  const SectionTitle({super.key, required this.title, this.subtitle, this.showLihatSemua = false, this.onLihatSemua});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              if (showLihatSemua)
                GestureDetector(
                  onTap: onLihatSemua,
                  child: Text('Lihat Semua >', style: TextStyle(fontSize: 13, color: AppColors.primary)),
                ),
            ],
          ),
          if (subtitle != null) 
            Padding(padding: const EdgeInsets.only(top: 4), child: Text(subtitle!, style: TextStyle(fontSize: 13, color: AppColors.textHint))),
        ],
      ),
    );
  }
}
