import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_application_1/presentation/widgets/custom_bottom_navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  Future<int> _fetchPendingOrdersCount() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('orders')
              .where('status', isNotEqualTo: 'completed')
              .get();
      return snapshot.docs.length;
    } catch (e) {
      print("Error fetching pending orders: $e");
      return 0;
    }
  }

  Future<int> _fetchCompletedOrdersCount() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: 'completed')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print("Error fetching completed orders: $e");
      return 0;
    }
  }

  Future<int> _fetchProductsCount() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('productos').get();
      return snapshot.docs.length;
    } catch (e) {
      print("Error fetching products: $e");
      return 0;
    }
  }

  Future<int> _fetchMonthlySales() async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: 'completed')
          .where('purchaseDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .get();
      int total = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        total += ((data['totalAmount'] ?? 0) as num).toInt();
      }
      return total;
    } catch (e) {
      print("Error fetching monthly sales: $e");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              'Perfil del Administrador',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromARGB(
                255,
                75,
                74,
                74,
              ), // Color de fondo del avatar
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
            FutureBuilder<int>(
              future: _fetchMonthlySales(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return _buildStatItem('Ventas totales del mes', '...');
                return _buildStatItem(
                    'Ventas totales del mes', '\$${snapshot.data}');
              },
            ),
            FutureBuilder<int>(
              future: _fetchProductsCount(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return _buildStatItem('Productos activos', '...');
                return _buildStatItem('Productos activos', '${snapshot.data}');
              },
            ),
            FutureBuilder<int>(
              future: _fetchPendingOrdersCount(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return _buildStatItem('Pedidos pendientes', '...');
                return _buildStatItem('Pedidos pendientes', '${snapshot.data}');
              },
            ),
            FutureBuilder<int>(
              future: _fetchCompletedOrdersCount(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return _buildStatItem('Pedidos finalizados', '...');
                return _buildStatItem(
                    'Pedidos finalizados', '${snapshot.data}');
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: GestureDetector(
                onTap: () {
                  context.go(
                    '/control-stock',
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal, // Color llamativo
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.inventory_2, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Ir al Control de Stock',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(),
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
