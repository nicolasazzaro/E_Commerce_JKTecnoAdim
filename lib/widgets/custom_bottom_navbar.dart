import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 75, 74, 74),
      ),
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
              context.go('/');
            },
            icon: const Icon(
              Icons.dehaze,
              color: Colors.black,
              size: 40,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              context.go('/');
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
