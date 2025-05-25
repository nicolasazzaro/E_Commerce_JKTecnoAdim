import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/entities/categorie.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  String _nombre = '';
  String _descripcion = '';
  double _precio = 0;
  int _stock = 0;
  bool _enOferta = false;
  String _categoriaSeleccionada = '';

  Future<List<Categorie>> _fetchCategorias() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categorias').get();

    return snapshot.docs
        .map((doc) => Categorie(id: doc.id, nombre: doc.get('nombre') ?? ''))
        .toList();
  }

  Future<void> guardarProducto() async {
    try {
      if (_formKey.currentState!.validate()) {
        if (_categoriaSeleccionada.isEmpty) {
          throw Exception('Debe seleccionar una categoría');
        }

        _formKey.currentState!.save();

        await FirebaseFirestore.instance
            .collection('categorias')
            .doc(_categoriaSeleccionada)
            .collection('productos')
            .add({
          'nombre': _nombre,
          'descripcion': _descripcion,
          'precio': _precio,
          'stock': _stock,
          'enOferta': _enOferta,
        });

        print('Producto guardado exitosamente');
      }
    } catch (e) {
      print('Error al guardar producto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: FutureBuilder<List<Categorie>>(
            future: _fetchCategorias(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No hay categorías disponibles'),
                );
              }
              final categorias = snapshot.data!;

              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Requerido' : null,
                      onSaved: (value) => _nombre = value!.trim(),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Descripción'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Requerido' : null,
                      onSaved: (value) => _descripcion = value!.trim(),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Precio'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requerido';
                        if (double.tryParse(value) == null) return 'Número inválido';
                        return null;
                      },
                      onSaved: (value) => _precio = double.parse(value!),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Stock inicial'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requerido';
                        if (int.tryParse(value) == null) return 'Número inválido';
                        return null;
                      },
                      onSaved: (value) => _stock = int.parse(value!),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Categoría'),
                      items: categorias
                          .map(
                            (cat) => DropdownMenuItem<String>(
                              value: cat.id,
                              child: Text(cat.nombre),
                            ),
                          )
                          .toList(),
                      value: _categoriaSeleccionada.isNotEmpty
                          ? _categoriaSeleccionada
                          : null,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _categoriaSeleccionada = val;
                          });
                        }
                      },
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Selecciona una categoría' : null,
                    ),
                    SwitchListTile(
                      title: const Text('¿Está en oferta?'),
                      value: _enOferta,
                      onChanged: (val) {
                        setState(() {
                          _enOferta = val;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: guardarProducto,
                      child: const Text('Guardar producto'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
