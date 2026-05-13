import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/cart_fab.dart';
import '../../../widgets/custom_search_bar.dart';
import '../../../widgets/section_title.dart';
import '../../../utils/app_colors.dart';
import 'product_screen.dart';
import '../profile/profile_screen.dart';
import '../checkout/checkout_screen.dart';
import 'notification_screen.dart';

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
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
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
  List<Product> _bestSellers = [];
  List<Product> _allProducts = [];
  bool _isLoading = true;
  int _cartCount = 0;
  final List<Product> _cartItems = [];
  int _notifCount = 3;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await ProductService.getProducts();
    setState(() {
      _allProducts = products;
      _products = products;
      _bestSellers = products.where((p) => p.badge == 'BEST SELLER').toList();
      _isLoading = false;
    });
  }

  void _searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _products = _allProducts;
      } else {
        _products = _allProducts.where((product) {
          return product.nama.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      _bestSellers = _products.where((p) => p.badge == 'BEST SELLER').toList();
    });
  }

  void _addToCart(Product product) {
    setState(() {
      _cartCount++;
      _cartItems.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.nama} ditambahkan'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
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
              CustomSearchBar(
                controller: _searchController,
                onChanged: _searchProducts,
              ),
              _buildBanner(),
              const SectionTitle(
                title: 'Koleksi Kami',
                subtitle: 'Hari favoritmu dari panggang kami',
              ),
              _buildProductGrid(),
              SectionTitle(
                title: 'Paling Terlaris',
                showLihatSemua: true,
                onLihatSemua: () {
                  final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                  homeState?.setState(() => homeState._currentIndex = 1);
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
        cartItems: _cartItems,
        totalPrice: totalPrice,
        onTap: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ROTI 515',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
              letterSpacing: 2,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() => _notifCount = 0);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationScreen()),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 26,
                  color: AppColors.primaryDark,
                ),
                if (_notifCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 17,
                      height: 17,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _notifCount > 9 ? '9+' : '$_notifCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.primary,
      ),
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
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                      homeState?.setState(() => homeState._currentIndex = 1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Pesan Sekarang',
                      style: TextStyle(fontSize: 12),
                    ),
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
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final displayProducts = _products.take(4).toList();

    if (displayProducts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(
              'Produk tidak ditemukan',
              style: TextStyle(fontSize: 16, color: AppColors.textHint),
            ),
          ],
        ),
      );
    }

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
    if (_bestSellers.isEmpty) return const SizedBox.shrink();

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
        itemCount: _bestSellers.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: _bestSellers[index],
            onAddToCart: () => _addToCart(_bestSellers[index]),
          );
        },
      ),
    );
  }
}