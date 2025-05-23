import 'package:flutter_application_1/presentation/screens/products.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ProductsScreen())
  ],
);
