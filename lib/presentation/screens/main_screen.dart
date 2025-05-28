import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/custom_app_bar.dart';
// import 'package:flutter_application_1/widgets/custom_bottom_navbar.dart'; // Eliminar importación si ya no se usa
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centrar contenido verticalmente
        crossAxisAlignment: CrossAxisAlignment.stretch, // Estirar horizontalmente
        children: [
          const SizedBox(height: 40),
          const Text(
            'Modo administrador',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          const Center(
            child: Text(
              'JK\nTECNO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                height: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0), // Corregido a vertical
            child: ElevatedButton(
              onPressed: () {
                context.go('/home'); // Navegar a la home_screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent, // Color del botón
                padding: const EdgeInsets.symmetric(vertical: 15.0), // Padding interno del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                ),
              ),
              child: const Text(
                'Comenzar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Color del texto
                ),
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: const CustomBottomNav(), // Eliminado
    );
  }
}
