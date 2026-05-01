import 'package:flutter/material.dart';
import '../../../models/product.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/cart_fab.dart';
import '../../../widgets/custom_search_bar.dart';
import '../../../widgets/section_title.dart';
import '../../../utils/app_colors.dart';
import 'product_screen.dart';
import '../../profile/profile_screen.dart';
import '../../checkout/checkout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeContent(),
      const ProductScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Product> _products = [];
  bool _isLoading = true;
  int _cartCount = 0;
  final List<Product> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _products = Product.defaults;
      _isLoading = false;
    });
  }

  void _addToCart(Product product) {
    setState(() {
      _cartCount++;
      _cartItems.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.nama} ditambahkan'), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = _cartItems.fold(0, (sum, item) => sum + item.harga.toInt());
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const CustomSearchBar(),
              _buildBanner(),
              const SectionTitle(title: 'Koleksi Kami', subtitle: 'Hari favoritmu dari panggang kami'),
              _buildProductGrid(),
              SectionTitle(
                title: 'Paling Terlaris',
                showLihatSemua: true,
                onLihatSemua: () {
                  final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                  homeState?.setState(() {
                    homeState._currentIndex = 1;
                  });
                },
              ),
              _buildBestSellerGrid(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: CartFab(
        itemCount: _cartCount,
        onTap: () {
          if (_cartItems.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutScreen(
                  cartItems: _cartItems,
                  totalAmount: totalPrice,
                ),
              ),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
  Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'ROTI 515',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryDark,
          letterSpacing: 2,
        ),
      ),
    ),
  );
}

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 180,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColors.primary),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Kehangatan\nOtentik di\nSetiap Gigitan',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Pesan Sekarang', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.bakery_dining, size: 80, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final displayProducts = _products.take(4).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: displayProducts.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: displayProducts[index],
            onAddToCart: () => _addToCart(displayProducts[index]),
          );
        },
      ),
    );
  }

  Widget _buildBestSellerGrid() {
    if (_isLoading) return const SizedBox.shrink();
    final bestSellers = _products.where((p) => p.badge == 'BEST SELLER').toList();
    if (bestSellers.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: bestSellers.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: bestSellers[index],
            onAddToCart: () => _addToCart(bestSellers[index]),
          );
        },
      ),
    );
  }
}
