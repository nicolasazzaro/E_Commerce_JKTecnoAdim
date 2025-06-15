import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(color: Color.fromARGB(255, 75, 74, 74)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              context.go('/');
            },
            icon: const Icon(
              Icons.home_outlined,
              color: Colors.black,
              size: 40,
            ),
          ),
          
          IconButton(
            enableFeedback: false,
            onPressed: () {
              context.go('/categories');
            },
            icon: const Icon(
              Icons.widgets_outlined,
              color: Colors.black,
              size: 38,
            ),
          ),

          IconButton(
            enableFeedback: false,
            onPressed: () {
              context.go('/add-product');
            },
            icon: const Icon(Icons.add, color: Colors.black, size: 45),
          ),

          IconButton(
            enableFeedback: false,
            onPressed: () {
              //context.go('/pedidos');
            },
            icon: const Icon(
              Icons.local_shipping_outlined,
              color: Colors.black,
              size: 40,
            ),
          ),

          IconButton(
            enableFeedback: false,
            onPressed: () {
              context.go('/admin-profile');
            },
            icon: const Icon(
              Icons.person_outline,
              color: Colors.black,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
