import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_application_1/presentation/widgets/custom_bottom_navbar.dart';
import 'package:go_router/go_router.dart';

/// Entidad que representa un Pedido.
class Pedido {
  final String numero;
  final String direccion;
  final String total;
  final String estado;

  Pedido({
    required this.numero,
    required this.direccion,
    required this.total,
    required this.estado,
  });
}

class ControlPedidosScreen extends StatelessWidget {
  ControlPedidosScreen({super.key});

  /// Lista de ejemplo de pedidos.
  final List<Pedido> pedidos = [
    Pedido(
      numero: '#00004',
      direccion: 'Calle Siempre Viva 15',
      total: '\$15.000',
      estado: 'Para preparar',
    ),
    Pedido(
      numero: '#00003',
      direccion: 'Calle Siempre Viva 16',
      total: '\$15.000',
      estado: 'Para preparar',
    ),
    Pedido(
      numero: '#00002',
      direccion: 'Calle Siempre Viva 17',
      total: '\$15.000',
      estado: 'Enviado',
    ),
    Pedido(
      numero: '#00001',
      direccion: 'Calle Siempre Viva 18',
      total: '\$15.000',
      estado: 'Finalizado',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          // Encabezado fijo en la parte superior.
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Control de pedidos',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
          // La lista ocupa el resto del espacio.
          Expanded(
            child: ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];
                return Card(
                  color: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      'Pedido ${pedido.numero}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Dirección: ${pedido.direccion}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total: ${pedido.total}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Estado: ${pedido.estado}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.green),
                      onPressed: () {
                        // Implementa la acción para eliminar el pedido.
                      },
                    ),
                    // Al pulsar la tarjeta se navega a la pantalla de detalle usando GoRouter.
                    onTap: () {
                      context.push('/pedido-detail', extra: pedido);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}