import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_application_1/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_application_1/presentation/widgets/custom_bottom_navbar.dart';
import 'package:go_router/go_router.dart';

class UpdateProductScreen extends StatefulWidget {
  final String categoriaId;
  final String productoId;
  final Map<String, dynamic> datosProducto;

  const UpdateProductScreen({
    super.key,
    required this.categoriaId,
    required this.productoId,
    required this.datosProducto,
  });

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();
  bool _enOferta = false;
  File? _imagenSeleccionada;
  String _categoriaSeleccionada = '';
  final _picker = ImagePicker();
  String? _imagenExistente;

  @override
  void initState() {
    super.initState();
    final p = widget.datosProducto;
    _nombreController.text = p['nombre'] ?? '';
    _descripcionController.text = p['descripcion'] ?? '';
    _precioController.text = p['precio']?.toString() ?? '';
    _stockController.text = p['stock']?.toString() ?? '';
    _enOferta = p['enOferta'] ?? false;
    _categoriaSeleccionada = widget.categoriaId;
    _imagenExistente = p['imagenUrl'];
  }

  Future<void> seleccionarImagen() async {
    final imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        _imagenSeleccionada = File(imagen.path);
      });
    }
  }

  Future<String> subirImagen(File imagen) async {
    final nombreArchivo = path.basename(imagen.path);
    final ref =
        FirebaseStorage.instance.ref().child('productos/$nombreArchivo');
    await ref.putFile(imagen);
    return await ref.getDownloadURL();
  }

  Future<void> actualizarProducto() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      String imagenUrl = _imagenExistente ?? '';
      if (_imagenSeleccionada != null) {
        imagenUrl = await subirImagen(_imagenSeleccionada!);
      }

      final productoRef = FirebaseFirestore.instance
          .collection('productos')
          .doc(widget.productoId);

      await productoRef.update({
        'nombre': _nombreController.text.trim(),
        'descripcion': _descripcionController.text.trim(),
        'precio': double.parse(_precioController.text),
        'stock': int.parse(_stockController.text),
        'enOferta': _enOferta,
        'imagenUrl': imagenUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto actualizado')),
      );
      context.pop();
    } catch (e) {
      print('Error al actualizar producto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Actualizar producto',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nombreController,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: _inputDecoration('Nombre'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descripcionController,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: _inputDecoration('Descripción'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _precioController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: _inputDecoration('Precio'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Requerido';
                    if (double.tryParse(value) == null)
                      return 'Número inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: _inputDecoration('Stock inicial'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Requerido';
                    if (int.tryParse(value) == null) return 'Número inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Imagen del producto',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _imagenSeleccionada != null
                        ? Image.file(_imagenSeleccionada!,
                            height: 150, width: 150, fit: BoxFit.cover)
                        : (_imagenExistente != null
                            ? Image.network(_imagenExistente!,
                                height: 150, width: 150, fit: BoxFit.cover)
                            : const Text('No hay imagen seleccionada',
                                style: TextStyle(color: Colors.white))),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: seleccionarImagen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Seleccionar imagen'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                SwitchListTile(
                  title: Text(
                    '¿Está en oferta?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.lightBlue[600]),
                  ),
                  value: _enOferta,
                  onChanged: (val) => setState(() => _enOferta = val),
                  activeColor: const Color(0xff07CAB3),
                  inactiveThumbColor: const Color.fromARGB(255, 75, 74, 74),
                  inactiveTrackColor: Colors.grey[300],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff07CAB3),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onPressed: actualizarProducto,
                  child: const Text('Actualizar producto'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 20, color: Colors.white),
        filled: true,
        fillColor: const Color.fromARGB(255, 75, 74, 74),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      );

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }
}
