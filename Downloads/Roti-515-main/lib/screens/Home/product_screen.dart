import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../widgets/product_card.dart';
import '../../widgets/custom_search_bar.dart';
import '../../utils/app_colors.dart';
import '../../screens/checkout/checkout_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> _products = [];
  List<Product> _allProducts = [];
  bool _isLoading = true;
  int _cartCount = 0;
  final List<Product> _cartItems = [];
  
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

  // LOAD PRODUK DARI DATABASE
  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    
    final products = await ProductService.getProducts();
    
    setState(() {
      _allProducts = products;
      _products = products;
      _isLoading = false;
    });
  }

  // SEARCH PRODUK
  void _searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _products = _allProducts;
      } else {
        _products = _allProducts.where((product) {
          return product.nama.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
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
        child: Column(
          children: [
            _buildHeader(totalPrice),
            CustomSearchBar(
              controller: _searchController,
              onChanged: _searchProducts,
              hintText: 'Cari produk roti...',
            ),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(
              'Produk tidak ditemukan',
              style: TextStyle(fontSize: 16, color: AppColors.textHint),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba cari dengan kata kunci lain',
              style: TextStyle(fontSize: 12, color: AppColors.textHint),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadProducts,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: _products.length,
          itemBuilder: (context, index) {
            return ProductCard(
              product: _products[index],
              onAddToCart: () => _addToCart(_products[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(int totalPrice) {
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
          Stack(
            children: [
              IconButton(
                onPressed: () {
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
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Keranjang belanja masih kosong')),
                    );
                  }
                },
                icon: Icon(Icons.shopping_cart_outlined, color: AppColors.primaryDark, size: 24),
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '$_cartCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}