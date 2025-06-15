import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/entities/product.dart';
import 'package:flutter_application_1/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_application_1/presentation/widgets/custom_bottom_navbar.dart';

class ProductsByCategorieScreen extends StatelessWidget {
  final String categoriaId;

  const ProductsByCategorieScreen({super.key, required this.categoriaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance
                    .collection('categorias')
                    .doc(categoriaId)
                    .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              final data = snapshot.data?.data() as Map<String, dynamic>?;
              final nombreCategoria = data?['nombre'] ?? 'Categoría';

              return Column(
                children: [
                  const Text(
                    "Productos",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nombreCategoria,
                    style: const TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('productos')
                      .where('categoriaId', isEqualTo: categoriaId)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return const Center(child: Text('Error cargando productos'));
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());

                final productos = snapshot.data!.docs;

                if (productos.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay productos en esta categoría',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final doc = productos[index];
                    final producto = Product.fromMap(
                      doc.id,
                      doc.data() as Map<String, dynamic>,
                    );
                    return _ProductCard(producto: producto);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product producto;

  const _ProductCard({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.network(
              producto.imagenUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${producto.precio}',
                    style: const TextStyle(color: Colors.tealAccent),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.teal),
              onPressed: () {
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                final confirmacion = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        backgroundColor: Colors.grey[900],
                        title: const Text(
                          'Confirmar eliminación',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          '¿Estás seguro de eliminar este producto?',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.teal),
                            ),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Eliminar',
                            ),
                          ),
                        ],
                      ),
                );

                if (confirmacion == true) {
                  await FirebaseFirestore.instance
                      .collection('productos')
                      .doc(producto.id)
                      .delete();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
