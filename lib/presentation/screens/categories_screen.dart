import 'package:flutter/material.dart';
import 'package:flutter_application_1/entities/categorie.dart';
import 'package:flutter_application_1/presentation/providers/categories_provider.dart';
import 'package:flutter_application_1/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_application_1/presentation/widgets/custom_bottom_navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final TextEditingController _nameCategoriecontroller = TextEditingController();

  Future<void> _mostrarDialogoNuevaCategoria() async {
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
                  await ref.read(categoriaProvider.notifier).crearCategoria(nombre);
                }
                _nameCategoriecontroller.clear();
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
    final categorias = ref.watch(categoriaProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Productos",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: categorias.isEmpty
                ? const Center(child: Text('No hay categorías.', style: TextStyle(color: Colors.white)))
                : ListView.builder(
                    itemCount: categorias.length,
                    itemBuilder: (context, index) {
                      final categoria = categorias[index];
                      return _CategoriaItem(categoria: categoria);
                    },
                  ),
          ),
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
            onPressed: _mostrarDialogoNuevaCategoria,
            child: const Text('Crear nueva categoría'),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}

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
