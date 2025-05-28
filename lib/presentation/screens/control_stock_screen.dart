import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Define a simple Product class
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
        await FirebaseFirestore.instance.collection('productos').get(); // Assuming 'productos' collection

    return snapshot.docs
        .map((doc) => Product.fromFirestore(doc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 75, 74, 74),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/home');
          },
        ),
        title: const Text(
          'Control de stock',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40), // Adjusted spacing based on image
          const Text(
            'Control de stock', // Title from the image
            style: TextStyle(
              color: Colors.white,
              fontSize: 24, // Adjusted font size based on image
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20), // Spacing between title and list
          Expanded(child: _ProductList()), // ProductList widget
        ],
      ),
    );
  }
}

// Widget to display the list of products
class _ProductList extends StatelessWidget {
  Future<List<Product>> _fetchProducts() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('productos').get(); // Assuming 'productos' collection
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

// Widget to display a single product item
class _ProductItem extends StatelessWidget {
  final Product product;

  const _ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 4, // Removed elevation for a flatter look like the image
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Adjusted margin
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Adjusted border radius
      color: const Color.fromARGB(255, 75, 74, 74), // Color from the image background of items
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Padding inside the card
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.nombre,
              style: const TextStyle(color: Colors.white, fontSize: 18), // Adjusted font size
            ),
            Text(
              '${product.stock}', // Display stock count
              style: const TextStyle(color: Colors.tealAccent, fontSize: 18), // Color from image
            ),
          ],
        ),
      ),
    );
  }
} 