import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/entities/categorie.dart';
import 'package:flutter_application_1/widgets/custom_app_bar.dart';
import 'package:flutter_application_1/widgets/custom_bottom_navbar.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  // Función para crear categoría con un producto de prueba
Future<void> crearCategoria(String nombreCategoria) async {
  try {
    await FirebaseFirestore.instance.collection('categorias').add({
      'nombre': nombreCategoria,
    });

    print('Categoría creada correctamente.');
  } catch (e) {
    print('Error al crear categoría: $e');
    rethrow;
  }
}

  // Diálogo para crear una nueva categoría
  // Diálogo para crear una nueva categoría
Future<void> _mostrarDialogoNuevaCategoria(BuildContext context) async {
  final TextEditingController _nameCategoriecontroller = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Nueva Categoría',
          style: TextStyle(color: Colors.white),
        ),
        content: TextFormField(
          controller: _nameCategoriecontroller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Nombre de la categoría',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar', style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () async {
              final nombre = _nameCategoriecontroller.text.trim();
              if (nombre.isNotEmpty) {
                await crearCategoria(nombre); // ← Cambio aquí
              }
              Navigator.of(context).pop();
            },
            child: const Text('Guardar', style: TextStyle(color: Colors.greenAccent)),
          ),
        ],
      );
    },
  );
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
            "Productos",
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(child: _CategoriaList()),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff07CAB3),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () => _mostrarDialogoNuevaCategoria(context),
            child: const Text('Crear nueva categoría'),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}

class _CategoriaList extends StatelessWidget {
  Future<List<Categorie>> _fetchCategorias() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('categorias').get();
    return querySnapshot.docs.map((doc) {
      return Categorie(id: doc.id, nombre: doc.get('nombre') ?? 'Sin nombre');
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Categorie>>(
      future: _fetchCategorias(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final categorias = snapshot.data!;

        if (categorias.isEmpty) {
          return const Center(child: Text('No hay categorías.'));
        }

        return ListView.builder(
          itemCount: categorias.length,
          itemBuilder: (context, index) {
            return _CategoriaItem(categoria: categorias[index]);
          },
        );
      },
    );
  }
}

// Ítem individual de categoría
class _CategoriaItem extends StatelessWidget {
  final Categorie categoria;

  const _CategoriaItem({required this.categoria});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.grey[900],
      child: ListTile(
        title: Text(
          categoria.nombre,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        leading: const Icon(Icons.category, color: Colors.white),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          context.push('/categories/${categoria.id}');
        },
      ),
    );
  }
}
