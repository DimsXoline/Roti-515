import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String? hintText;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Cari roti favoritmu...',
            hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: AppColors.textHint, size: 20),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: AppColors.textHint, size: 18),
                    onPressed: () {
                      widget.controller.clear();
                      widget.onChanged('');
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ),
    );
  }
}