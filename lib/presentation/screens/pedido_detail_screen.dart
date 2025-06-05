import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/control_pedidos_screen.dart';

import 'package:flutter_application_1/presentation/widgets/custom_bottom_navbar.dart';
import 'package:flutter_application_1/presentation/widgets/custom_app_bar.dart';


/// Pantalla de detalle del pedido, donde se muestran los datos y se puede cambiar el estado.
class PedidoDetailScreen extends StatefulWidget {
  final Pedido pedido;

  const PedidoDetailScreen({super.key, required this.pedido});

  @override
  State<PedidoDetailScreen> createState() => _PedidoDetailScreenState();
}

class _PedidoDetailScreenState extends State<PedidoDetailScreen> {
  // Lista de posibles estados.
  final List<String> estados = ['Para preparar', 'Enviado', 'Finalizado'];
  late String selectedEstado;

  @override
  void initState() {
    super.initState();
    // Inicializamos con el estado actual del pedido.
    selectedEstado = widget.pedido.estado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Detalle del Pedido ${widget.pedido.numero}'),
        backgroundColor: Colors.grey[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Tarjeta con los datos del pedido.
            Card(
              color: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedido ${widget.pedido.numero}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Dirección: ${widget.pedido.direccion}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: ${widget.pedido.total}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Estado actual: ${widget.pedido.estado}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            /// Caja para cambiar entre los estados del pedido.
           // Dentro del widget PedidoDetailScreen (dentro del build, en el body)
Container(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  decoration: BoxDecoration(
    color: Colors.grey[800],
    borderRadius: BorderRadius.circular(10),
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Center(
        child: Text(
          'Cambiar estado:',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 8),
      // El DropdownButton se encarga de mostrar las opciones al hacer click.
      DropdownButton<String>(
        dropdownColor: Colors.grey[800],
        value: selectedEstado,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        underline: const SizedBox(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        onChanged: (newValue) {
          setState(() {
            selectedEstado = newValue!;
            // Aquí podrías agregar lógica para actualizar el estado en tu backend o en tu state management.
          });
        },
        items: estados.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Center(
              child: Text(
                value,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }).toList(),
      ),
    ],
  ),
)
          ],
        ),
      ),
    );
  }
}