import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_application_1/presentation/widgets/custom_bottom_navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Entidad que representa un Pedido.
class Pedido {
  final String id;
  final String? numeroDisplay;
  final String direccion;
  final double total;
  final String estado;
  final DateTime purchaseDate;

  Pedido({
    required this.id,
    this.numeroDisplay,
    required this.direccion,
    required this.total,
    required this.estado,
    required this.purchaseDate,
  });

  // --- Mapeo automático de estado ---
  static String mapEstado(dynamic raw) {
    if (raw == null) return 'Para preparar';
    final value = raw.toString().toLowerCase();
    if (value == 'pending' ||
        value == 'pendiente' ||
        value == 'para preparar') {
      return 'Para preparar';
    } else if (value == 'shipped' || value == 'enviado') {
      return 'Enviado';
    } else if (value == 'completed' || value == 'finalizado') {
      return 'Finalizado';
    } else {
      return 'Para preparar';
    }
  }

  factory Pedido.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final billingInfo = data['billingInfo'] as Map<String, dynamic>?;
    final items = data['items'] as List<dynamic>?;
    final timestamp = data['purchaseDate'] as Timestamp?;

    double calculatedTotal = 0.0;
    if (items != null) {
      for (var item in items) {
        if (item is Map<String, dynamic>) {
          final price = (item['price'] as num?)?.toDouble() ?? 0.0;
          final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
          calculatedTotal += price * quantity;
        }
      }
    }

    return Pedido(
      id: doc.id,
      direccion: billingInfo?['direccion'] ?? 'Dirección no disponible',
      total: calculatedTotal,
      estado: mapEstado(data['status']),
      purchaseDate: timestamp?.toDate() ?? DateTime.now(),
    );
  }
}

class ControlPedidosScreen extends StatefulWidget {
  const ControlPedidosScreen({super.key});

  @override
  State<ControlPedidosScreen> createState() => _ControlPedidosScreenState();
}

class _ControlPedidosScreenState extends State<ControlPedidosScreen> {
  Future<List<Pedido>> _fetchPedidos() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      final List<Pedido> fetchedPedidos =
          snapshot.docs.map((doc) => Pedido.fromFirestore(doc)).toList();

      // Ordenar por fecha de compra ascendente y asignar número de display
      fetchedPedidos.sort((a, b) => a.purchaseDate.compareTo(b.purchaseDate));

      for (int i = 0; i < fetchedPedidos.length; i++) {
        fetchedPedidos[i] = Pedido(
          id: fetchedPedidos[i].id,
          numeroDisplay: (i + 1).toString(),
          direccion: fetchedPedidos[i].direccion,
          total: fetchedPedidos[i].total,
          estado: fetchedPedidos[i].estado,
          purchaseDate: fetchedPedidos[i].purchaseDate,
        );
      }

      return fetchedPedidos;
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/admin-profile'),
        ),
        title: const Text(
          'Control de Pedidos',
          style: TextStyle(color: Colors.white),
        ),
      ),
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
            child: FutureBuilder<List<Pedido>>(
              future: _fetchPedidos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.tealAccent),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error al cargar pedidos: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay pedidos disponibles.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                } else {
                  final pedidos = snapshot.data!;
                  return ListView.builder(
                    itemCount: pedidos.length,
                    itemBuilder: (context, index) {
                      final pedido = pedidos[index];
                      return Card(
                        color: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            'Pedido #${pedido.numeroDisplay}',
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
                                'Total: \$${pedido.total.toStringAsFixed(2)}',
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
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}
