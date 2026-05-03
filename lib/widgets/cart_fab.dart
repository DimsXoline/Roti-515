import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../screens/checkout/checkout_screen.dart';
import '../models/products.dart';

class CartFab extends StatelessWidget {
  final int itemCount;
  final VoidCallback onTap;

  const CartFab({super.key, required this.itemCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: IconButton(
            onPressed: () {
              if (itemCount > 0) {
                // Langsung ke halaman checkout
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(
                      cartItems: Product.defaults,
                      totalAmount: 40000,
                    ),
                  ),
                );
              }
              onTap();
            },
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24),
          ),
        ),
        if (itemCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                '$itemCount',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
