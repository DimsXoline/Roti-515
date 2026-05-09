import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await ProductService.getProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  int get totalStok => _products.fold(0, (sum, p) => sum + p.stok);
  int get lowStock => _products.where((p) => p.stok <= 5).length;

  Future<void> _updateStock(Product product, int delta) async {
    final newStock = product.stok + delta;
    if (newStock >= 0 && newStock <= 999) {
      final result = await ProductService.updateProduct(
        id: product.id!,
        nama: product.nama,
        harga: product.harga,
        deskripsi: product.deskripsi,
        kategori: product.kategori ?? 'roti',
        stok: newStock,
        badge: product.badge,
      );
      if (result['success'] == true) {
        _loadProducts();
      }
    }
  }

  Future<void> _deleteProduct(Product product) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Apakah Anda yakin ingin menghapus ${product.nama}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              if (product.id != null) {
                final result = await ProductService.deleteProduct(product.id!);
                if (result['success'] == true) {
                  _loadProducts();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Produk berhasil dihapus')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result['message'] ?? 'Gagal hapus produk')),
                  );
                }
              } else {
                setState(() {
                  _products.remove(product);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produk berhasil dihapus')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _loadProducts,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Manajemen Produk',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Kelola stok dan produk roti Anda',
                style: TextStyle(fontSize: 14, color: AppColors.textHint),
              ),
              const SizedBox(height: 24),
              
              _buildStockCard(),
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddProductScreen()),
                    );
                    if (result != null) {
                      _loadProducts();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Produk berhasil ditambahkan')),
                      );
                    }
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah Produk Baru'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              const Text(
                'Daftar Produk',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_products.isEmpty)
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Icon(Icons.inventory, size: 64, color: AppColors.textHint),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada produk',
                        style: TextStyle(color: AppColors.textHint),
                      ),
                    ],
                  ),
                )
              else
                ..._products.map((product) => _buildProductItem(product)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF5E6D3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.inventory, size: 30, color: Color(0xFFB8952A)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stock ROTI 515',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pertahankan kesegaran adonan pagi Anda.',
                  style: TextStyle(fontSize: 12, color: AppColors.textHint),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$totalStok',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              Text(
                'Total Stok',
                style: TextStyle(fontSize: 10, color: AppColors.textHint),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$lowStock',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              Text(
                'Stok Menipis',
                style: TextStyle(fontSize: 10, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    bool isLowStock = product.stok <= 5;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product.nama,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProductScreen(product: product),
                        ),
                      );
                      if (result != null) {
                        _loadProducts();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Produk berhasil diperbarui')),
                        );
                      }
                    },
                    icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () => _deleteProduct(product),
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            product.deskripsi,
            style: TextStyle(fontSize: 12, color: AppColors.textHint),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.formattedPrice,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isLowStock ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isLowStock ? 'STOK MENIPIS' : 'TERSEDIA',
                  style: TextStyle(
                    fontSize: 10,
                    color: isLowStock ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildStockButton(Icons.remove, () => _updateStock(product, -1)),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  '${product.stok}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildStockButton(Icons.add, () => _updateStock(product, 1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.toggleBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: Colors.black54),
      ),
    );
  }
}