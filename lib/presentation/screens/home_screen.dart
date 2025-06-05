import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_application_1/presentation/widgets/custom_bottom_navbar.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          // Permite que los hijos ocupen todo el ancho
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Encabezado en la parte superior
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                child: Text(
                  'Menú Principal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            ),
            // Espacio restante para centrar verticalmente los botones
            Expanded(
              child: Center(
                child: Column(
                  // El tamaño del Column se ajusta al contenido
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuItem(context, 'Productos', '/categories'),
                    const SizedBox(height: 20),
                    _buildMenuItem(context, 'Agregar Producto', '/add-product'),
                    const SizedBox(height: 20),
                    _buildMenuItem(context, 'Control de Stock', '/control-stock'),
                    const SizedBox(height: 20),
                    _buildMenuItem(context, 'Control de Pedidos', '/control-pedidos'),
                    const SizedBox(height: 20),
                    _buildMenuItem(context, 'Perfil del Administrador', '/admin-profile'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String route) {
    return ElevatedButton(
      onPressed: () => context.go(route),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.tealAccent,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}