import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/custom_app_bar.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Menú Principal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            const SizedBox(height: 40),
            _buildMenuItem(context, 'Productos', '/categories'),
            const SizedBox(height: 20),
            _buildMenuItem(context, 'Agregar Producto', '/add-product'),
            const SizedBox(height: 20),
            _buildMenuItem(context, 'Control de Stock', '/control-stock'),
            const SizedBox(height: 20),
            _buildMenuItem(context, 'Perfil del Administrador', '/admin-profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String route) {
    return ElevatedButton(
      onPressed: () {
        context.go(route);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.tealAccent,
        padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
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