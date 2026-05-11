import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class RoleToggle extends StatelessWidget {
  final bool isAdmin;
  final ValueChanged<bool> onToggle;

  const RoleToggle({super.key, required this.isAdmin, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.toggleBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTab(
            label: 'Admin',
            selected: isAdmin,
            onTap: () => onToggle(true),
          ),
          _buildTab(
            label: 'Pelanggan',
            selected: !isAdmin,
            onTap: () => onToggle(false),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textHint,
            ),
          ),
        ),
      ),
    );
  }
}
