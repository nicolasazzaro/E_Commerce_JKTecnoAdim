import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/custom_app_bar.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        crossAxisAlignment: CrossAxisAlignment.stretch, 
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
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0), 
            child: ElevatedButton(
              onPressed: () {
                context.go('/admin-profile');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent, 
                padding: const EdgeInsets.symmetric(vertical: 15.0), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), 
                ),
              ),
              child: const Text(
                'Comenzar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
