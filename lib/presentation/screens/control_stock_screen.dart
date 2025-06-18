import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_application_1/presentation/widgets/custom_bottom_navbar.dart';
import 'package:go_router/go_router.dart';

class Product {
  final String id;
  final String nombre;
  final int stock;
  final String? imagen;
  final String? categoria;

  Product({
    required this.id, 
    required this.nombre, 
    required this.stock,
    this.imagen,
    this.categoria,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      nombre: data['nombre'] ?? 'Sin nombre',
      stock: data['stock'] ?? 0,
      imagen: data['imagen'],
      categoria: data['categoria'],
    );
  }
}

class ControlStockScreen extends StatelessWidget {
  const ControlStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/admin-profile'),
        ),
        title: const Text(
          'Control de Stock',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: _ProductList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(),
    );
  }
}

class _ProductList extends StatelessWidget {
  Future<List<Product>> _fetchProducts() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('productos')
        .orderBy('nombre')
        .get();
    return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                ),
                SizedBox(height: 16),
                Text(
                  'Cargando productos...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }

        final products = snapshot.data!;

        if (products.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 48),
                SizedBox(height: 16),
                Text(
                  'No hay productos en stock',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _ProductItem(product: products[index]);
          },
        );
      },
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;

  const _ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color.fromARGB(255, 75, 74, 74),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (product.imagen != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imagen!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[800],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    );
                  },
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.categoria != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      product.categoria!,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: product.stock > 0 ? Colors.teal.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${product.stock}',
                style: TextStyle(
                  color: product.stock > 0 ? Colors.tealAccent : Colors.redAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
