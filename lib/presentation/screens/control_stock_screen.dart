import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_application_1/presentation/widgets/custom_bottom_navbar.dart';
import 'package:go_router/go_router.dart';

class Product {
  final String id;
  final String nombre;
  final int stock;

  Product({required this.id, required this.nombre, required this.stock});

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      nombre: data['nombre'] ?? 'Sin nombre',
      stock: data['stock'] ?? 0,
    );
  }
}

class ControlStockScreen extends StatelessWidget {
  const ControlStockScreen({super.key});

  // Fetch products from Firestore
  Future<List<Product>> _fetchProducts() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('productos')
            .get(); 

    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 30), 
          const Text(
            'Control de stock', 
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20), 
          Expanded(child: _ProductList()), 
        ],
      ),
      bottomNavigationBar: CustomBottomNav(),
    );
  }
}

class _ProductList extends StatelessWidget {
  Future<List<Product>> _fetchProducts() async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('productos')
            .get(); 
    return querySnapshot.docs.map((doc) {
      return Product.fromFirestore(doc);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final products = snapshot.data!;

        if (products.isEmpty) {
          return const Center(child: Text('No hay productos en stock.'));
        }

        return ListView.builder(
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
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ), 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ), // Adjusted border radius
      color: const Color.fromARGB(
        255,
        75,
        74,
        74,
      ), 
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.nombre,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ), 
            ),
            Text(
              '${product.stock}', 
              style: const TextStyle(
                color: Colors.tealAccent,
                fontSize: 18,
              ), 
            ),
          ],
        ),
      ),
    );
  }
}
