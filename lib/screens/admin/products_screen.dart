import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../models/product.dart';
import 'add_product_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _products = [];
  List<int> _stocks = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _products = List.from(Product.defaults);
      _stocks = [24, 4, 20, 12];
    });
  }

  int get totalStok => _stocks.reduce((a, b) => a + b);
  int get lowStock => _stocks.where((s) => s <= 5).length;

  void _updateStock(int index, int delta) {
    setState(() {
      int newStock = _stocks[index] + delta;
      if (newStock >= 0 && newStock <= 999) {
        _stocks[index] = newStock;
      }
    });
  }

  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Apakah Anda yakin ingin menghapus ${_products[index].nama}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              setState(() {
                _products.removeAt(index);
                _stocks.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Produk berhasil dihapus')),
              );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
            
            // Stock Card
            _buildStockCard(),
            const SizedBox(height: 20),
            
            // Tombol Tambah Produk
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddProductScreen()),
                  );
                  if (result != null) {
                    setState(() {
                      _products.add(result);
                      _stocks.add(0);
                    });
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
            
            // Daftar Produk
            const Text(
              'Daftar Produk',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // List Produk
            ..._products.asMap().entries.map((entry) {
              int index = entry.key;
              Product product = entry.value;
              int stock = index < _stocks.length ? _stocks[index] : 0;
              bool isLowStock = stock <= 5;
              return _buildProductItem(product, stock, isLowStock, index);
            }),
          ],
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
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

  Widget _buildProductItem(Product product, int stock, bool isLowStock, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
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
                  // Tombol Edit
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fitur edit segera hadir')),
                      );
                    },
                    icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                  ),
                  // Tombol Hapus
                  IconButton(
                    onPressed: () => _deleteProduct(index),
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
                  color: isLowStock ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
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
          // Tombol +/-
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildStockButton(Icons.remove, () => _updateStock(index, -1)),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  '$stock',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildStockButton(Icons.add, () => _updateStock(index, 1)),
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