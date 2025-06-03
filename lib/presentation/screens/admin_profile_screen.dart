import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 75, 74, 74), // Color de fondo
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Icono de retroceso
          onPressed: () {
            context.go('/home'); // Navegar a la home_screen
          },
        ),
        title: const Text(
          'JKtecno', // Título en la AppBar
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Perfil del Administrador',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromARGB(255, 75, 74, 74), // Color de fondo del avatar
              child: Icon(
                Icons.person, // Icono de perfil
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Lionel Messi', // Nombre de ejemplo
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            _buildStatItem('Ventas totales del mes', '\$42000'), // Dato de ejemplo
            _buildStatItem('Productos activos', '150'), // Dato de ejemplo
            _buildStatItem('Pedidos pendientes', '8'), // Dato de ejemplo
            _buildStatItem('Pedidos finalizados', '15'), // Dato de ejemplo
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 75, 74, 74), // Color de fondo
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.tealAccent, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
